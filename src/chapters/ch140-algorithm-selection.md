# Chapter 140: Algorithm Selection Cheat Sheet

## Choose the Right Algorithm

---

## 140.1 By Problem Type

| Problem | Algorithm | Time |
|---|---|---|
| Find in sorted | Binary search | O(log n) |
| Shortest path (unweighted) | BFS | O(V+E) |
| Shortest path (weighted, no negative) | Dijkstra | O((V+E)log V) |
| Shortest path (negative edges) | Bellman-Ford | O(VE) |
| All pairs shortest | Floyd-Warshall | O(V³) |
| MST | Kruskal or Prim | O(E log E) |
| Topological ordering | Kahn's or DFS | O(V+E) |
| Strongly connected components | Kosaraju or Tarjan | O(V+E) |
| Maximum flow | Dinic | O(V²E) |
| Bipartite matching | Hopcroft-Karp | O(E√V) |
| K-th element | Quickselect | O(n) avg |
| Range sum query | Prefix sum / Fenwick | O(1) / O(log n) |
| Range min query | Sparse table / Seg tree | O(1) / O(log n) |
| LCA | Binary lifting | O(log n) |
| Connected components | Union-Find | O(α(n)) |

---

## 140.2 By Constraint Size

| n | Complexity | Algorithm |
|---|---|---|
| ≤ 10 | O(n!) | Permutation brute force |
| ≤ 20 | O(2^n) | Bitmask DP |
| ≤ 500 | O(n³) | Floyd, matrix chain |
| ≤ 5000 | O(n²) | Simple DP |
| ≤ 10^5 | O(n log n) | Sort, segment tree |
| ≤ 10^6 | O(n) | Linear scan |
| ≤ 10^7 | O(n) | Careful linear |
| > 10^7 | O(log n) | Binary search, math |
