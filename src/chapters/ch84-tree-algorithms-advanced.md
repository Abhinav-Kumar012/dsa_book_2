# Chapter 84: Advanced Tree Algorithms

## Prerequisites

- Tree basics, DFS, LCA
- Tree DP

## Interview Frequency: ★★★

Advanced tree techniques appear in **Google**, **Meta**, and **ByteDance** interviews.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Rerooting DP | ★★★ | Medium-Hard | DP from all roots |
| Virtual Trees | ★★ | Hard | Compressed trees |
| Centroid Decomposition | ★★★ | Hard | Divide and conquer |
| Tree Flattening | ★★★★ | Medium | Euler tour |

---

## 84.1 Rerooting DP

Compute DP values for every node as root in O(n).

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Problem: For each node, find the maximum distance to any other node
class RerootingDP {
    int n;
    std::vector<std::vector<int>> adj;
    std::vector<int> down, up, ans;
    
    int dfsDown(int u, int p) {
        int d = 0;
        for (int v : adj[u]) {
            if (v != p) {
                d = std::max(d, dfsDown(v, u) + 1);
            }
        }
        down[u] = d;
        return d;
    }
    
    void dfsUp(int u, int p, int pUp) {
        up[u] = pUp;
        
        // Collect top 2 down values from children
        int max1 = 0, max2 = 0;
        for (int v : adj[u]) {
            if (v != p) {
                int val = down[v] + 1;
                if (val > max1) { max2 = max1; max1 = val; }
                else if (val > max2) max2 = val;
            }
        }
        
        for (int v : adj[u]) {
            if (v != p) {
                int val = down[v] + 1;
                int use = (val == max1) ? max2 : max1;
                int newUp = std::max(pUp + 1, use + 1);
                dfsUp(v, u, newUp);
            }
        }
        
        ans[u] = std::max(down[u], up[u]);
    }
    
public:
    RerootingDP(int n) : n(n), adj(n), down(n), up(n), ans(n) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    std::vector<int> solve(int root) {
        dfsDown(root, -1);
        dfsUp(root, -1, 0);
        return ans;
    }
};

int main() {
    //       0
    //      / \
    //     1   2
    //    /|   |
    //   3  4  5
    
    RerootingDP tree(6);
    tree.addEdge(0, 1);
    tree.addEdge(0, 2);
    tree.addEdge(1, 3);
    tree.addEdge(1, 4);
    tree.addEdge(2, 5);
    
    auto ans = tree.solve(0);
    
    std::cout << "Max distance from each node:\n";
    for (int i = 0; i < 6; i++)
        std::cout << "  Node " << i << ": " << ans[i] << "\n";
    
    return 0;
}
```

---

## 84.2 Virtual Trees

Compress a tree to only include nodes of interest + their LCAs. Used when answering queries on a subset of nodes.

**Key idea**: Sort nodes by Euler tour order, insert LCAs of consecutive pairs.

---

## 84.3 Centroid Decomposition

Recursively decompose tree at centroids. Each node appears in O(log n) levels.

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
            if (v != p && !removed[v])
                sz[u] += getSubtreeSize(v, u);
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
        
        // Process centroid
        std::cout << "Centroid: " << centroid << "\n";
        
        for (int v : adj[centroid])
            if (!removed[v])
                decompose(v);
    }
    
public:
    CentroidDecomp(int n) : n(n), adj(n), removed(n, false), sz(n) {}
    
    void addEdge(int u, int v) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    void build() { decompose(0); }
};

int main() {
    CentroidDecomp cd(7);
    cd.addEdge(0, 1); cd.addEdge(0, 2);
    cd.addEdge(1, 3); cd.addEdge(1, 4);
    cd.addEdge(2, 5); cd.addEdge(2, 6);
    
    cd.build();
    return 0;
}
```

---

## Summary

| Technique | Time | Key Idea | Best For |
|---|---|---|---|
| Rerooting DP | O(n) | DFS down + up | DP from all roots |
| Virtual Trees | O(k log k) | Compress to k nodes | Subset queries |
| Centroid Decomposition | O(n log n) | Recursive centroids | Path counting |
