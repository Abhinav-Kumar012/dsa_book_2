# Chapter 97: Pattern Recognition Handbook

## Prerequisites

- All previous chapters

## Interview Frequency: ★★★★★

Pattern recognition is the most important meta-skill for interviews. This chapter provides a systematic guide to identifying which technique to use.

---

## 97.1 Master Decision Flowchart

```
START: Read problem carefully
│
├─ Is input SORTED?
│   ├─ YES → Binary Search, Two Pointers, Merge
│   └─ NO → Can you sort? → Usually yes → Sort first
│
├─ Need SUBARRAY/SUBSTRING (contiguous)?
│   ├─ Fixed size k → Sliding Window
│   ├─ Variable size → Sliding Window or Two Pointers
│   ├─ Maximum/minimum → Kadane's, DP
│   └─ Count with property → Prefix Sum, Sliding Window
│
├─ Need SUBSEQUENCE (not contiguous)?
│   ├─ Longest increasing → Binary Search or DP
│   ├─ Common to two strings → DP (LCS)
│   └─ Count → DP
│
├─ Is it a GRAPH problem?
│   ├─ Shortest path → BFS (unweighted), Dijkstra (weighted)
│   ├─ Connectivity → DFS, Union-Find
│   ├─ Cycle detection → DFS with colors
│   ├─ Ordering → Topological Sort
│   ├─ All paths → Backtracking/DFS
│   └─ Min cut/flow → Max Flow
│
├─ Is it a TREE problem?
│   ├─ Path queries → HLD, LCA
│   ├─ Subtree queries → Euler Tour + Segment Tree
│   ├─ Optimal in subtree → Tree DP
│   └─ Rerooting → Rerooting DP
│
├─ Is it about COUNTING?
│   ├─ With constraints → DP
│   ├─ Combinatorial → nCr, inclusion-exclusion
│   └─ Probability → Expected value DP
│
├─ Is it OPTIMIZATION (min/max)?
│   ├─ Overlapping subproblems → DP
│   ├─ Greedy works → Greedy
│   ├─ Choices at each step → DP
│   └─ Search space monotone → Binary Search on Answer
│
├─ Is n ≤ 20?
│   └─ Bitmask, Backtracking, Meet in the Middle
│
├─ Is n ≤ 500?
│   └─ O(n³) OK: Floyd-Warshall, Matrix Chain
│
├─ Is n ≤ 10^5?
│   └─ O(n log n): Sorting, Segment Tree, Divide & Conquer
│
└─ Is n ≤ 10^7?
    └─ O(n): Linear scan, Hash Map, Two Pointers
```

---

## 97.2 Pattern Quick Reference

### Sliding Window
**Keywords**: "subarray", "substring", "contiguous", "window", "consecutive"
**Recognition**: Need to find/optimize something in a contiguous range

### Two Pointers
**Keywords**: "sorted array", "pair", "triplet", "sum to target"
**Recognition**: Sorted input, looking for pairs/triplets

### Binary Search
**Keywords**: "sorted", "minimum such that", "maximum such that", "first/last"
**Recognition**: Monotonic property, can verify answer

### Dynamic Programming
**Keywords**: "minimum cost", "maximum profit", "number of ways", "count"
**Recognition**: Choices at each step, overlapping subproblems

### Greedy
**Keywords**: "minimum number of", "maximum number of", "interval scheduling"
**Recognition**: Local optimal → global optimal (exchange argument)

### Graph BFS/DFS
**Keywords**: "connected", "shortest path (unweighted)", "reachability"
**Recognition**: Nodes and edges, traversal needed

### Union-Find
**Keywords**: "connected components", "merge", "same group"
**Recognition**: Dynamic connectivity, grouping

### Segment Tree
**Keywords**: "range query", "range update", "interval"
**Recognition**: Queries on ranges of array

### Hash Map
**Keywords**: "frequency", "count", "two sum", "anagram"
**Recognition**: Need O(1) lookup, counting

### Heap
**Keywords**: "top k", "k-th largest/minimum", "median"
**Recognition**: Need extreme values, priority queue

### Monotonic Stack
**Keywords**: "next greater", "next smaller", "histogram"
**Recognition**: Need nearest greater/smaller element

### Backtracking
**Keywords**: "all combinations", "all permutations", "generate all"
**Recognition**: Need all solutions, n ≤ 20

---

## 97.3 Common Disguises

| Looks Like | Actually Is | Technique |
|---|---|---|
| "Minimize max difference" | Binary search on answer | Binary search |
| "Can we split into k groups?" | Binary search on answer | Binary search + greedy check |
| "Number of islands" | Graph connectivity | DFS/BFS/Union-Find |
| "Edit distance" | Two string DP | LCS-like DP |
| "Word break" | String DP | DP + Trie |
| "Meeting rooms" | Interval scheduling | Sort + greedy/sliding window |
| "Top k frequent" | Heap | Min-heap of size k |
| "Serialize tree" | BFS/DFS traversal | Queue/recursion |

---

## 97.4 Constraint → Complexity Guide

| Constraint | Max Complexity | Typical Approach |
|---|---|---|
| n ≤ 10 | O(n!) | Permutation |
| n ≤ 20 | O(2^n) | Bitmask |
| n ≤ 50 | O(n⁴) | 4D DP |
| n ≤ 200 | O(n³) | Floyd, Matrix Chain |
| n ≤ 5000 | O(n²) | Simple DP |
| n ≤ 10^5 | O(n log n) | Sort, Seg Tree |
| n ≤ 10^6 | O(n) | Linear |
| n ≤ 10^7 | O(n) | Careful linear |
| n > 10^7 | O(log n) | Binary search, math |

---

## 97.5 Practice Problems by Pattern

### Sliding Window
1. Maximum average subarray of size k
2. Longest substring without repeating characters
3. Minimum window substring
4. Sliding window maximum

### Two Pointers
1. Two sum (sorted)
2. Three sum
3. Container with most water
4. Trapping rain water

### Binary Search
1. Search in rotated sorted array
2. Find minimum in rotated sorted array
3. Koko eating bananas
4. Capacity to ship packages

### DP
1. Coin change
2. Longest increasing subsequence
3. Edit distance
4. Word break

### Graph
1. Number of islands
2. Course schedule
3. Clone graph
4. Word ladder

---

## Summary

| Step | Action |
|---|---|
| 1. Read carefully | Identify input type, constraints, output |
| 2. Check constraints | n → complexity budget |
| 3. Match pattern | Use flowchart above |
| 4. Verify approach | Walk through example |
| 5. Implement | Clean code, handle edge cases |
| 6. Test | Edge cases first |
