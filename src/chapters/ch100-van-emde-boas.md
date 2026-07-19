# Chapter 100: Van Emde Boas Trees and X-Fast/Y-Fast Tries

## Prerequisites
- Binary trie, hash tables
- Bit manipulation

## Interview Frequency: ★

Theoretical data structures with O(log log n) operations. Rarely asked but show deep understanding.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Van Emde Boas | ★ | Hard | O(log log n) operations |
| X-Fast Trie | ★ | Hard | O(log log n) search |
| Y-Fast Trie | ★ | Hard | Expected O(log log n) |

---

## 100.1 Van Emde Boas Tree

Supports insert, delete, successor, predecessor in O(log log U) where U is the universe size.

**Key idea**: Recursively split the universe into √U clusters of size √U.

```cpp
#include <iostream>
#include <vector>
#include <cmath>
#include <climits>

class VEBTree {
    int universeSize;
    int minVal, maxVal;
    VEBTree* summary;
    std::vector<VEBTree*> clusters;
    
    int high(int x) { return x / (int)sqrt(universeSize); }
    int low(int x) { return x % (int)sqrt(universeSize); }
    int index(int h, int l) { return h * (int)sqrt(universeSize) + l; }
    
public:
    VEBTree(int size) : universeSize(size), minVal(-1), maxVal(-1), summary(nullptr) {
        if (size <= 2) return;
        int clusterSize = (int)ceil(sqrt(size));
        summary = new VEBTree(clusterSize);
        clusters.resize(clusterSize, nullptr);
    }
    
    bool isEmpty() { return minVal == -1; }
    
    void insert(int x) {
        if (minVal == -1) {
            minVal = maxVal = x;
            return;
        }
        if (x < minVal) std::swap(x, minVal);
        if (universeSize > 2) {
            int h = high(x), l = low(x);
            if (!clusters[h]) clusters[h] = new VEBTree((int)ceil(sqrt(universeSize)));
            if (clusters[h]->isEmpty()) {
                summary->insert(h);
            }
            clusters[h]->insert(l);
        }
        if (x > maxVal) maxVal = x;
    }
    
    bool search(int x) {
        if (x == minVal || x == maxVal) return true;
        if (universeSize <= 2) return false;
        int h = high(x);
        if (!clusters[h]) return false;
        return clusters[h]->search(low(x));
    }
    
    int successor(int x) {
        if (universeSize == 2) {
            if (x == 0 && maxVal == 1) return 1;
            return -1;
        }
        if (minVal != -1 && x < minVal) return minVal;
        int h = high(x), l = low(x);
        if (clusters[h] && l < clusters[h]->maxVal) {
            int succ = clusters[h]->successor(l);
            return index(h, succ);
        }
        int succCluster = summary->successor(h);
        if (succCluster == -1) return -1;
        return index(succCluster, clusters[succCluster]->minVal);
    }
};

int main() {
    VEBTree veb(16); // Universe [0, 15]
    for (int x : {2, 3, 4, 5, 7, 14, 15}) veb.insert(x);
    
    std::cout << "Search 4: " << veb.search(4) << "\n";
    std::cout << "Search 6: " << veb.search(6) << "\n";
    std::cout << "Successor of 5: " << veb.successor(5) << "\n";
    std::cout << "Successor of 7: " << veb.successor(7) << "\n";
    
    return 0;
}
```

---

## 100.2 X-Fast and Y-Fast Tries

| Structure | Search | Insert | Space |
|---|---|---|---|
| X-Fast Trie | O(log log U) | O(U) worst | O(n log U) |
| Y-Fast Trie | O(log log U) expected | O(log log U) expected | O(n) |
| Van Emde Boas | O(log log U) | O(log log U) | O(U) |

---

## Summary

| Structure | Key Insight | Best For |
|---|---|---|
| VEB | Recursive √U split | Dense universe |
| X-Fast | Binary trie + hash | Theoretical |
| Y-Fast | X-Fast + BST | Practical O(log log n) |
