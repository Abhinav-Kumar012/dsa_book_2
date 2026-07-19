# Chapter 149: Exact Exponential Algorithms

## Prerequisites
- NP-completeness, bitmask DP

## Interview Frequency: ★

Exact algorithms for NP-hard problems with better than brute-force constants.

---

## 149.1 Subset DP (Held-Karp for TSP)

O(2^n · n²) instead of O(n!).

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

int tspHeldKarp(const std::vector<std::vector<int>>& dist) {
    int n = dist.size();
    int full = (1 << n) - 1;
    std::vector<std::vector<int>> dp(1 << n, std::vector<int>(n, INT_MAX));
    dp[1][0] = 0;
    
    for (int mask = 1; mask <= full; mask++) {
        for (int u = 0; u < n; u++) {
            if (!(mask & (1 << u)) || dp[mask][u] == INT_MAX) continue;
            for (int v = 0; v < n; v++) {
                if (mask & (1 << v)) continue;
                int next = mask | (1 << v);
                dp[next][v] = std::min(dp[next][v], dp[mask][u] + dist[u][v]);
            }
        }
    }
    
    int result = INT_MAX;
    for (int u = 1; u < n; u++)
        result = std::min(result, dp[full][u] + dist[u][0]);
    return result;
}

int main() {
    std::vector<std::vector<int>> dist = {{0,10,15,20},{10,0,35,25},{15,35,0,30},{20,25,30,0}};
    std::cout << "TSP (Held-Karp): " << tspHeldKarp(dist) << "\n"; // 80
    return 0;
}
```

---

## 149.2 Inclusion-Exclusion for Counting

Count Hamiltonian paths using inclusion-exclusion over subsets.

---

## 149.3 Measure and Conquer

Refine analysis by tracking multiple parameters, not just input size.

---

## Summary

| Problem | Brute Force | Exact Algorithm |
|---|---|---|
| TSP | O(n!) | O(2^n · n²) |
| Vertex Cover | O(2^n) | O(1.2738^k · n) |
| Max Independent Set | O(2^n) | O(1.1996^n) |
| Graph Coloring | O(k^n) | O(2^n · n) |
