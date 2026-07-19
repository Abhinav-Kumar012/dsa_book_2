# Chapter 70: Computational Models and Complexity Classes

## Prerequisites

- Basic algorithms and complexity
- Mathematical maturity

## Interview Frequency: ★★

Understanding computational models and complexity classes helps you recognize when a problem is fundamentally hard and when to stop looking for a polynomial solution. **Google** and research-oriented companies occasionally test this knowledge.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| P vs NP | ★★ | Hard | Fundamental CS theory |
| NP-Completeness | ★★ | Hard | Reduction techniques |
| Approximation | ★★ | Medium | When exact is intractable |
| Online algorithms | ★★ | Medium | Streaming, competitive ratio |

---

## 70.1 Computational Models

### RAM (Random Access Machine)

The standard model for algorithm analysis:
- Operations: arithmetic, comparison, assignment, array access — all O(1)
- Memory: unbounded, random access
- Word size: typically O(log n) bits

### Word RAM

Extends RAM with word-level operations:
- Words are w bits (typically w ≥ log n)
- Bitwise operations on words: O(1)
- Important for: hashing, bit manipulation, van Emde Boas

### External Memory Model

For data too large for main memory:
- Memory: M words of fast cache, unlimited slow disk
- Transfer: B words per block transfer
- Goal: minimize block transfers (I/O complexity)

---

## 70.2 Complexity Classes

```
┌─────────────────────────────────────────┐
│                 EXPTIME                  │
│  ┌───────────────────────────────────┐  │
│  │              NP-Hard              │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │          NP-Complete        │  │  │
│  │  │  ┌───────────────────────┐  │  │  │
│  │  │  │          NP           │  │  │  │
│  │  │  │  ┌─────────────────┐  │  │  │  │
│  │  │  │  │       P         │  │  │  │  │
│  │  │  │  └─────────────────┘  │  │  │  │
│  │  │  └───────────────────────┘  │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

| Class | Definition | Example |
|---|---|---|
| **P** | Solvable in polynomial time | Sorting, shortest path |
| **NP** | Verifiable in polynomial time | Hamiltonian path |
| **NP-Complete** | In NP, all NP problems reduce to it | SAT, Clique, Vertex Cover |
| **NP-Hard** | At least as hard as NP-Complete | Halting problem |
| **EXPTIME** | Solvable in exponential time | Some games |

---

## 70.3 NP-Completeness and Reductions

A problem X **reduces** to Y (X ≤ Y) if a solution to Y can be used to solve X. If Y ∈ P, then X ∈ P.

### Classic NP-Complete Problems

| Problem | Input | Question |
|---|---|---|
| SAT | Boolean formula | Is there a satisfying assignment? |
| 3-SAT | 3-CNF formula | Satisfiable with 3 literals per clause? |
| Clique | Graph, integer k | Is there a clique of size k? |
| Vertex Cover | Graph, integer k | Is there a vertex cover of size k? |
| Hamiltonian Path | Graph | Is there a path visiting all vertices? |
| Subset Sum | Set of integers, target | Does any subset sum to target? |
| Partition | Set of integers | Can we split into two equal-sum subsets? |

### What to Do When You Suspect NP-Hardness

1. **Check input constraints**: If n ≤ 20, exponential (bitmask) is fine
2. **Look for special structure**: Trees, bipartite graphs, intervals
3. **Consider approximation**: Get close to optimal
4. **Use heuristics**: Greedy, local search, simulated annealing
5. **Ask the interviewer**: "This seems NP-hard. Should I find an approximation?"

---

## 70.4 Approximation Algorithms

When the exact solution is NP-hard, find a solution within a factor of optimal.

| Problem | Approximation Ratio | Algorithm |
|---|---|---|
| Vertex Cover | 2 | Greedy (pick both endpoints) |
| TSP (metric) | 3/2 | Christofides |
| Set Cover | O(ln n) | Greedy |
| Max Cut | 0.5 | Random assignment |
| Knapsack | 1 + ε | FPTAS |

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// 2-approximation for Vertex Cover
std::vector<int> approxVertexCover(const std::vector<std::vector<int>>& adj,
                                    const std::vector<std::pair<int,int>>& edges) {
    std::vector<bool> covered(adj.size(), false);
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
    // Graph: 0-1, 0-2, 1-3, 2-4
    int n = 5;
    std::vector<std::vector<int>> adj(n);
    std::vector<std::pair<int,int>> edges = {{0,1}, {0,2}, {1,3}, {2,4}};
    
    for (auto& [u, v] : edges) {
        adj[u].push_back(v);
        adj[v].push_back(u);
    }
    
    auto cover = approxVertexCover(adj, edges);
    std::cout << "Approximate vertex cover: ";
    for (int v : cover) std::cout << v << " ";
    std::cout << "\nSize: " << cover.size() << " (optimal is 2: {0,1} or {0,2})\n";
    
    return 0;
}
```

---

## 70.5 Online Algorithms

**Online algorithms** process input piece by piece without knowing future input.

### Competitive Ratio

An online algorithm has **competitive ratio** c if:
```
ALG(requests) ≤ c × OPT(requests) + constant
```
for all request sequences.

| Problem | Online Algorithm | Competitive Ratio |
|---|---|---|
| Paging (cache) | LRU | k (cache size) |
| Ski rental | Buy after B days | 2 |
| Secretary problem | Reject first n/e, pick next best | e ≈ 2.718 |
| Online matching | Greedy | 0.5 |

### Ski Rental Problem

Rent skis for $1/day or buy for $B. How many days to rent before buying?

```cpp
#include <iostream>
#include <random>
#include <chrono>
#include <iomanip>

// Strategy: Rent for B days, then buy
// Worst case: ski exactly B days → paid 2B instead of B → ratio 2
int skiRentalStrategy(int B, int actualDays) {
    int cost = std::min(actualDays, B) + (actualDays > B ? B : 0);
    return cost;
}

int optimalCost(int B, int actualDays) {
    return std::min(actualDays, B);
}

int main() {
    int B = 10; // Buy price
    
    std::cout << "Ski Rental (buy price = $" << B << "):\n";
    for (int days : {5, 10, 15, 20}) {
        int alg = skiRentalStrategy(B, days);
        int opt = optimalCost(B, days);
        double ratio = (double)alg / opt;
        std::cout << "  Days=" << days << ": ALG=$" << alg 
                  << ", OPT=$" << opt << ", ratio=" 
                  << std::fixed << std::setprecision(2) << ratio << "\n";
    }
    
    return 0;
}
```

---

## Summary

| Concept | Key Insight | Interview Relevance |
|---|---|---|
| P vs NP | Easy to verify ≠ easy to solve | Recognize hard problems |
| NP-Complete | Reduce from known NP-C problems | Know when to give up |
| Approximation | Near-optimal for hard problems | Practical solutions |
| Online algorithms | No future knowledge | Streaming, caching |
