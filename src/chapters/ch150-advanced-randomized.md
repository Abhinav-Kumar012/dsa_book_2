# Chapter 150: Advanced Randomized Algorithms

## Prerequisites
- Probability basics, graph algorithms

## Interview Frequency: ★★

Advanced probabilistic techniques for algorithms.

---

## 150.1 Karger's Min Cut

Random contraction algorithm. Repeat O(n² log n) times for high probability.

```cpp
#include <iostream>
#include <vector>
#include <random>
#include <algorithm>
#include <climits>

int kargerMinCut(std::vector<std::vector<int>> adj, std::mt19937& rng) {
    int n = adj.size();
    std::vector<int> vertex(n);
    std::iota(vertex.begin(), vertex.end(), 0);
    int remaining = n;
    
    while (remaining > 2) {
        // Pick random edge
        int totalEdges = 0;
        for (int i = 0; i < remaining; i++)
            totalEdges += adj[i].size();
        
        std::uniform_int_distribution<int> dist(0, totalEdges - 1);
        int edge = dist(rng);
        
        int u = 0;
        while (edge >= (int)adj[u].size()) {
            edge -= adj[u].size();
            u++;
        }
        int v = adj[u][edge];
        
        // Merge u and v: move v's edges to u
        for (int w : adj[v]) {
            if (w != u) adj[u].push_back(w);
        }
        adj[u].erase(std::remove(adj[u].begin(), adj[u].end(), u), adj[u].end());
        
        // Replace v with u in all adjacency lists
        for (int i = 0; i < remaining; i++) {
            for (int& x : adj[i])
                if (x == v) x = u;
            adj[i].erase(std::remove(adj[i].begin(), adj[i].end(), v), adj[i].end());
        }
        
        // Remove v from adjacency
        adj.erase(adj.begin() + v);
        remaining--;
    }
    
    return adj[0].size();
}

int main() {
    std::vector<std::vector<int>> adj = {{1,2},{0,2,3},{0,1,3},{1,2}};
    std::mt19937 rng(42);
    
    int minCut = INT_MAX;
    for (int i = 0; i < 100; i++) {
        auto adjCopy = adj;
        minCut = std::min(minCut, kargerMinCut(adjCopy, rng));
    }
    std::cout << "Min cut: " << minCut << "\n"; // 2
    return 0;
}
```

---

## 150.2 Chernoff Bounds

Pr[X > (1+δ)μ] < (e^δ / (1+δ)^(1+δ))^μ

Used to bound deviation of sum of independent random variables.

---

## 150.3 Schwartz-Zippel Lemma

A non-zero polynomial of degree d over a field has at most d/|S| fraction of roots in S. Used for polynomial identity testing.

---

## 150.4 Power of Two Choices

With two random choices instead of one, max load drops from Θ(log n / log log n) to Θ(log log n).

---

## Summary

| Technique | Application | Key Bound |
|---|---|---|
| Karger's | Min cut | O(n² log n) runs |
| Chernoff | Concentration | Exponential tail |
| Schwartz-Zippel | Polynomial testing | d/|S| error |
| Two choices | Load balancing | Θ(log log n) max |
