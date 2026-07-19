# Chapter 143: Knowledge Aids and Quick Reference

## Last-Minute Revision Guide

---

## 143.1 Algorithm Decision Tree

```
Is input sorted? → Binary Search, Two Pointers
Need subarray? → Sliding Window, Prefix Sum
Need subsequence? → DP
Graph? → BFS/DFS/Dijkstra
Tree? → DFS/DP/LCA
Optimization? → DP/Greedy
Counting? → DP/Combinatorics
n ≤ 20? → Bitmask/Backtracking
```

---

## 143.2 STL Quick Reference

| Need | STL |
|---|---|
| Sorted container | `set`, `map` |
| Fast lookup | `unordered_set`, `unordered_map` |
| Priority queue | `priority_queue` |
| Min/Max | `min_element`, `max_element` |
| Sort | `sort`, `stable_sort` |
| Binary search | `lower_bound`, `upper_bound` |
| Next permutation | `next_permutation` |
| Accumulate | `accumulate` |
| Unique | `unique` |
| Reverse | `reverse` |

---

## 143.3 Common Mistakes

| Mistake | Fix |
|---|---|
| Integer overflow | Use `long long` |
| Off-by-one | Check bounds carefully |
| Uninitialized variables | Initialize everything |
| Iterator invalidation | Use erase-remove idiom |
| Signed/unsigned comparison | Use consistent types |
| Missing base case | Check n=0, n=1 |
| Wrong comparison | Test with equal elements |

---

## 143.4 Interview Checklist

```
□ Clarify problem (2 min)
□ Work examples (2 min)
□ State approach + complexity (2 min)
□ Code cleanly (10 min)
□ Trace through example (2 min)
□ Test edge cases (2 min)
□ Discuss optimizations (if time)
```
