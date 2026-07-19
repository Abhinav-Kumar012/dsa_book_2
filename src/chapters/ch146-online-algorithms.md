# Chapter 146: Online Algorithms

## Prerequisites
- Greedy, competitive analysis

## Interview Frequency: ★★

Online algorithms process input without knowing future requests.

---

## 146.1 Competitive Analysis

An online algorithm has competitive ratio c if:
```
ALG(requests) ≤ c · OPT(requests) + constant
```

for all request sequences.

---

## 146.2 Ski Rental

Rent skis $1/day or buy for $B. Strategy: rent for B days, then buy.

```cpp
#include <iostream>
#include <algorithm>

// Ski rental: competitive ratio = 2
int skiRentalCost(int B, int days) {
    // Rent for min(days, B) days, buy if days > B
    return std::min(days, B) + (days > B ? B : 0);
}

int optimalCost(int B, int days) {
    return std::min(days, B);
}

int main() {
    int B = 10;
    for (int d : {5, 10, 15, 20, 30}) {
        int alg = skiRentalCost(B, d);
        int opt = optimalCost(B, d);
        std::cout << "Days=" << d << ": ALG=$" << alg << " OPT=$" << opt 
                  << " ratio=" << (double)alg/opt << "\n";
    }
    return 0;
}
```

---

## 146.3 Paging (Caching)

| Algorithm | Competitive Ratio | Notes |
|---|---|---|
| LRU | k (cache size) | Deterministic optimal |
| FIFO | k | Simpler, same ratio |
| Random | k | Randomized |
| Marking | O(log k) | Randomized, better |

---

## 146.4 Online Matching

Greedy matching has competitive ratio 0.5. Randomized algorithms achieve 1 - 1/e ≈ 0.632.

---

## 146.5 k-Server Problem

Move k servers to serve requests. Conjecture: competitive ratio = 2k-1. Known for k=2 (work function algorithm).

---

## Summary

| Problem | Best Deterministic | Best Randomized |
|---|---|---|
| Ski Rental | 2 | e/(e-1) |
| Paging | k | O(log k) |
| Matching | 0.5 | 1-1/e |
| k-Server | 2k-1 (conjectured) | O(log k) |
