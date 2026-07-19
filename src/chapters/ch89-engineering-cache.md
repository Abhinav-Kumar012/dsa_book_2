# Chapter 89: Cache and Memory Hierarchy

## Prerequisites

- Basic programming
- Understanding of arrays and pointers

## Interview Frequency: ★★

Cache awareness matters for high-performance code. **Google**, **Meta**, and trading firms test this knowledge.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Cache lines | ★★ | Medium | 64-byte blocks |
| Cache associativity | ★ | Hard | Set-associative |
| Cache-friendly code | ★★★ | Medium | Sequential access |
| Memory hierarchy | ★★ | Medium | Registers → L1 → L2 → L3 → RAM |

---

## 89.1 Memory Hierarchy

| Level | Size | Latency | Bandwidth |
|---|---|---|---|
| Registers | ~1 KB | 0.3 ns | — |
| L1 Cache | 32-64 KB | 1 ns | — |
| L2 Cache | 256 KB-1 MB | 3-10 ns | — |
| L3 Cache | 4-64 MB | 10-20 ns | — |
| RAM | 8-128 GB | 50-100 ns | — |
| SSD | 256 GB-4 TB | 25-100 μs | — |
| HDD | 1-16 TB | 5-10 ms | — |

---

## 89.2 Cache Lines

Data is transferred in **cache lines** (typically 64 bytes). Accessing adjacent data is free after the first access.

```cpp
#include <iostream>
#include <vector>
#include <chrono>
#include <numeric>

int main() {
    const int N = 10000;
    const int TRIALS = 100;
    
    // Row-major access (cache-friendly)
    std::vector<std::vector<int>> matrix(N, std::vector<int>(N, 1));
    
    auto start = std::chrono::high_resolution_clock::now();
    long long sum = 0;
    for (int t = 0; t < TRIALS; t++)
        for (int i = 0; i < N; i++)
            for (int j = 0; j < N; j++)
                sum += matrix[i][j];
    auto end = std::chrono::high_resolution_clock::now();
    auto rowTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    
    // Column-major access (cache-unfriendly)
    start = std::chrono::high_resolution_clock::now();
    sum = 0;
    for (int t = 0; t < TRIALS; t++)
        for (int j = 0; j < N; j++)
            for (int i = 0; i < N; i++)
                sum += matrix[i][j];
    end = std::chrono::high_resolution_clock::now();
    auto colTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    
    std::cout << "Row-major: " << rowTime.count() << "ms\n";
    std::cout << "Col-major: " << colTime.count() << "ms\n";
    std::cout << "Speedup: " << (double)colTime.count() / rowTime.count() << "x\n";
    
    return 0;
}
```

---

## 89.3 Cache-Friendly Patterns

| Pattern | Cache Behavior | Example |
|---|---|---|
| Sequential array scan | Excellent | Linear search |
| Row-major 2D access | Good | Matrix multiply |
| Column-major 2D access | Poor | Transpose |
| Linked list traversal | Poor (pointer chasing) | — |
| Hash table probe | Poor (random access) | — |
| Tree BFS | Moderate | Level-order |
| Sorting + sequential | Good | Merge sort |

---

## Summary

| Principle | Impact |
|---|---|
| Sequential access | 10-100x faster than random |
| Data locality | Keep related data together |
| Cache line awareness | Align data to 64 bytes |
| Prefetching | Sequential access enables prefetch |
