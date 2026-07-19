# Chapter 156: Dynamic Graph Algorithms

## Prerequisites
- Graph algorithms, data structures

## Interview Frequency: ★

Dynamic graph algorithms maintain graph properties under edge insertions and deletions.

---

## 156.1 Problem Types

| Type | Operations | Best Known |
|---|---|---|
| Incremental | Add edges only | O(α(n)) per op |
| Decremental | Remove edges only | O(α(n)) amortized |
| Fully Dynamic | Both | O(√n) amortized |

---

## 156.2 Dynamic Connectivity

Maintain connected components under edge insertions/deletions.

```cpp
#include <iostream>
#include <vector>
#include <set>

// Simple incremental connectivity using DSU
class IncrementalConnectivity {
    std::vector<int> parent, rank_;
    
public:
    IncrementalConnectivity(int n) : parent(n), rank_(n, 0) {
        for (int i = 0; i < n; i++) parent[i] = i;
    }
    
    int find(int x) {
        if (parent[x] != x) parent[x] = find(parent[x]);
        return parent[x];
    }
    
    void addEdge(int u, int v) {
        int pu = find(u), pv = find(v);
        if (pu == pv) return;
        if (rank_[pu] < rank_[pv]) std::swap(pu, pv);
        parent[pv] = pu;
        if (rank_[pu] == rank_[pv]) rank_[pu]++;
    }
    
    bool connected(int u, int v) { return find(u) == find(v); }
};

int main() {
    IncrementalConnectivity gc(6);
    gc.addEdge(0, 1); gc.addEdge(1, 2); gc.addEdge(3, 4);
    
    std::cout << "0-2 connected: " << gc.connected(0, 2) << "\n"; // 1
    std::cout << "0-3 connected: " << gc.connected(0, 3) << "\n"; // 0
    gc.addEdge(2, 3);
    std::cout << "0-3 connected: " << gc.connected(0, 3) << "\n"; // 1
    
    return 0;
}
```

---

## 156.3 Dynamic MST

Maintain MST under edge updates. Uses Euler tour trees + heap for O(log² n) per update.

---

## 156.4 Dynamic Shortest Paths

| Operation | Algorithm | Time |
|---|---|---|
| Decremental APSP | Even-Shiloach | O(n² log n) total |
| Fully Dynamic | Thorup | O(n^{2+ε}) per update |

---

## Summary

| Problem | Incremental | Decremental | Fully Dynamic |
|---|---|---|---|
| Connectivity | O(α(n)) | O(α(n)) | O(√n) |
| MST | O(log² n) | O(log² n) | O(√n) |
| Shortest Path | O(log n) | O(n^{2/3}) | O(n^{2/3}) |
| Bipartiteness | O(√n) | O(√n) | O(√n) |
