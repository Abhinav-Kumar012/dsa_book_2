# Chapter 95: Advanced Bit Manipulation

## Prerequisites

- Bit manipulation basics

## Interview Frequency: ★★★

Advanced bit tricks appear in **Google** and **Amazon** interviews for optimization problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Subset enumeration | ★★★ | Medium | Iterate all subsets |
| Bit DP | ★★★★ | Medium | State compression |
| De Bruijn sequences | ★ | Hard | Bit scanning |
| Popcount tricks | ★★★ | Easy | Count set bits |

---

## 95.1 Subset Enumeration

Enumerate all subsets of a set represented as bitmask.

```cpp
#include <iostream>
#include <vector>

int main() {
    int n = 4;
    int fullMask = (1 << n) - 1;
    
    std::cout << "All subsets of {0,1,2,3}:\n";
    for (int mask = 0; mask <= fullMask; mask++) {
        std::cout << "{";
        bool first = true;
        for (int i = 0; i < n; i++) {
            if (mask & (1 << i)) {
                if (!first) std::cout << ",";
                std::cout << i;
                first = false;
            }
        }
        std::cout << "}\n";
    }
    
    // Enumerate submasks of a mask
    int mask = 0b1101; // {0, 2, 3}
    std::cout << "\nSubmasks of {0,2,3}:\n";
    for (int sub = mask; sub; sub = (sub - 1) & mask) {
        std::cout << "  " << sub << " (";
        for (int i = 0; i < 4; i++)
            if (sub & (1 << i)) std::cout << i;
        std::cout << ")\n";
    }
    
    return 0;
}
```

---

## 95.2 Popcount Tricks

```cpp
#include <iostream>
#include <bitset>

int popcount(int x) {
    int count = 0;
    while (x) {
        x &= x - 1; // Clear lowest set bit
        count++;
    }
    return count;
}

int main() {
    int x = 0b11010110;
    std::cout << "Binary: " << std::bitset<8>(x) << "\n";
    std::cout << "Popcount: " << popcount(x) << "\n";
    std::cout << "builtin_popcount: " << __builtin_popcount(x) << "\n";
    
    // Lowest set bit
    int lowest = x & (-x);
    std::cout << "Lowest set bit: " << std::bitset<8>(lowest) << "\n";
    
    return 0;
}
```

---

## 95.3 Bit DP (State Compression)

Use bitmask as DP state for problems with small n (≤ 20).

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

// TSP: Find shortest Hamiltonian cycle
int tsp(const std::vector<std::vector<int>>& dist) {
    int n = dist.size();
    int fullMask = (1 << n) - 1;
    std::vector<std::vector<int>> dp(1 << n, std::vector<int>(n, INT_MAX));
    
    dp[1][0] = 0; // Start at node 0
    
    for (int mask = 1; mask <= fullMask; mask++) {
        for (int u = 0; u < n; u++) {
            if (!(mask & (1 << u)) || dp[mask][u] == INT_MAX) continue;
            for (int v = 0; v < n; v++) {
                if (mask & (1 << v)) continue;
                int newMask = mask | (1 << v);
                dp[newMask][v] = std::min(dp[newMask][v], dp[mask][u] + dist[u][v]);
            }
        }
    }
    
    int result = INT_MAX;
    for (int u = 1; u < n; u++)
        result = std::min(result, dp[fullMask][u] + dist[u][0]);
    
    return result;
}

int main() {
    std::vector<std::vector<int>> dist = {
        {0, 10, 15, 20},
        {10, 0, 35, 25},
        {15, 35, 0, 30},
        {20, 25, 30, 0}
    };
    
    std::cout << "TSP min cost: " << tsp(dist) << "\n"; // 80
    
    return 0;
}
```

---

## Summary

| Technique | Time | Best For |
|---|---|---|
| Subset enumeration | O(2^n) | Iterate all subsets |
| Submask enumeration | O(3^n) total | Subset of subset |
| Popcount | O(1) builtin | Count bits |
| Bit DP | O(2^n × n) | TSP, assignment |
