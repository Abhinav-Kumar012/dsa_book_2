# Chapter 155: Advanced Graph Theory

## Prerequisites
- Graph algorithms, linear algebra

## Interview Frequency: ★

---

## 155.1 Expander Graphs

Sparse graphs with strong connectivity. Formally: Cheeger constant h(G) > ε > 0 for some fixed ε.

**Properties**:
- Diameter: O(log n)
- Random walk mixes in O(log n) steps
- Spectral gap bounded away from 0

**Applications**: Error-correcting codes, derandomization, communication networks, PCP constructions.

```cpp
#include <iostream>
#include <vector>
#include <random>
#include <cmath>

// Check if graph is a good expander (heuristic)
double expansionRatio(const std::vector<std::vector<int>>& adj) {
    int n = adj.size();
    double bestRatio = 1.0;
    
    // Try random subsets of size n/2
    std::mt19937 rng(42);
    for (int trial = 0; trial < 100; trial++) {
        std::vector<bool> inS(n, false);
        for (int i = 0; i < n / 2; i++) {
            int v;
            do { v = std::uniform_int_distribution<int>(0, n-1)(rng); } while (inS[v]);
            inS[v] = true;
        }
        
        int cutEdges = 0, volS = 0;
        for (int u = 0; u < n; u++) {
            if (inS[u]) {
                volS += adj[u].size();
                for (int v : adj[u])
                    if (!inS[v]) cutEdges++;
            }
        }
        
        if (volS > 0) {
            double ratio = (double)cutEdges / std::min(volS, 2 * n - volS);
            bestRatio = std::min(bestRatio, ratio);
        }
    }
    return bestRatio;
}

int main() {
    // Random 3-regular graph (good expander with high probability)
    int n = 20;
    std::vector<std::vector<int>> adj(n);
    std::mt19937 rng(42);
    for (int i = 0; i < n; i++) {
        while ((int)adj[i].size() < 3) {
            int v = std::uniform_int_distribution<int>(0, n-1)(rng);
            if (v != i && std::find(adj[i].begin(), adj[i].end(), v) == adj[i].end()) {
                adj[i].push_back(v);
                adj[v].push_back(i);
            }
        }
    }
    
    std::cout << "Expansion ratio: " << expansionRatio(adj) << "\n";
    return 0;
}
```

---

## 155.2 Separator Theorems

**Planar separator**: Every planar graph has a vertex set S of size O(√n) whose removal splits the graph into components each of size ≤ 2n/3.

**Lipton-Tarjan**: Used in divide-and-conquer on planar graphs.

---

## 155.3 Minor Theory

A graph H is a **minor** of G if H can be obtained from G by edge deletions, vertex deletions, and edge contractions.

**Robertson-Seymour Theorem**: Any minor-closed property can be tested in O(n³) (huge constant).

**Grid minor theorem**: Every graph with treewidth ≥ k contains a √k × √k grid minor.

---

## 155.4 Treewidth and Clique-Width

| Measure | Definition | FPT Algorithms |
|---|---|---|
| Treewidth | Min bag size in tree decomposition - 1 | Many NP-hard problems |
| Pathwidth | Min bag size in path decomposition - 1 | Subset of treewidth results |
| Clique-width | Min operations to build graph | MSO₁ logic problems |
| Rank-width | Related to clique-width | Similar applications |

---

## Summary

| Concept | Key Property | Application |
|---|---|---|
| Expander | Sparse + well-connected | Codes, derandomization |
| Separator | Small vertex set splits graph | Divide & conquer |
| Minor | Edge contraction closure | Robertson-Seymour |
| Treewidth | Tree-like structure | FPT algorithms |
