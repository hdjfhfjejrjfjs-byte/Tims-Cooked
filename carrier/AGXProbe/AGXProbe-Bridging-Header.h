#import <mach-o/dyld.h>
#import <Foundation/Foundation.h>
#import <IOKit/IOKitLib.h>

int trigger_ane_direct(void);
int ane_probe(int trigger);
void run_decmpfs_leak(const char *base_dir);
void log_from_c(const char* msg);
void run_iosurface_notify_probe(void);
// Private-connection notify lifetime probe (IOSurfaceRaceProbe.c).
void run_ionotify_probe(int race_rounds);

// Cross-zone OOL reclaim spray for the socket-UAF harness (SockUafSpray.c).
#include <stddef.h>
int sockuaf_ool_spray(size_t size, int count, uint64_t fill);
void sockuaf_ool_reset(void);
int sockuaf_ool_count(void);

// Container-manager extension probe (see WQProbe.c).
#include <stdint.h>
int64_t wq_grant(const char *target, const char *group, uint64_t flags);
void wq_revoke(int64_t handle);
int wq_group_available(const char *group);
int64_t wq_token(const char *identifier, uint64_t cls, uint64_t part, uint64_t flags, const char *partDomain);

// CoW / external-object fault storm (SockUafSpray.c).
int cow_probe_run(int rounds, int size_kb, int *stages);

// File-backed CoW storm (SockUafSpray.c).
int cow_file_probe(int rounds, int size_kb, const char *dir, int *stages);

// APFS msync/invalidate racer (SockUafSpray.c).
int apfs_race_probe(int rounds, int size_kb, const char *dir, int *stages);

// Network-surface reachability probe (SockUafSpray.c).
int network_surface_probe(void);

// Route-socket (PF_ROUTE) characterisation probe (SockUafSpray.c).
int route_socket_probe(int *stages);

// VM deferred-reclamation MIG surface probe (SockUafSpray.c).
int vm_reclaim_probe(int *stages);

// External-object / physical-primitive gate (SockUafSpray.c).
int mem_entry_probe(int *stages);

// IOSurface stale-page race probe (SockUafSpray.c).
int iosurf_race_probe(int *stages);

// IOSurface freed-page reclaim-type expansion probe (SockUafSpray.c).
int iosurf_reclaim_probe(const char *dir, int *stages);

// IOSurface freed-page watch probe: does any non-IOSurface allocator take the
// pages while no user mapping pins them? (SockUafSpray.c)
int iosurf_hold_probe(const char *dir, int rounds, int *stages);

// External churn callback for iosurf_hold_probe (Metal buffers).
void hold_set_callback(int (*cb)(int, int));

// Reclaimed-datagram field differential probe (--sockfield).
int sockuaf_field_probe(const char *tag, const int *fds, int nfds, int *stages);
