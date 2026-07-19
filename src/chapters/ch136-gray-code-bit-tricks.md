# Chapter 136: Gray Code and Advanced Bit Tricks

## Prerequisites
- Bit manipulation basics

## Interview Frequency: ★★

Gray code and bit tricks appear in **Google** and competitive programming.

---

## 136.1 Gray Code

Consecutive values differ by exactly one bit. Used in hardware, error correction.

```cpp
#include <iostream>
#include <vector>

// Convert to Gray code
int toGray(int n) { return n ^ (n >> 1); }

// Convert from Gray code
int fromGray(int gray) {
    int result = 0;
    while (gray) {
        result ^= gray;
        gray >>= 1;
    }
    return result;
}

int main() {
    std::cout << "Gray code sequence (0-7):\n";
    for (int i = 0; i < 8; i++) {
        int gray = toGray(i);
        std::cout << i << " -> " << gray << " (binary: ";
        for (int b = 2; b >= 0; b--) std::cout << ((gray >> b) & 1);
        std::cout << ")\n";
    }
    
    // Verify consecutive differ by 1 bit
    for (int i = 0; i < 7; i++) {
        int diff = toGray(i) ^ toGray(i + 1);
        int bits = __builtin_popcount(diff);
        std::cout << "Gray(" << i << ") ^ Gray(" << i+1 << ") has " << bits << " bit(s)\n";
    }
    
    return 0;
}
```

---

## 136.2 Bit Tricks Summary

| Trick | Expression | Purpose |
|---|---|---|
| Clear lowest set | `x & (x-1)` | Remove rightmost 1 |
| Isolate lowest set | `x & (-x)` | Get rightmost 1 |
| Set bit i | `x \| (1 << i)` | Set bit |
| Clear bit i | `x & ~(1 << i)` | Clear bit |
| Toggle bit i | `x ^ (1 << i)` | Flip bit |
| Check bit i | `(x >> i) & 1` | Test bit |
| Count set bits | `__builtin_popcount(x)` | Popcount |
| Parity | `__builtin_parity(x)` | Odd/even bits |
| Swap without temp | `a ^= b; b ^= a; a ^= b` | XOR swap |

---

## Summary

| Technique | Application |
|---|---|
| Gray code | Hardware, error correction, Hamiltonian path |
| Bit tricks | Constant-time operations |
