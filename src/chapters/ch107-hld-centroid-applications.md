# Chapter 107: HLD and Centroid Decomposition Applications

## Prerequisites
- Euler tour, segment trees, LCA

## Interview Frequency: ★★★★

HLD enables path queries. Centroid decomposition enables path counting.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| HLD | ★★★★ | Hard | Path queries in O(log²n) |
| Centroid decomp | ★★★ | Hard | Divide and conquer on trees |

---

## 107.1 Heavy-Light Decomposition

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

class HLD {
    int n, timer;
    std::vector<std::vector<int>> adj;
    std::vector<int> parent, depth, heavy, head, pos, sz;
    std::vector<int> seg;
    
    int dfs(int u, int p) {
        parent[u] = p; sz[u] = 1; int maxSize = 0;
        for (int v : adj[u]) {
            if (v == p) continue;
            depth[v] = depth[u] + 1;
            int subSize = dfs(v, u);
            sz[u] += subSize;
            if (subSize > maxSize) { maxSize = subSize; heavy[u] = v; }
        }
        return sz[u];
    }
    
    void decompose(int u, int h) {
        head[u] = h; pos[u] = timer++;
        if (heavy[u] != -1) decompose(heavy[u], h);
        for (int v : adj[u])
            if (v != parent[u] && v != heavy[u]) decompose(v, v);
    }
    
    void segUpdate(int idx, int val, int node, int lo, int hi) {
        if (lo == hi) { seg[node] = val; return; }
        int mid = (lo + hi) / 2;
        if (idx <= mid) segUpdate(idx, val, 2*node, lo, mid);
        else segUpdate(idx, val, 2*node+1, mid+1, hi);
        seg[node] = seg[2*node] + seg[2*node+1];
    }
    
    int segQuery(int ql, int qr, int node, int lo, int hi) {
        if (qr < lo || hi < ql) return 0;
        if (ql <= lo && hi <= qr) return seg[node];
        int mid = (lo + hi) / 2;
        return segQuery(ql, qr, 2*node, lo, mid) + segQuery(ql, qr, 2*node+1, mid+1, hi);
    }
    
public:
    HLD(int n) : n(n), adj(n), parent(n), depth(n), heavy(n,-1), head(n), pos(n), sz(n), seg(4*n,0), timer(0) {}
    
    void addEdge(int u, int v) { adj[u].push_back(v); adj[v].push_back(u); }
    
    void build(int root) { dfs(root, -1); decompose(root, root); }
    
    void update(int u, int val) { segUpdate(pos[u], val, 1, 0, n-1); }
    
    int queryPath(int u, int v) {
        int result = 0;
        while (head[u] != head[v]) {
            if (depth[head[u]] < depth[head[v]]) std::swap(u, v);
            result += segQuery(pos[head[u]], pos[u], 1, 0, n-1);
            u = parent[head[u]];
        }
        if (depth[u] > depth[v]) std::swap(u, v);
        result += segQuery(pos[u], pos[v], 1, 0, n-1);
        return result;
    }
    
    int lca(int u, int v) {
        while (head[u] != head[v]) {
            if (depth[head[u]] < depth[head[v]]) std::swap(u, v);
            u = parent[head[u]];
        }
        return depth[u] < depth[v] ? u : v;
    }
};

int main() {
    HLD hld(6);
    hld.addEdge(0, 1); hld.addEdge(0, 2);
    hld.addEdge(1, 3); hld.addEdge(1, 4); hld.addEdge(2, 5);
    hld.build(0);
    for (int i = 0; i < 6; i++) hld.update(i, i + 1);
    
    std::cout << "Path sum 3 to 5: " << hld.queryPath(3, 5) << "\n";
    std::cout << "LCA(3, 5): " << hld.lca(3, 5) << "\n";
    
    return 0;
}
```

---

## 107.2 Centroid Decomposition

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

class CentroidDecomp {
    int n;
    std::vector<std::vector<int>> adj;
    std::vector<bool> removed;
    std::vector<int> sz;
    
    int getSubtreeSize(int u, int p) {
        sz[u] = 1;
        for (int v : adj[u])
            if (v != p && !removed[v]) sz[u] += getSubtreeSize(v, u);
        return sz[u];
    }
    
    int findCentroid(int u, int p, int treeSize) {
        for (int v : adj[u])
            if (v != p && !removed[v] && sz[v] > treeSize / 2)
                return findCentroid(v, u, treeSize);
        return u;
    }
    
    void decompose(int u) {
        int treeSize = getSubtreeSize(u, -1);
        int centroid = findCentroid(u, -1, treeSize);
        removed[centroid] = true;
        std::cout << "Centroid: " << centroid << "\n";
        for (int v : adj[centroid])
            if (!removed[v]) decompose(v);
    }
    
public:
    CentroidDecomp(int n) : n(n), adj(n), removed(n, false), sz(n) {}
    void addEdge(int u, int v) { adj[u].push_back(v); adj[v].push_back(u); }
    void build() { decompose(0); }
};

int main() {
    CentroidDecomp cd(7);
    cd.addEdge(0, 1); cd.addEdge(0, 2); cd.addEdge(1, 3);
    cd.addEdge(1, 4); cd.addEdge(2, 5); cd.addEdge(2, 6);
    cd.build();
    return 0;
}
```

---

## Summary

| Technique | Query Time | Build | Best For |
|---|---|---|---|
| HLD | O(log² n) | O(n) | Path queries |
| Centroid Decomp | O(n log n) | O(n) | Path counting |
