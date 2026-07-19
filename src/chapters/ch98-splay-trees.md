# Chapter 98: Splay Trees

## Prerequisites
- Binary search trees
- Tree rotations

## Interview Frequency: ★★

Splay trees are self-adjusting BSTs where recently accessed elements move to the root. **Google** and research labs test splay tree concepts.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Splay operation | ★★ | Medium | Zig, Zig-Zig, Zig-Zag |
| Amortized analysis | ★ | Hard | Potential method |
| Applications | ★★ | Medium | Caching, sequences |

---

## 98.1 The Splay Operation

Move node to root using rotations:
- **Zig**: Parent is root → single rotation
- **Zig-Zig**: Node and parent same direction → rotate grandparent, then parent
- **Zig-Zag**: Node and parent different direction → rotate parent, then node

```cpp
#include <iostream>
#include <vector>

struct SplayNode {
    int key;
    SplayNode *left, *right, *parent;
    SplayNode(int k) : key(k), left(nullptr), right(nullptr), parent(nullptr) {}
};

class SplayTree {
    SplayNode* root;
    
    void rotateLeft(SplayNode* x) {
        SplayNode* y = x->right;
        if (y) {
            x->right = y->left;
            if (y->left) y->left->parent = x;
            y->parent = x->parent;
        }
        if (!x->parent) root = y;
        else if (x == x->parent->left) x->parent->left = y;
        else x->parent->right = y;
        if (y) y->left = x;
        x->parent = y;
    }
    
    void rotateRight(SplayNode* x) {
        SplayNode* y = x->left;
        if (y) {
            x->left = y->right;
            if (y->right) y->right->parent = x;
            y->parent = x->parent;
        }
        if (!x->parent) root = y;
        else if (x == x->parent->left) x->parent->left = y;
        else x->parent->right = y;
        if (y) y->right = x;
        x->parent = y;
    }
    
    void splay(SplayNode* x) {
        while (x->parent) {
            SplayNode* p = x->parent;
            SplayNode* g = p->parent;
            if (!g) {
                if (x == p->left) rotateRight(p);
                else rotateLeft(p);
            } else if (x == p->left && p == g->left) {
                rotateRight(g); rotateRight(p);
            } else if (x == p->right && p == g->right) {
                rotateLeft(g); rotateLeft(p);
            } else if (x == p->right && p == g->left) {
                rotateLeft(p); rotateRight(g);
            } else {
                rotateRight(p); rotateLeft(g);
            }
        }
    }
    
public:
    SplayTree() : root(nullptr) {}
    
    void insert(int key) {
        SplayNode* node = new SplayNode(key);
        if (!root) { root = node; return; }
        SplayNode* curr = root;
        SplayNode* parent = nullptr;
        while (curr) { parent = curr; curr = (key < curr->key) ? curr->left : curr->right; }
        node->parent = parent;
        if (key < parent->key) parent->left = node;
        else parent->right = node;
        splay(node);
    }
    
    bool search(int key) {
        SplayNode* curr = root;
        SplayNode* last = nullptr;
        while (curr) {
            last = curr;
            if (key == curr->key) break;
            curr = (key < curr->key) ? curr->left : curr->right;
        }
        if (last) splay(last);
        return last && last->key == key;
    }
    
    SplayNode* getRoot() { return root; }
};

int main() {
    SplayTree tree;
    for (int x : {10, 5, 15, 3, 7, 12, 20}) tree.insert(x);
    std::cout << "Search 7: " << tree.search(7) << "\n";
    std::cout << "Root after search: " << tree.getRoot()->key << "\n";
    std::cout << "Search 100: " << tree.search(100) << "\n";
    return 0;
}
```

---

## 98.2 Properties

| Operation | Amortized | Worst |
|---|---|---|
| Search | O(log n) | O(n) |
| Insert | O(log n) | O(n) |
| Delete | O(log n) | O(n) |
| Access sequence | O(m log n) total | — |

**Key insight**: Splay trees are optimal for sequences of operations (dynamic optimality conjecture).

---

## Summary

| Property | Value |
|---|---|
| Balance | Self-adjusting (no stored balance info) |
| Amortized | O(log n) per operation |
| Best for | Temporal locality, caching |
