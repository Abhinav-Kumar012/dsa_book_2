# Chapter 79: Probabilistic Data Structures

## Prerequisites

- Hashing basics
- Probability basics

## Interview Frequency: ★★

Probabilistic data structures trade exactness for massive space savings. They appear in **Google** and **Amazon** system design interviews for big data problems.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Bloom Filter | ★★★★ | Medium | Membership testing |
| HyperLogLog | ★★ | Hard | Cardinality estimation |
| Count-Min Sketch | ★★ | Medium | Frequency estimation |

---

## 79.1 Bloom Filter

A Bloom Filter tests set membership with **no false negatives** but possible **false positives**.

- Insert: hash element with k hash functions, set k bits
- Query: check if all k bits are set
- Space: O(n) bits (much less than hash set)

```cpp
#include <iostream>
#include <vector>
#include <functional>
#include <string>

class BloomFilter {
    std::vector<bool> bits;
    int size;
    std::vector<std::function<int(const std::string&)>> hashes;
    
public:
    BloomFilter(int size, int numHashes) : bits(size, false), size(size) {
        // Create hash functions using double hashing
        for (int i = 0; i < numHashes; i++) {
            int seed = i * 7919 + 104729;
            hashes.push_back([this, seed](const std::string& s) {
                std::hash<std::string> hasher;
                return (hasher(s) + seed * hasher(s + "salt")) % size;
            });
        }
    }
    
    void insert(const std::string& item) {
        for (auto& h : hashes) {
            bits[std::abs(h(item))] = true;
        }
    }
    
    bool possiblyContains(const std::string& item) {
        for (auto& h : hashes) {
            if (!bits[std::abs(h(item))]) return false;
        }
        return true;
    }
};

int main() {
    BloomFilter bf(1000, 3);
    
    // Insert some items
    for (auto& s : {"apple", "banana", "cherry", "date", "elderberry"})
        bf.insert(s);
    
    // Test membership
    for (auto& s : {"apple", "banana", "fig", "grape", "cherry"}) {
        std::cout << s << ": " 
                  << (bf.possiblyContains(s) ? "possibly present" : "definitely not") 
                  << "\n";
    }
    
    return 0;
}
```

### False Positive Probability

```
P(false positive) ≈ (1 - e^(-kn/m))^k
```

where n = items inserted, m = bits, k = hash functions.

---

## 79.2 HyperLogLog (Overview)

Estimates the number of distinct elements in a stream using O(log log n) space.

**Key idea**: Count the maximum number of leading zeros in hash values. If the maximum is L, estimate cardinality as 2^L.

---

## 79.3 Count-Min Sketch (Overview)

Estimates frequency of elements using d hash functions and d counters of width w.

- Update: increment d counters
- Query: take minimum of d counters

---

## Summary

| Structure | Operation | Space | Error |
|---|---|---|---|
| Bloom Filter | Membership | O(n) bits | False positives only |
| HyperLogLog | Cardinality | O(log log n) | ~2% error |
| Count-Min Sketch | Frequency | O(w × d) | Overestimates |
