# Chapter 105: Cuckoo Hashing and Robin Hood Hashing

## Prerequisites
- Hash tables

## Interview Frequency: ★

Advanced hashing techniques. Show deep understanding of hash table internals.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Cuckoo hashing | ★ | Medium | Worst-case O(1) lookup |
| Robin Hood hashing | ★ | Medium | Variance reduction |

---

## 105.1 Cuckoo Hashing

Use two hash functions and two tables. On collision, evict the existing element to its alternate location.

```cpp
#include <iostream>
#include <vector>
#include <functional>
#include <random>

class CuckooHash {
    std::vector<int> table1, table2;
    int size;
    std::hash<int> h1, h2;
    
public:
    CuckooHash(int n) : size(n), table1(n, -1), table2(n, -1) {}
    
    bool insert(int key) {
        for (int i = 0; i < size; i++) {
            int idx1 = h1(key) % size;
            if (table1[idx1] == -1) { table1[idx1] = key; return true; }
            std::swap(key, table1[idx1]);
            
            int idx2 = h2(key) % size;
            if (table2[idx2] == -1) { table2[idx2] = key; return true; }
            std::swap(key, table2[idx2]);
        }
        return false; // Rehash needed
    }
    
    bool search(int key) {
        int idx1 = h1(key) % size;
        int idx2 = h2(key) % size;
        return table1[idx1] == key || table2[idx2] == key;
    }
};

int main() {
    CuckooHash ch(20);
    for (int x : {10, 20, 30, 40, 50}) ch.insert(x);
    for (int x : {20, 35})
        std::cout << "Search " << x << ": " << ch.search(x) << "\n";
    return 0;
}
```

---

## 105.2 Robin Hood Hashing

On insertion, if the new element has traveled farther from its ideal position than the existing element, swap them. This reduces variance in probe lengths.

**Key insight**: Maximum probe length becomes O(log n) with high probability.

---

## Summary

| Technique | Lookup | Insert | Key Idea |
|---|---|---|---|
| Cuckoo | O(1) worst | O(1) amortized | Two tables, eviction |
| Robin Hood | O(log n) max | O(1) expected | Steal from rich |
