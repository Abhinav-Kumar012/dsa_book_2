# Chapter 145: Approximation Algorithms

## Prerequisites
- Greedy algorithms
- LP basics ([Chapter 151](ch151-linear-programming.md))
- NP-completeness ([Chapter 96](ch96-np-completeness.md))

## Interview Frequency: ★★

Approximation algorithms provide provable guarantees for NP-hard problems. Understanding them is important for system design interviews where exact solutions are infeasible.

| Problem | Ratio | Technique | Time |
|---|---|---|---|
| Vertex Cover | 2 | Greedy | O(V+E) |
| Set Cover | ln(n) | Greedy | O(n²) |
| Metric TSP | 3/2 | Christofides | O(n³) |
| Knapsack | 1+ε | FPTAS | O(n²/ε) |
| Max Cut | 0.5 | Random | O(V+E) |

---

## Definition

An algorithm is **α-approximate** if for all inputs:
- Minimization: ALG(I) ≤ α · OPT(I)
- Maximization: ALG(I) ≥ α · OPT(I) (where α ≤ 1)

A **PTAS** (Polynomial-Time Approximation Scheme) achieves (1+ε)-approximation for any ε > 0, in polynomial time (but possibly exponential in 1/ε).

An **FPTAS** (Fully PTAS) is polynomial in both n and 1/ε.

## Motivation

Many real-world problems are NP-hard. We need solutions that:
1. Run in polynomial time
2. Are provably close to optimal
3. Are simple enough to implement and maintain

## Intuition

Approximation algorithms trade optimality for speed, but with a guarantee. "I don't know the exact answer, but I know my answer is at most 2× worse than optimal."

---

## 145.1 Vertex Cover — 2-Approximation

### Problem

Find the smallest set of vertices such that every edge has at least one endpoint in the set.

### Algorithm

For each edge, if neither endpoint is covered, add both to the cover.

### Why It's 2-Approximate

Each edge needs at least one endpoint in the optimal cover. Our algorithm picks both, so at most 2×OPT.

### C++ Implementation

```cpp
#include <iostream>
#include <vector>

std::vector<int> approxVertexCover(
    const std::vector<std::pair<int,int>>& edges, int n) {
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

### Python Implementation

```python
def approx_vertex_cover(edges, n):
    covered = [False] * n
    cover = []
    for u, v in edges:
        if not covered[u] and not covered[v]:
            cover.extend([u, v])
            covered[u] = covered[v] = True
    return cover

edges = [(0,1),(0,2),(1,3),(2,4),(3,5)]
cover = approx_vertex_cover(edges, 6)
print(f"Vertex cover: {cover}, size: {len(cover)}")
```

---

## 145.2 Set Cover — ln(n)-Approximation

### Problem

Given a universe U and a collection of sets S₁, ..., Sₘ, find the minimum number of sets whose union is U.

### Algorithm

Greedy: repeatedly pick the set covering the most uncovered elements.

### C++ Implementation

```cpp
#include <iostream>
#include <vector>
#include <set>

std::vector<int> greedySetCover(
    const std::vector<std::set<int>>& sets, const std::set<int>& universe) {
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

## 145.3 Metric TSP — 3/2-Approximation (Christofides)

### Algorithm

1. Find MST
2. Find odd-degree vertices in MST
3. Find minimum weight perfect matching on odd-degree vertices
4. Combine into Eulerian graph
5. Find Eulerian tour, shortcut to Hamiltonian cycle

### Guarantee

3/2 × OPT for metric TSP (triangle inequality holds).

---

## 145.4 Knapsack FPTAS

### Idea

Round values to multiples of ε·max(v)/n, then solve with DP.

### C++ Implementation

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

int knapsackFPTAS(const std::vector<int>& weights, const std::vector<int>& values,
                   int capacity, double epsilon) {
    int n = weights.size();
    int maxVal = *std::max_element(values.begin(), values.end());
    double scale = epsilon * maxVal / n;

    std::vector<int> scaledValues(n);
    for (int i = 0; i < n; i++)
        scaledValues[i] = (int)(values[i] / scale);

    int maxScaled = n * n / (int)(epsilon * n);
    std::vector<int> dp(maxScaled + 1, INT_MAX);
    dp[0] = 0;

    for (int i = 0; i < n; i++)
        for (int v = maxScaled; v >= scaledValues[i]; v--)
            if (dp[v - scaledValues[i]] != INT_MAX)
                dp[v] = std::min(dp[v], dp[v - scaledValues[i]] + weights[i]);

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

## 145.5 Max Cut — 0.5-Approximation

### Algorithm

Randomly assign each vertex to one of two sets. Each edge is cut with probability 1/2.

### Expected Performance

E[cuts] = |E|/2 ≥ OPT/2 (since OPT ≤ |E|).

A deterministic version: assign vertices greedily to the side that maximizes cuts.

---

## Exercises

1. **Implement Christofides**: Implement the 3/2-approximation for metric TSP. Test on a grid graph.

2. **Greedy vertex cover**: Implement the greedy algorithm that picks the vertex with highest degree. Compare with the 2-approximation.

3. **LP rounding**: Implement LP relaxation + rounding for set cover. Compare with the greedy approach.

4. **PTAS for knapsack**: Implement a PTAS that uses enumeration for small instances and FPTAS for large ones.

---

## Interview Questions

1. **Q: What's the difference between a PTAS and an FPTAS?**
   A: A PTAS is polynomial in n for fixed ε, but may be exponential in 1/ε. An FPTAS is polynomial in both n and 1/ε. FPTAS is stronger.

2. **Q: Why is the greedy set cover O(ln n)-approximate?**
   A: Each step covers at least a 1/k fraction of remaining elements (where k is the optimal number of sets). After k·ln(n) steps, all elements are covered. The analysis uses the harmonic number H(n) ≈ ln(n).

3. **Q: Can we do better than 2-approximation for vertex cover?**
   A: The best known is 2 - O(1/√(log n)). It's NP-hard to approximate better than 2 - ε for any constant ε (under the Unique Games Conjecture).

4. **Q: How does the random max cut algorithm achieve 0.5-approximation?**
   A: Each edge has probability 1/2 of being cut (endpoints in different sets). By linearity of expectation, E[cuts] = |E|/2. Since OPT ≤ |E|, we get E[cuts] ≥ OPT/2.

---

## Cross-References

- [Chapter 96: NP-Completeness](ch96-np-completeness.md) — Why we need approximation
- [Chapter 151: Linear Programming](ch151-linear-programming.md) — LP rounding techniques
- [Chapter 152: Integer Programming](ch152-integer-programming.md) — LP relaxation

---

## Summary

| Problem | Ratio | Technique | Time |
|---|---|---|---|
| Vertex Cover | 2 | Greedy | O(V+E) |
| Set Cover | ln(n) | Greedy | O(n²) |
| Metric TSP | 3/2 | Christofides | O(n³) |
| Knapsack | 1+ε | FPTAS | O(n²/ε) |
| Max Cut | 0.5 | Random | O(V+E) |
