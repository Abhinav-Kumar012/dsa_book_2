# Chapter 158: Succinct Data Structures

## Prerequisites
- Bit manipulation, data structures

## Interview Frequency: ★

Succinct data structures use n + o(n) bits (close to information-theoretic lower bound) while supporting efficient operations.

---

## 158.1 Information-Theoretic Lower Bounds

- Bitvector of n bits: n bits (trivial)
- Binary tree with n nodes: ~2n bits (Catalan number encoding)
- Permutation of n elements: n log n bits
- Subset of {1..n}: n bits

---

## 158.2 Rank and Select

| Operation | Definition | Time |
|---|---|---|
| Rank(i) | Count of 1s in B[0..i] | O(1) with o(n) extra |
| Select(k) | Position of k-th 1 | O(1) with o(n) extra |

```cpp
#include <iostream>
#include <vector>
#include <cmath>

// Simple rank/select using superblocks
class SuccinctBitvector {
    std::vector<int> bits;
    std::vector<int> rankBlocks; // Rank at block boundaries
    int blockSize;
    
public:
    SuccinctBitvector(const std::vector<int>& b) : bits(b) {
        blockSize = std::max(1, (int)(std::log2(b.size()) * std::log2(b.size())));
        rankBlocks.push_back(0);
        int count = 0;
        for (int i = 0; i < (int)bits.size(); i++) {
            count += bits[i];
            if ((i + 1) % blockSize == 0)
                rankBlocks.push_back(count);
        }
    }
    
    int rank(int i) {
        int block = (i + 1) / blockSize;
        int r = (block < (int)rankBlocks.size()) ? rankBlocks[block] : 0;
        for (int j = block * blockSize; j <= i; j++)
            r += bits[j];
        return r;
    }
    
    int select(int k) {
        // Binary search on rank blocks
        int lo = 0, hi = (int)rankBlocks.size() - 1;
        while (lo < hi) {
            int mid = (lo + hi) / 2;
            if (rankBlocks[mid] < k) lo = mid + 1;
            else hi = mid;
        }
        int start = lo * blockSize;
        int count = (lo > 0) ? rankBlocks[lo - 1] : 0;
        for (int i = start; i < (int)bits.size(); i++) {
            count += bits[i];
            if (count == k) return i;
        }
        return -1;
    }
};

int main() {
    std::vector<int> bits = {1,0,1,1,0,1,0,0,1,1,0,1};
    SuccinctBitvector bv(bits);
    
    std::cout << "rank(5) = " << bv.rank(5) << "\n";    // 4
    std::cout << "rank(8) = " << bv.rank(8) << "\n";    // 5
    std::cout << "select(3) = " << bv.select(3) << "\n"; // 3 (0-indexed position of 3rd 1)
    std::cout << "select(5) = " << bv.select(5) << "\n"; // 8
    
    return 0;
}
```

---

## 158.3 LOUDS Representation

Level-Order Unary Degree Sequence. Represents trees in 2n + o(n) bits.

**Encoding**: BFS order, each node with d children is encoded as d 1s followed by a 0.

**Operations**: O(1) child, parent, subtree size with o(n) extra space.

---

## 158.4 FM-Index

Combines BWT with rank/select for pattern matching in nH_k + o(n) bits, where H_k is the k-th order entropy.

---

## 158.5 Wavelet Matrix

Variant of wavelet tree optimized for succinct representation. Supports rank/select on multi-dimensional data in O(log σ) time.

---

## Summary

| Structure | Space | Operations | Application |
|---|---|---|---|
| Bitvector + rank/select | n + o(n) bits | O(1) | Foundation |
| LOUDS | 2n + o(n) bits | O(1) child/parent | Tree representation |
| FM-Index | nH_k + o(n) bits | O(m) search | Text indexing |
| Wavelet Matrix | n log σ + o(n) bits | O(log σ) rank | Range queries |
