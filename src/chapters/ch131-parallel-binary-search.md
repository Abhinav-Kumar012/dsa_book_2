# Chapter 131: Parallel Binary Search

## Prerequisites
- Binary search, offline algorithms

## Interview Frequency: ★★

Binary search multiple queries simultaneously.

---

## 131.1 Technique

When multiple queries each need binary search, and feasibility can be checked in batch:

```
1. For each query, maintain [lo, hi]
2. While any lo < hi:
   a. Group queries by mid
   b. Check feasibility for all queries at once
   c. Update lo/hi based on result
```

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Example: For each query, find minimum k such that prefix_sum[0..k] >= target
std::vector<int> parallelBinarySearch(const std::vector<long long>& prefix,
                                       const std::vector<long long>& targets) {
    int n = prefix.size();
    int q = targets.size();
    std::vector<int> lo(q, 0), hi(q, n - 1), ans(q, -1);
    
    bool changed = true;
    while (changed) {
        changed = false;
        // Group queries by mid
        std::vector<std::vector<int>> buckets(n);
        for (int i = 0; i < q; i++) {
            if (lo[i] <= hi[i]) {
                int mid = (lo[i] + hi[i]) / 2;
                buckets[mid].push_back(i);
                changed = true;
            }
        }
        
        // Process in order, checking feasibility
        for (int mid = 0; mid < n; mid++) {
            for (int idx : buckets[mid]) {
                if (prefix[mid] >= targets[idx]) {
                    ans[idx] = mid;
                    hi[idx] = mid - 1;
                } else {
                    lo[idx] = mid + 1;
                }
            }
        }
    }
    
    return ans;
}

int main() {
    std::vector<long long> prefix = {1, 3, 6, 10, 15, 21, 28, 36};
    std::vector<long long> targets = {5, 10, 20, 30};
    
    auto ans = parallelBinarySearch(prefix, targets);
    
    for (int i = 0; i < (int)targets.size(); i++)
        std::cout << "Target " << targets[i] << ": first index with sum >= target = " 
                  << ans[i] << "\n";
    
    return 0;
}
```

---

## Summary

| Aspect | Value |
|---|---|
| Time | O((N + Q) log N × feasibility_check) |
| Benefit | Batch feasibility checks |
| Best for | Multiple binary searches with shared structure |
