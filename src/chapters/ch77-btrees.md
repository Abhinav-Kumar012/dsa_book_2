# Chapter 77: B-Trees and Database Indexing

## Prerequisites

- Binary search trees
- Disk I/O concepts

## Interview Frequency: ★★★

B-Trees are the foundation of database indexing. **Amazon**, **Google**, and database companies test B-Tree knowledge for system design interviews.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| B-Tree structure | ★★★ | Medium | Multi-way search tree |
| B-Tree operations | ★★★ | Medium | Insert, delete, search |
| B+ Tree | ★★★ | Medium | Leaf-linked variant |
| Disk I/O analysis | ★★ | Medium | Why B-Trees for disks |

---

## 77.1 Why B-Trees?

Disk access is ~100,000× slower than memory access. B-Trees minimize disk I/O by:
- Having high fanout (many children per node)
- Keeping tree height extremely low
- Each node fits in one disk page

| Order m | Height for 10^9 keys | Disk reads |
|---|---|---|
| 100 | 5 | 5 |
| 500 | 4 | 4 |
| 1000 | 3 | 3 |

---

## 77.2 B-Tree Properties

A B-Tree of order m:
- Each node has at most m children and m-1 keys
- Each non-root node has at least ⌈m/2⌉ children
- All leaves are at the same depth
- Keys within each node are sorted

---

## 77.3 B-Tree Implementation

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

template <int ORDER>
class BTree {
    struct Node {
        std::vector<int> keys;
        std::vector<Node*> children;
        bool leaf;
        Node(bool isLeaf) : leaf(isLeaf) {}
    };
    
    Node* root;
    
    void splitChild(Node* parent, int idx) {
        Node* full = parent->children[idx];
        Node* newNode = new Node(full->leaf);
        int mid = ORDER / 2;
        
        for (int i = mid + 1; i < (int)full->keys.size(); i++)
            newNode->keys.push_back(full->keys[i]);
        
        if (!full->leaf) {
            for (int i = mid + 1; i <= (int)full->children.size() - 1; i++)
                newNode->children.push_back(full->children[i]);
            full->children.resize(mid + 1);
        }
        
        parent->keys.insert(parent->keys.begin() + idx, full->keys[mid]);
        parent->children.insert(parent->children.begin() + idx + 1, newNode);
        full->keys.resize(mid);
    }
    
    void insertNonFull(Node* node, int key) {
        int i = node->keys.size() - 1;
        
        if (node->leaf) {
            node->keys.push_back(0);
            while (i >= 0 && node->keys[i] > key) {
                node->keys[i + 1] = node->keys[i];
                i--;
            }
            node->keys[i + 1] = key;
        } else {
            while (i >= 0 && node->keys[i] > key) i--;
            i++;
            if ((int)node->children[i]->keys.size() == ORDER - 1) {
                splitChild(node, i);
                if (key > node->keys[i]) i++;
            }
            insertNonFull(node->children[i], key);
        }
    }
    
    bool search(Node* node, int key) {
        if (!node) return false;
        int i = 0;
        while (i < (int)node->keys.size() && key > node->keys[i]) i++;
        if (i < (int)node->keys.size() && key == node->keys[i]) return true;
        if (node->leaf) return false;
        return search(node->children[i], key);
    }
    
public:
    BTree() : root(nullptr) {}
    
    void insert(int key) {
        if (!root) {
            root = new Node(true);
            root->keys.push_back(key);
            return;
        }
        if ((int)root->keys.size() == ORDER - 1) {
            Node* newRoot = new Node(false);
            newRoot->children.push_back(root);
            splitChild(newRoot, 0);
            root = newRoot;
        }
        insertNonFull(root, key);
    }
    
    bool search(int key) { return search(root, key); }
};

int main() {
    BTree<5> tree;
    for (int x : {10, 20, 5, 6, 12, 30, 7, 17, 3, 1, 25, 40, 50})
        tree.insert(x);
    
    for (int x : {6, 15, 25, 50})
        std::cout << "Search " << x << ": " 
                  << (tree.search(x) ? "found" : "not found") << "\n";
    
    return 0;
}
```

---

## 77.4 B-Tree vs B+ Tree

| Feature | B-Tree | B+ Tree |
|---|---|---|
| Data location | Internal + leaf | Leaf only |
| Leaf linkage | No | Yes (linked list) |
| Range queries | Slow | Fast (scan leaves) |
| Internal node capacity | Smaller | Larger |
| Used by | MongoDB | MySQL, PostgreSQL |

---

## Summary

| Property | B-Tree | B+ Tree |
|---|---|---|
| Search | O(log n) | O(log n) |
| Insert | O(log n) | O(log n) |
| Range query | O(n) | O(log n + k) |
| Disk I/O | Minimal | Minimal |
| Best for | General indexing | Range-heavy workloads |
