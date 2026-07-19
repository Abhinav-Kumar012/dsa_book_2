# Chapter 148: Parameterized Algorithms

## Prerequisites
- NP-completeness, graph algorithms

## Interview Frequency: ★

Parameterized algorithms isolate the exponential blowup to a parameter k.

---

## 148.1 FPT and XP

| Class | Definition | Example |
|---|---|---|
| FPT | f(k)·n^{O(1)} | Vertex Cover in O(2^k·n) |
| XP | n^{f(k)} | Clique in O(n^k) |
| W[1] | Hard | Clique (believed not FPT) |

---

## 148.2 Vertex Cover in O(2^k · n)

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// FPT: Find vertex cover of size ≤ k
bool vertexCoverFPT(const std::vector<std::vector<int>>& adj, int k) {
    int n = adj.size();
    
    // Find an edge (u, v)
    int u = -1, v = -1;
    for (int i = 0; i < n; i++)
        for (int j : adj[i])
            if (i < j) { u = i; v = j; goto found; }
    return true; // No edges = vertex cover of size 0
found:
    if (k == 0) return false;
    
    // Branch: include u or include v
    // Try including u: remove u and its edges
    std::vector<std::vector<int>> adj2 = adj;
    adj2[u].clear();
    for (int i = 0; i < n; i++) {
        adj2[i].erase(std::remove(adj2[i].begin(), adj2[i].end(), u), adj2[i].end());
    }
    if (vertexCoverFPT(adj2, k - 1)) return true;
    
    // Try including v
    adj2 = adj;
    adj2[v].clear();
    for (int i = 0; i < n; i++) {
        adj2[i].erase(std::remove(adj2[i].begin(), adj2[i].end(), v), adj2[i].end());
    }
    return vertexCoverFPT(adj2, k - 1);
}

int main() {
    std::vector<std::vector<int>> adj(5);
    adj[0] = {1, 2}; adj[1] = {0, 3}; adj[2] = {0, 4};
    adj[3] = {1}; adj[4] = {2};
    
    for (int k = 0; k <= 3; k++)
        std::cout << "VC of size " << k << ": " 
                  << (vertexCoverFPT(adj, k) ? "yes" : "no") << "\n";
    return 0;
}
```

---

## 148.3 Kernelization

Reduce instance to equivalent one of size f(k). Example: Vertex Cover has a 2k kernel (Buss reduction).

---

## 148.4 Color Coding

Randomly color vertices with k colors. A k-path exists iff all colors appear on some path. Repeat O(e^k) times.

---

## Summary

| Technique | Time | Example Problem |
|---|---|---|
| Branching | O(2^k · n) | Vertex Cover |
| Kernelization | poly(n) + f(k) | Vertex Cover |
| Color Coding | O(e^k · n) | k-Path |
| Iterative Compression | O(2^k · n) | Feedback Vertex Set |
