# Chapter 103: Interval Trees and Order Statistic Trees

## Prerequisites
- BST, augmentation

## Interview Frequency: ★★

Augmented BSTs for specialized queries.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Interval tree | ★★ | Medium | Overlapping intervals |
| Order statistic tree | ★★★ | Medium | K-th element |

---

## 103.1 Interval Tree

Store intervals, find all intervals overlapping a point or query interval.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <set>

struct Interval {
    int lo, hi;
    bool overlaps(const Interval& other) const {
        return lo <= other.hi && other.lo <= hi;
    }
};

// Using std::set with custom comparator
class IntervalTree {
    std::set<std::pair<int,int>> intervals; // (endpoint, startpoint)
    
public:
    void insert(int lo, int hi) {
        intervals.insert({hi, lo});
    }
    
    // Find any interval containing point x
    std::pair<int,int> findContaining(int x) {
        auto it = intervals.lower_bound({x, INT_MIN});
        if (it != intervals.end() && it->second <= x) return {it->second, it->first};
        return {-1, -1};
    }
};

int main() {
    IntervalTree tree;
    tree.insert(15, 20);
    tree.insert(10, 30);
    tree.insert(17, 19);
    tree.insert(5, 20);
    tree.insert(12, 15);
    
    auto [lo, hi] = tree.findContaining(14);
    std::cout << "Interval containing 14: [" << lo << ", " << hi << "]\n";
    
    return 0;
}
```

---

## 103.2 Order Statistic Tree

Augment BST nodes with subtree size to support:
- `select(k)`: Find k-th smallest element
- `rank(x)`: Find position of x in sorted order

```cpp
#include <iostream>
#include <vector>

struct OSNode {
    int key, size;
    OSNode *left, *right;
    OSNode(int k) : key(k), size(1), left(nullptr), right(nullptr) {}
};

int getSize(OSNode* n) { return n ? n->size : 0; }
void update(OSNode* n) { if (n) n->size = 1 + getSize(n->left) + getSize(n->right); }

OSNode* insert(OSNode* root, int key) {
    if (!root) return new OSNode(key);
    if (key < root->key) root->left = insert(root->left, key);
    else root->right = insert(root->right, key);
    update(root);
    return root;
}

// K-th smallest (0-indexed)
int select(OSNode* root, int k) {
    int leftSize = getSize(root->left);
    if (k < leftSize) return select(root->left, k);
    if (k == leftSize) return root->key;
    return select(root->right, k - leftSize - 1);
}

// Number of elements < key
int rank(OSNode* root, int key) {
    if (!root) return 0;
    if (key <= root->key) return rank(root->left, key);
    return getSize(root->left) + 1 + rank(root->right, key);
}

int main() {
    OSNode* root = nullptr;
    for (int x : {20, 10, 30, 5, 15, 25, 35}) root = insert(root, x);
    
    std::cout << "2nd smallest: " << select(root, 1) << "\n";
    std::cout << "Rank of 15: " << rank(root, 15) << " (elements < 15)\n";
    std::cout << "Rank of 25: " << rank(root, 25) << " (elements < 25)\n";
    
    return 0;
}
```

---

## Summary

| Structure | Key Operation | Time |
|---|---|---|
| Interval tree | Find overlapping interval | O(log n) |
| Order statistic tree | K-th element, rank | O(log n) |
