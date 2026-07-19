# Chapter 135: De Bruijn Sequences and Morton Codes

## Prerequisites
- Bit manipulation

## Interview Frequency: ★

Advanced bit tricks for specialized applications.

---

## 135.1 De Bruijn Sequences

A De Bruijn sequence B(k, n) contains every possible length-n string over alphabet of size k exactly once as a substring.

**Application**: Find the index of the least significant set bit in O(1) using a precomputed table.

```cpp
#include <iostream>
#include <cstdint>

// Find index of lowest set bit using De Bruijn sequence
int lowestBitIndex(uint32_t x) {
    if (x == 0) return -1;
    static const int table[32] = {
        0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8,
        31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9
    };
    return table[((uint32_t)(x & -x) * 0x077CB531U) >> 27];
}

int main() {
    for (uint32_t x : {1, 2, 4, 8, 16, 128, 1024})
        std::cout << "Lowest bit of " << x << ": index " << lowestBitIndex(x) << "\n";
    return 0;
}
```

---

## 135.2 Morton Codes (Z-Order Curve)

Interleave bits of x and y coordinates to create a space-filling curve. Enables efficient 2D range queries.

```cpp
#include <iostream>
#include <cstdint>

uint32_t mortonEncode(uint32_t x, uint32_t y) {
    uint32_t z = 0;
    for (int i = 0; i < 16; i++) {
        z |= ((x & (1 << i)) << i) | ((y & (1 << i)) << (i + 1));
    }
    return z;
}

int main() {
    std::cout << "Morton(3, 5) = " << mortonEncode(3, 5) << "\n";
    std::cout << "Morton(0, 0) = " << mortonEncode(0, 0) << "\n";
    return 0;
}
```

---

## Summary

| Technique | Application | Complexity |
|---|---|---|
| De Bruijn | Bit index lookup | O(1) |
| Morton code | 2D spatial indexing | O(1) encode |
