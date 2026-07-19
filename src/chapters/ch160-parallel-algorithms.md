# Chapter 160: Parallel Algorithms

## Prerequisites
- Basic algorithms, complexity theory

## Interview Frequency: ★

Parallel algorithms use multiple processors to solve problems faster.

---

## 160.1 PRAM Model

Parallel Random Access Machine: multiple processors sharing memory.

| Variant | Concurrent Read | Concurrent Write |
|---|---|---|
| EREW | No | No |
| CREW | Yes | No |
| CRCW | Yes | Yes |

---

## 160.2 Work-Depth Model

| Measure | Definition | Significance |
|---|---|---|
| Work T₁ | Total operations | Sequential time |
| Depth T∞ | Longest dependency chain | Parallel time |
| Parallelism T₁/T∞ | Max useful processors | Speedup limit |

**Brent's Theorem**: With p processors, time ≤ T₁/p + T∞.

---

## 160.3 Parallel Prefix Sum

Compute all prefix sums in O(log n) depth with O(n) work.

```cpp
#include <iostream>
#include <vector>

// Parallel prefix sum (simplified sequential version showing the algorithm)
// In parallel: up-sweep then down-sweep
std::vector<int> parallelPrefixSum(std::vector<int> arr) {
    int n = arr.size();
    
    // Up-sweep: build partial sums in a tree
    for (int d = 0; (1 << d) < n; d++) {
        for (int i = 0; i < n; i += (1 << (d + 1))) {
            int left = i + (1 << d) - 1;
            int right = i + (1 << (d + 1)) - 1;
            if (right < n) arr[right] += arr[left];
        }
    }
    
    // Down-sweep: distribute sums
    arr[n - 1] = 0;
    for (int d = (int)(std::log2(n)) - 1; d >= 0; d--) {
        for (int i = 0; i < n; i += (1 << (d + 1))) {
            int left = i + (1 << d) - 1;
            int right = i + (1 << (d + 1)) - 1;
            if (right < n) {
                int temp = arr[left];
                arr[left] = arr[right];
                arr[right] += temp;
            }
        }
    }
    
    return arr;
}

int main() {
    std::vector<int> arr = {1, 2, 3, 4, 5, 6, 7, 8};
    auto prefix = parallelPrefixSum(arr);
    
    std::cout << "Prefix sums: ";
    for (int x : prefix) std::cout << x << " ";
    std::cout << "\n"; // 0, 1, 3, 6, 10, 15, 21, 28
    
    return 0;
}
```

---

## 160.4 Parallel Sorting

| Algorithm | Work | Depth | Notes |
|---|---|---|---|
| Parallel Merge Sort | O(n log n) | O(log² n) | Classic |
| Parallel QuickSort | O(n log n) | O(log n) expected | Random pivot |
| Bitonic Sort | O(n log² n) | O(log² n) | Comparison network |
| Sample Sort | O(n log n) | O(log n) | Practical |

---

## 160.5 Parallel Graph Algorithms

| Problem | Work | Depth |
|---|---|---|
| BFS | O(V + E) | O(diameter) |
| Connected Components | O(V + E) | O(log² n) |
| MST | O(E log E) | O(log² n) |
| Shortest Paths | O(VE) | O(V) |

---

## Summary

| Problem | Sequential | Parallel Depth | Processors |
|---|---|---|---|
| Prefix Sum | O(n) | O(log n) | O(n) |
| Sorting | O(n log n) | O(log n) | O(n) |
| BFS | O(V+E) | O(diameter) | O(V+E) |
| MST | O(E log E) | O(log² n) | O(E) |
