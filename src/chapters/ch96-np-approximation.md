# Chapter 96: NP-Completeness and Approximation

## Prerequisites

- Complexity theory basics
- Algorithm design

## Interview Frequency: ★★

Understanding NP-completeness helps recognize when to stop looking for exact solutions. **Google** and research companies test this.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| NP-Complete recognition | ★★ | Hard | Know common NP-C problems |
| Approximation algorithms | ★★ | Medium | Near-optimal solutions |
| Heuristics | ★★★ | Medium | Practical approaches |

---

## 96.1 Common NP-Complete Problems

| Problem | Input | Question |
|---|---|---|
| SAT | Boolean formula | Satisfiable? |
| 3-SAT | 3-CNF formula | Satisfiable? |
| Clique | Graph, k | Clique of size k? |
| Vertex Cover | Graph, k | Cover of size k? |
| Independent Set | Graph, k | IS of size k? |
| Hamiltonian Path | Graph | Visit all vertices? |
| Subset Sum | Set, target | Subset sums to target? |
| Graph Coloring | Graph, k | k-colorable? |

---

## 96.2 Approximation Algorithms

| Problem | Approx Ratio | Algorithm |
|---|---|---|
| Vertex Cover | 2 | Greedy (pick both endpoints) |
| Set Cover | O(ln n) | Greedy |
| Max Cut | 0.5 | Random partition |
| TSP (metric) | 2 | MST-based |
| Knapsack | 1+ε | FPTAS |

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// 2-approximation for Vertex Cover
std::vector<int> approxVertexCover(const std::vector<std::pair<int,int>>& edges,
                                    int n) {
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
    std::vector<std::pair<int,int>> edges = {{0,1}, {0,2}, {1,3}, {2,4}};
    auto cover = approxVertexCover(edges, 5);
    
    std::cout << "Approximate vertex cover: ";
    for (int v : cover) std::cout << v << " ";
    std::cout << "\nSize: " << cover.size() << "\n";
    
    return 0;
}
```

---

## Summary

| Approach | When to Use | Guarantee |
|---|---|---|
| Exact (exponential) | n ≤ 20 | Optimal |
| Approximation | Hard problem, need quality bound | Ratio guarantee |
| Heuristic | Practical, no guarantee | Usually good |
| Metaheuristic | Complex optimization | Variable |
