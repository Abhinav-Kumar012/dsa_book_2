# Chapter 159: External Memory Algorithms

## Prerequisites
- Sorting, B-Trees

## Interview Frequency: ★

External memory algorithms optimize for data too large to fit in main memory.

---

## 159.1 I/O Model

- M words of fast memory (cache/RAM)
- Unlimited slow memory (disk/SSD)
- Transfer B words per block
- **Goal**: minimize block transfers (I/O operations)

| Access | Latency |
|---|---|
| RAM | ~100 ns |
| SSD | ~100 μs |
| HDD | ~10 ms |

---

## 159.2 External Merge Sort

```
Phase 1: Create sorted runs
  - Read M elements, sort in memory, write back
  - Creates ⌈N/M⌉ sorted runs

Phase 2: Merge runs
  - Merge M/B runs at a time
  - Repeat until one run remains
```

**I/O complexity**: O((N/B) × log_{M/B}(N/B))

---

## 159.3 B-Trees for External Storage

Each node = one disk page. Order m ≈ B (block size / key size).

| Operation | I/O Complexity |
|---|---|
| Search | O(log_B N) |
| Insert | O(log_B N) |
| Range query | O(log_B N + K/B) |

---

## 159.4 Cache-Oblivious Algorithms

Work efficiently without knowing M and B. Achieve optimal I/O complexity automatically.

**Key technique**: Recursive decomposition (like cache-oblivious matrix multiply, funnel sort).

---

## 159.5 External Graph Algorithms

| Problem | I/O Complexity |
|---|---|
| BFS | O((V + E)/B × log_{M/B}(V/B)) |
| DFS | O((V + E)/B × log_{M/B}(V/B)) |
| Connected Components | O((V + E)/B × log_{M/B}(V/B)) |
| Shortest Paths | Similar |

---

## Summary

| Algorithm | I/O Complexity | Notes |
|---|---|---|
| External Merge Sort | O((N/B) log_{M/B}(N/B)) | Standard |
| B-Tree operations | O(log_B N) | Disk-friendly |
| External BFS | O((V+E)/B × log) | Graph traversal |
| Cache-oblivious sort | O((N/B) log_{M/B}(N/B)) | No M/B knowledge needed |
