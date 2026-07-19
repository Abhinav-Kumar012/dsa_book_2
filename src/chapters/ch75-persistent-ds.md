# Chapter 75: Persistent Data Structures

## Prerequisites

- Segment trees
- Binary search trees
- Pointers and memory management

## Interview Frequency: ★★★

Persistent data structures preserve previous versions after modifications. They appear in **Google** and **ByteDance** interviews, particularly for problems involving historical queries.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Persistent array | ★★★ | Medium | Copy-on-write |
| Persistent segment tree | ★★★★ | Hard | Versioned queries |
| Persistent BST | ★★ | Hard | Versioned operations |

---

## 75.1 Concept

A **persistent** data structure keeps all previous versions accessible after updates. The key technique is **copy-on-write**: only create new nodes along the update path, sharing unchanged subtrees with previous versions.

```
Version 0:     1
              / \
             2   3

Version 1 (update left to 5):
             1'      ← new root
            / \
           5   3     ← shared with v0
```

---

## 75.2 Persistent Array

```cpp
#include <iostream>
#include <vector>

struct Node {
    int val;
    Node *left, *right;
    Node(int v) : val(v), left(nullptr), right(nullptr) {}
    Node(Node* l, Node* r) : left(l), right(r), val(0) {}
};

// Build persistent array
Node* build(const std::vector<int>& arr, int lo, int hi) {
    if (lo == hi) return new Node(arr[lo]);
    int mid = (lo + hi) / 2;
    return new Node(build(arr, lo, mid), build(arr, mid + 1, hi));
}

// Update: returns new root
Node* update(Node* prev, int lo, int hi, int pos, int val) {
    if (lo == hi) return new Node(val);
    int mid = (lo + hi) / 2;
    if (pos <= mid)
        return new Node(update(prev->left, lo, mid, pos, val), prev->right);
    else
        return new Node(prev->left, update(prev->right, mid + 1, hi, pos, val));
}

// Query
int query(Node* node, int lo, int hi, int pos) {
    if (lo == hi) return node->val;
    int mid = (lo + hi) / 2;
    if (pos <= mid) return query(node->left, lo, mid, pos);
    return query(node->right, mid + 1, hi, pos);
}

int main() {
    std::vector<int> arr = {1, 2, 3, 4, 5};
    int n = arr.size();
    
    // Version 0
    Node* v0 = build(arr, 0, n - 1);
    
    // Version 1: update index 2 to 10
    Node* v1 = update(v0, 0, n - 1, 2, 10);
    
    // Version 2: update index 0 to 20
    Node* v2 = update(v1, 0, n - 1, 0, 20);
    
    std::cout << "Version 0: ";
    for (int i = 0; i < n; i++) std::cout << query(v0, 0, n - 1, i) << " ";
    std::cout << "\n";
    
    std::cout << "Version 1: ";
    for (int i = 0; i < n; i++) std::cout << query(v1, 0, n - 1, i) << " ";
    std::cout << "\n";
    
    std::cout << "Version 2: ";
    for (int i = 0; i < n; i++) std::cout << query(v2, 0, n - 1, i) << " ";
    std::cout << "\n";
    
    return 0;
}
```

---

## 75.3 Persistent Segment Tree

Each update creates O(log n) new nodes. Total space: O(n + Q log n).

```cpp
#include <iostream>
#include <vector>

struct PSTNode {
    int val;
    PSTNode *left, *right;
    PSTNode(int v = 0) : val(v), left(nullptr), right(nullptr) {}
    PSTNode(PSTNode* l, PSTNode* r) : left(l), right(r) {
        val = (l ? l->val : 0) + (r ? r->val : 0);
    }
};

PSTNode* build(int lo, int hi) {
    if (lo == hi) return new PSTNode(0);
    int mid = (lo + hi) / 2;
    return new PSTNode(build(lo, mid), build(mid + 1, hi));
}

PSTNode* update(PSTNode* prev, int lo, int hi, int pos, int val) {
    if (lo == hi) return new PSTNode(prev->val + val);
    int mid = (lo + hi) / 2;
    if (pos <= mid)
        return new PSTNode(update(prev->left, lo, mid, pos, val), prev->right);
    else
        return new PSTNode(prev->left, update(prev->right, mid + 1, hi, pos, val));
}

int query(PSTNode* node, int lo, int hi, int ql, int qr) {
    if (!node || qr < lo || hi < ql) return 0;
    if (ql <= lo && hi <= qr) return node->val;
    int mid = (lo + hi) / 2;
    return query(node->left, lo, mid, ql, qr) + 
           query(node->right, mid + 1, hi, ql, qr);
}

int main() {
    std::vector<int> arr = {1, 2, 3, 4, 5};
    int n = arr.size();
    
    // Build version 0 (all zeros)
    PSTNode* root0 = build(0, n - 1);
    
    // Version 1: add arr values one by one
    std::vector<PSTNode*> roots = {root0};
    for (int i = 0; i < n; i++) {
        roots.push_back(update(roots.back(), 0, n - 1, i, arr[i]));
    }
    
    // Range sum queries on different versions
    // Version 3 has values [1, 2, 3, 0, 0]
    std::cout << "Version 3, range [0, 2] sum: " 
              << query(roots[3], 0, n - 1, 0, 2) << "\n"; // 1+2+3 = 6
    
    // Version 5 has values [1, 2, 3, 4, 5]
    std::cout << "Version 5, range [1, 4] sum: " 
              << query(roots[5], 0, n - 1, 1, 4) << "\n"; // 2+3+4+5 = 14
    
    return 0;
}
```

---

## 75.4 K-th Smallest in Range

Classic application: find the k-th smallest element in arr[l..r].

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Using persistent segment tree on values
// Each version adds one more element
// Range [l, r] corresponds to roots[r+1] - roots[l]

int kthSmallest(PSTNode* rootL, PSTNode* rootR, int lo, int hi, int k) {
    if (lo == hi) return lo;
    int mid = (lo + hi) / 2;
    int leftCount = rootR->left->val - rootL->left->val;
    if (k <= leftCount)
        return kthSmallest(rootL->left, rootR->left, lo, mid, k);
    return kthSmallest(rootL->right, rootR->right, mid + 1, hi, k - leftCount);
}

// (Using PSTNode from above)
```

---

## Summary

| Structure | Update Space | Query Time | Application |
|---|---|---|---|
| Persistent Array | O(log n) new nodes | O(log n) | Version history |
| Persistent Segment Tree | O(log n) new nodes | O(log n) | Range queries on versions |
| Persistent BST | O(log n) new nodes | O(log n) | Ordered versions |

---

## 75.4 Persistent Trees

Any tree structure can be made persistent using path copying. When modifying a node, create a new copy and recursively copy the path to the root.

**Space**: O(log n) new nodes per update for balanced trees.

**Applications**: Version control systems, undo/redo, historical queries.
