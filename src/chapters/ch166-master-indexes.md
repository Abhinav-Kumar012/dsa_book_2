# Chapter 166: Master Indexes

## Quick Reference Indexes for the Entire Book

---

## Algorithm Index

| Algorithm | Chapter | Time | Space |
|---|---|---|---|
| Binary Search | 6 | O(log n) | O(1) |
| QuickSort | 5 | O(n log n) avg | O(log n) |
| Merge Sort | 5 | O(n log n) | O(n) |
| Dijkstra | 26 | O((V+E)log V) | O(V) |
| Bellman-Ford | 82 | O(VE) | O(V) |
| Floyd-Warshall | 82 | O(V³) | O(V²) |
| Kruskal | 27 | O(E log E) | O(V) |
| Prim | 27 | O((V+E)log V) | O(V) |
| KMP | 41 | O(n+m) | O(m) |
| Aho-Corasick | 46 | O(n+m+z) | O(nm) |
| Dinic | 83 | O(V²E) | O(V+E) |
| Hopcroft-Karp | 112 | O(E√V) | O(V+E) |
| Gale-Shapley | 162 | O(n²) | O(n) |
| Held-Karp (TSP) | 149 | O(2^n · n²) | O(2^n · n) |
| Karger's Min Cut | 150 | O(n² log n) runs | O(V+E) |
| Manacher | 119 | O(n) | O(n) |
| Suffix Array | 44 | O(n log n) | O(n) |
| A* Search | 65 | O(E log V) | O(V) |

---

## Data Structure Index

| Structure | Chapter | Insert | Query | Space |
|---|---|---|---|---|
| Array | 4 | O(1) | O(1) | O(n) |
| Linked List | 12 | O(1) | O(n) | O(n) |
| Hash Map | 7 | O(1) avg | O(1) avg | O(n) |
| BST | 14 | O(log n) | O(log n) | O(n) |
| AVL Tree | 14 | O(log n) | O(log n) | O(n) |
| Heap | 15 | O(log n) | O(1) min | O(n) |
| Trie | 16 | O(m) | O(m) | O(nm) |
| Segment Tree | 18 | O(log n) | O(log n) | O(n) |
| Fenwick Tree | 19 | O(log n) | O(log n) | O(n) |
| Sparse Table | 20 | O(n log n) build | O(1) | O(n log n) |
| DSU | 17 | O(α(n)) | O(α(n)) | O(n) |
| Skip List | 74 | O(log n) | O(log n) | O(n) |
| B-Tree | 77 | O(log n) | O(log n) | O(n) |
| KD Tree | 78 | O(log n) avg | O(log n) avg | O(n) |
| Treap | 57 | O(log n) | O(log n) | O(n) |
| Splay Tree | 98 | O(log n) amort | O(log n) amort | O(n) |
| Link-Cut Tree | 157 | O(log n) | O(log n) | O(n) |
| Van Emde Boas | 100 | O(log log U) | O(log log U) | O(U) |

---

## Pattern Recognition Index

| Pattern | Chapter | Technique |
|---|---|---|
| "Sorted array" | 6 | Binary Search |
| "Top k" | 15 | Heap |
| "Shortest path" | 26 | BFS/Dijkstra |
| "Minimum cost" | 30-31 | DP/Greedy |
| "Subarray" | 35-36 | Sliding Window/Prefix Sum |
| "Connected" | 17, 23 | DSU/DFS |
| "Range query" | 18-20 | Segment Tree/Sparse Table |
| "Parentheses" | 10 | Stack |
| "Anagram" | 7 | Hash Map |
| "Palindrome" | 119 | Manacher/Two Pointers |
| "Permutation" | 9 | Backtracking |
| "K-th element" | 15 | Heap/Quickselect |
| "Next greater" | 37 | Monotonic Stack |
| "LCA" | 21 | Binary Lifting |
| "Path on tree" | 107 | HLD |
| "Count with digits" | 85 | Digit DP |
| "Optimal K groups" | 116 | Alien Trick |

---

## Complexity Index

| Complexity | Max n | Approach |
|---|---|---|
| O(1) | ∞ | Hash, direct access |
| O(log n) | 10^18 | Binary search, tree |
| O(√n) | 10^10 | Number theory |
| O(n) | 10^7 | Linear scan |
| O(n log n) | 10^6 | Sorting, divide & conquer |
| O(n²) | 5000 | Simple DP |
| O(n³) | 500 | Floyd, matrix chain |
| O(2^n) | 20 | Bitmask, backtracking |
| O(n!) | 10 | Permutation |

---

## Formula Index

| Formula | Expression | Use |
|---|---|---|
| nCr | n!/(r!(n-r)!) | Combinations |
| Stars and Bars | C(n+k-1, k-1) | Distribution |
| Catalan | C(2n,n)/(n+1) | Parenthesizations |
| Euler's Totient | φ(n) = n∏(1-1/p) | Number theory |
| Geometric Sum | a(r^n-1)/(r-1) | Series |
| Bayes | P(A\|B) = P(B\|A)P(A)/P(B) | Probability |
| Birthday Paradox | P ≈ 1-e^(-n²/2d) | Hash collisions |
| Coupon Collector | E = n·H(n) ≈ n ln n | Coverage |
