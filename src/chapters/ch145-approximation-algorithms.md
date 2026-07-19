# Chapter 145: Approximation Algorithms

## Prerequisites
- Greedy, LP basics, NP-completeness

## Interview Frequency: ★★

Approximation algorithms provide provable guarantees for NP-hard problems.

| Topic | Frequency | Difficulty | Ratio |
|---|---|---|---|
| Vertex Cover | ★★★ | Medium | 2-approx |
| Set Cover | ★★ | Medium | ln(n)-approx |
| Metric TSP | ★★ | Medium | 3/2-approx |
| Knapsack FPTAS | ★★ | Medium | (1+ε)-approx |

---

## 145.1 Approximation Ratios

An algorithm is α-approximate if for all inputs:
```
ALG(I) ≤ α · OPT(I)  (minimization)
ALG(I) ≥ α · OPT(I)  (maximization, α ≤ 1)
```

---

## 145.2 Vertex Cover — 2-Approximation

```cpp
#include <iostream>
#include <vector>
#include <set>

// 2-approximation: pick both endpoints of each edge
std::vector<int> approxVertexCover(const std::vector<std::pair<int,int>>& edges, int n) {
    std::vector<bool> covered(n, false);
    std::vector<int> cover;
    for (auto& [u, v] : edges) {
        if (!covered[u] && !covered[v]) {
            cover.push_back(u);
            cover.push_back(v);
            covered[u] = covered[v] = true;
        }
    }
    return cover;
}

int main() {
    std::vector<std::pair<int,int>> edges = {{0,1},{0,2},{1,3},{2,4},{3,5}};
    auto cover = approxVertexCover(edges, 6);
    std::cout << "Vertex cover: ";
    for (int v : cover) std::cout << v << " ";
    std::cout << "\nSize: " << cover.size() << "\n";
    return 0;
}
```

**Proof**: Each edge needs at least one endpoint. Our algorithm picks both, so at most 2×OPT.

---

## 145.3 Set Cover — ln(n)-Approximation

Greedy: repeatedly pick the set covering the most uncovered elements.

```cpp
#include <iostream>
#include <vector>
#include <set>

std::vector<int> greedySetCover(const std::vector<std::set<int>>& sets, 
                                 const std::set<int>& universe) {
    std::set<int> uncovered = universe;
    std::vector<int> chosen;
    std::vector<bool> used(sets.size(), false);
    
    while (!uncovered.empty()) {
        int best = -1, bestCover = 0;
        for (int i = 0; i < (int)sets.size(); i++) {
            if (used[i]) continue;
            int cover = 0;
            for (int x : sets[i])
                if (uncovered.count(x)) cover++;
            if (cover > bestCover) { bestCover = cover; best = i; }
        }
        if (best == -1) break;
        used[best] = true;
        chosen.push_back(best);
        for (int x : sets[best]) uncovered.erase(x);
    }
    return chosen;
}

int main() {
    std::vector<std::set<int>> sets = {{0,1,2},{1,3},{2,4},{3,5},{4,5}};
    std::set<int> universe = {0,1,2,3,4,5};
    auto cover = greedySetCover(sets, universe);
    std::cout << "Set cover indices: ";
    for (int i : cover) std::cout << i << " ";
    std::cout << "\n";
    return 0;
}
```

---

## 145.4 Metric TSP — 3/2-Approximation (Christofides)

1. Find MST
2. Find odd-degree vertices in MST
3. Find minimum weight perfect matching on odd-degree vertices
4. Combine into Eulerian graph
5. Find Eulerian tour, shortcut to Hamiltonian cycle

**Guarantee**: 3/2 × OPT for metric TSP.

---

## 145.5 Knapsack FPTAS

Round values to multiples of ε·max(v)/n, then solve with DP.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// FPTAS for knapsack: (1+ε)-approximate in O(n²/ε)
int knapsackFPTAS(const std::vector<int>& weights, const std::vector<int>& values,
                   int capacity, double epsilon) {
    int n = weights.size();
    int maxVal = *std::max_element(values.begin(), values.end());
    double scale = epsilon * maxVal / n;
    
    // Scale and round values
    std::vector<int> scaledValues(n);
    for (int i = 0; i < n; i++)
        scaledValues[i] = (int)(values[i] / scale);
    
    // DP on scaled values
    int maxScaled = n * n / epsilon;  // Simplified bound
    std::vector<int> dp(maxScaled + 1, INT_MAX);
    dp[0] = 0;
    
    for (int i = 0; i < n; i++)
        for (int v = maxScaled; v >= scaledValues[i]; v--)
            if (dp[v - scaledValues[i]] != INT_MAX)
                dp[v] = std::min(dp[v], dp[v - scaledValues[i]] + weights[i]);
    
    // Find best value fitting in capacity
    int result = 0;
    for (int v = maxScaled; v >= 0; v--)
        if (dp[v] <= capacity) { result = v; break; }
    
    return (int)(result * scale);
}

int main() {
    std::vector<int> w = {2, 3, 4, 5};
    std::vector<int> v = {3, 4, 5, 6};
    std::cout << "FPTAS knapsack: " << knapsackFPTAS(w, v, 8, 0.1) << "\n";
    return 0;
}
```

---

## Summary

| Problem | Ratio | Technique | Time |
|---|---|---|---|
| Vertex Cover | 2 | Greedy | O(V+E) |
| Set Cover | ln(n) | Greedy | O(n²) |
| Metric TSP | 3/2 | Christofides | O(n³) |
| Knapsack | 1+ε | FPTAS | O(n²/ε) |
| Max Cut | 0.5 | Random | O(V+E) |
