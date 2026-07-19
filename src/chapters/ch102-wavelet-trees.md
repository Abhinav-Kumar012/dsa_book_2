# Chapter 102: Wavelet Trees

## Prerequisites
- Segment trees, binary search

## Interview Frequency: ★★

Wavelet trees answer range frequency queries in O(log σ). Competitive programming favorite.

| Query | Time | Description |
|---|---|---|
| Count x in [l,r] | O(log σ) | Range frequency |
| K-th smallest in [l,r] | O(log σ) | Range quantile |
| Count ≤ x in [l,r] | O(log σ) | Range rank |

---

## 102.1 Overview

A wavelet tree recursively partitions the value range, storing bitmaps at each level.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Simplified wavelet tree for range k-th smallest
class WaveletTree {
    int lo, hi;
    std::vector<int> b; // b[i] = count of elements going left from first i
    WaveletTree *left, *right;
    
public:
    WaveletTree(std::vector<int>::iterator from, std::vector<int>::iterator to,
                int x, int y) : lo(x), hi(y), left(nullptr), right(nullptr) {
        if (from == to || lo == hi) return;
        int mid = (lo + hi) / 2;
        auto f = [mid](int x) { return x <= mid; };
        b.reserve(to - from + 1);
        b.push_back(0);
        for (auto it = from; it != to; it++)
            b.push_back(b.back() + f(*it));
        
        auto pivot = std::stable_partition(from, to, f);
        left = new WaveletTree(from, pivot, lo, mid);
        right = new WaveletTree(pivot, to, mid + 1, hi);
    }
    
    // K-th smallest in [l, r] (0-indexed)
    int kth(int l, int r, int k) {
        if (lo == hi) return lo;
        int inLeft = b[r + 1] - b[l];
        if (k < inLeft)
            return left->kth(b[l], b[r + 1] - 1, k);
        return right->kth(l - b[l], r - b[r + 1], k - inLeft);
    }
};

int main() {
    std::vector<int> arr = {3, 1, 4, 1, 5, 9, 2, 6};
    WaveletTree wt(arr.begin(), arr.end(), 1, 9);
    
    // 2nd smallest in [0, 4] = sorted({3,1,4,1,5})[1] = 3
    std::cout << "2nd smallest in [0,4]: " << wt.kth(0, 4, 1) << "\n";
    
    // 3rd smallest in [2, 6] = sorted({4,1,5,9,2})[2] = 4
    std::cout << "3rd smallest in [2,6]: " << wt.kth(2, 6, 2) << "\n";
    
    return 0;
}
```

---

## Summary

| Property | Value |
|---|---|
| Build | O(n log σ) |
| Space | O(n log σ) |
| K-th smallest | O(log σ) |
| Range count | O(log σ) |
