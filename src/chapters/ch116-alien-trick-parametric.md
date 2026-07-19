# Chapter 116: Alien Trick and Parametric Search

## Prerequisites
- Binary search, DP

## Interview Frequency: ★★

Alien trick converts constrained optimization to unconstrained via penalty.

---

## 116.1 Alien Trick Pattern

When we need "exactly K segments", add a penalty λ per segment and binary search on λ.

```
minimize f(x) subject to g(x) = K
→ min over x of [f(x) + λ * g(x)]
→ Binary search λ so optimal g(x) = K
```

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

// Minimize max subarray sum with exactly K partitions
// Alien trick: minimize (max_subarray_sum + lambda * num_partitions)

struct Result { long long cost; int partitions; };

Result solve(const std::vector<int>& arr, long long lambda) {
    int n = arr.size();
    long long maxVal = 0;
    long long currentSum = 0;
    int partitions = 1;
    
    for (int x : arr) {
        if (currentSum + x > maxVal + lambda) {
            partitions++;
            currentSum = x;
        } else {
            currentSum += x;
        }
        maxVal = std::max(maxVal, currentSum);
    }
    
    return {maxVal + lambda * partitions, partitions};
}

long long aliensTrick(const std::vector<int>& arr, int k) {
    long long lo = 0, hi = 1e15;
    long long answer = 0;
    while (lo <= hi) {
        long long mid = lo + (hi - lo) / 2;
        auto result = solve(arr, mid);
        if (result.partitions >= k) {
            answer = result.cost - mid * k;
            lo = mid + 1;
        } else {
            hi = mid - 1;
        }
    }
    return answer;
}

int main() {
    std::vector<int> arr = {1, 3, 2, 4, 1, 5, 2};
    int k = 3;
    std::cout << "Min max-subarray with " << k << " partitions: " 
              << aliensTrick(arr, k) << "\n";
    return 0;
}
```

---

## Summary

| Step | Action |
|---|---|
| 1 | Define unconstrained: f(x) + λ * g(x) |
| 2 | Binary search λ |
| 3 | Answer = result - λ * K |
