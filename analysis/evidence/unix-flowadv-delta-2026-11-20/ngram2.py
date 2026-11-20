import re, sys, collections

def load(p):
    out=[]
    for ln in open(p, encoding='utf-8', errors='replace'):
        m=re.match(r'^(0x[0-9a-f]+)\s+([0-9a-f]{8})\s+(\S+)\s*(.*)$', ln.strip())
        if not m: continue
        va,enc,mn,rest=m.group(1),m.group(2),m.group(3),m.group(4)
        # drop annot annotations: keep operands only (before first ';')
        ops=rest.split(';')[0].strip()
        out.append((va,mn,ops))
    return out

def hist(l):
    return collections.Counter(x[1] for x in l)

A=load(sys.argv[1]); B=load(sys.argv[2])
ha,hb=hist(A),hist(B)
print("== mnemonic delta (B-A) ==")
for k in sorted(set(ha)|set(hb)):
    d=hb[k]-ha[k]
    if d: print(f"  {k:10s} A={ha[k]:4d} B={hb[k]:4d} delta={d:+d}")

def norm(mn,rest):
    r=re.sub(r'\b[xw]\d+\b','R',rest)
    r=re.sub(r'\bsp\b','R',r)
    r=re.sub(r'#?-?0x[0-9a-f]+','#',r)
    r=re.sub(r'#-?\d+','#',r)
    return mn+' '+r.strip()

def grams(l,n):
    s=[norm(m,r) for _,m,r in l]
    return collections.Counter(tuple(s[i:i+n]) for i in range(len(s)-n+1))

for n in (2,3):
    ga,gb=grams(A,n),grams(B,n)
    novel=[(g,gb[g]) for g in gb if g not in ga]
    print(f"\n== novel {n}-grams in B: {len(novel)} ==")
    for g,c in sorted(novel, key=lambda t:-t[1])[:50]:
        print(f"  x{c}  {' | '.join(g)}")

# show B line numbers of the biggest novel 3-grams
s=[norm(m,r) for _,m,r in B]
ga=grams(A,3)
idx=collections.defaultdict(list)
for i in range(len(s)-2):
    idx[tuple(s[i:i+3])].append(i)
seen=set()
print("\n== locations in B ==")
nov=[(g,c) for g,c in sorted(((g,grams(B,3)[g]) for g in grams(B,3) if g not in ga), key=lambda t:-t[1])]
for g,c in nov[:12]:
    i=idx[g][0]
    print(f"  x{c} B#{i} @ {B[i][0]} : {g[0]} ; {g[1]} ; {g[2]}")
