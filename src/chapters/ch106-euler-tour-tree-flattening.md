# Chapter 106: Euler Tour and Tree Flattening

## Prerequisites
- DFS, segment trees, trees

## Interview Frequency: ★★★★

Euler tour flattens a tree into an array, enabling segment tree queries on subtrees. **Google**, **Meta**, **Amazon** all test this.

| Query | Technique | Time |
|---|---|---|
| Subtree sum | Euler Tour + Seg Tree | O(log n) |
| Subtree update | Euler Tour + Lazy Seg Tree | O(log n) |
| Is ancestor? | Check tin/tout ranges | O(1) |
| Path queries | HLD needed | O(log² n) |

---

## 106.1 Euler Tour (Entry/Exit Times)

```cpp
#include <iostream>
#include <vector>

class EulerTour {
    int n, timer;
    std::vector<std::vector<int>> adj;
    std::vector<int> tin, tout, flat;
    
    void dfs(int u, int p) {
        tin[u] = timer;
        flat[timer] = u;
        timer++;
        for (int v : adj[u])
            if (v != p) dfs(v, u);
        tout[u] = timer - 1;
    }
    
public:
    EulerTour(int n) : n(n), timer(0), adj(n), tin(n), tout(n), flat(n) {}
    
    void addEdge(int u, int v) { adj[u].push_back(v); adj[v].push_back(u); }
    
    void build(int root) { dfs(root, -1); }
    
    std::pair<int,int> subtreeRange(int u) { return {tin[u], tout[u]}; }
    
    bool isAncestor(int u, int v) {
        return tin[u] <= tin[v] && tout[v] <= tout[u];
    }
};

int main() {
    //       0
    //      / \
    //     1   2
    //    /|   |
    //   3  4  5
    
    EulerTour et(6);
    et.addEdge(0, 1); et.addEdge(0, 2);
    et.addEdge(1, 3); et.addEdge(1, 4); et.addEdge(2, 5);
    et.build(0);
    
    auto [l, r] = et.subtreeRange(1);
    std::cout << "Subtree of 1: [" << l << ", " << r << "]\n";
    std::cout << "0 is ancestor of 5: " << et.isAncestor(0, 5) << "\n";
    std::cout << "1 is ancestor of 5: " << et.isAncestor(1, 5) << "\n";
    
    return 0;
}
```

---

## Summary

| Operation | Time | Notes |
|---|---|---|
| Build Euler Tour | O(n) | DFS |
| Subtree query | O(log n) | With segment tree |
| Ancestor check | O(1) | tin[u] ≤ tin[v] ≤ tout[u] |
