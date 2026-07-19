# Chapter 139: Complexity Handbook

## Time and Space Complexity Reference

---

## 139.1 Sorting

| Algorithm | Best | Average | Worst | Space | Stable |
|---|---|---|---|---|---|
| Bubble | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Heap | O(n log n) | O(n log n) | O(n log n) | O(1) | No |
| Counting | O(n+k) | O(n+k) | O(n+k) | O(k) | Yes |
| Radix | O(d(n+k)) | O(d(n+k)) | O(d(n+k)) | O(n+k) | Yes |

---

## 139.2 Data Structures

| Operation | Array | Linked List | BST | Hash | Heap |
|---|---|---|---|---|---|
| Access | O(1) | O(n) | O(log n) | O(1) avg | O(1) min |
| Search | O(n) | O(n) | O(log n) | O(1) avg | O(n) |
| Insert | O(n) | O(1) | O(log n) | O(1) avg | O(log n) |
| Delete | O(n) | O(1) | O(log n) | O(1) avg | O(log n) |

---

## 139.3 Graph Algorithms

| Algorithm | Time | Space |
|---|---|---|
| BFS/DFS | O(V+E) | O(V) |
| Dijkstra | O((V+E)log V) | O(V) |
| Bellman-Ford | O(VE) | O(V) |
| Floyd-Warshall | O(V³) | O(V²) |
| Kruskal | O(E log E) | O(V) |
| Prim | O((V+E) log V) | O(V) |
| Topological Sort | O(V+E) | O(V) |
| SCC (Kosaraju) | O(V+E) | O(V) |

---

## 139.4 Common Recurrences

| Recurrence | Solution | Example |
|---|---|---|
| T(n) = T(n/2) + O(1) | O(log n) | Binary search |
| T(n) = T(n/2) + O(n) | O(n) | Median finding |
| T(n) = 2T(n/2) + O(n) | O(n log n) | Merge sort |
| T(n) = 2T(n/2) + O(1) | O(n) | Tree traversal |
| T(n) = T(n-1) + O(1) | O(n) | Linear scan |
| T(n) = T(n-1) + O(n) | O(n²) | Selection sort |
| T(n) = 2T(n-1) + O(1) | O(2^n) | Fibonacci |
