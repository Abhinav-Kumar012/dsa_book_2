# Chapter 141: Data Structure Selection Cheat Sheet

## Choose the Right Data Structure

---

## 141.1 By Operation Needed

| Need | Data Structure | Time |
|---|---|---|
| Fast lookup by key | Hash map | O(1) avg |
| Ordered elements | BST (set/map) | O(log n) |
| Min/Max element | Heap (priority queue) | O(1) / O(log n) |
| K-th element | Order statistic tree | O(log n) |
| Range sum | Fenwick / Segment tree | O(log n) |
| Range min/max | Sparse table / Seg tree | O(1) / O(log n) |
| Range update | Lazy segment tree | O(log n) |
| Union/Find | DSU | O(α(n)) |
| Prefix operations | Prefix sum array | O(1) |
| String matching | Trie / Aho-Corasick | O(m) / O(n+m) |
| LRU Cache | Hash map + doubly linked list | O(1) |
| Median | Two heaps | O(1) |
| Sliding window min | Monotonic deque | O(1) amortized |

---

## 141.2 Trade-offs

| Comparison | Better When | Worse When |
|---|---|---|
| Array vs Linked List | Random access | Frequent insert/delete |
| Hash Map vs BST | Lookup only | Need ordering |
| Segment Tree vs Fenwick | Range updates | Simple prefix sums |
| Stack vs Queue | LIFO order | FIFO order |
| Heap vs BST | Only need min/max | Need all operations |
