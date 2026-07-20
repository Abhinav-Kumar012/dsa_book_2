# Chapter 99: Scapegoat Trees and AA Trees

## Prerequisites
- BST basics, AVL trees

## Interview Frequency: ★

Simpler balanced BST alternatives. Rarely asked directly but good to know.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Scapegoat tree | ★ | Medium | Rebuild subtrees |
| AA tree | ★ | Medium | Red-black simplification |

---

## 99.1 Scapegoat Trees

Instead of rotations, rebuild unbalanced subtrees from scratch.

**Key idea**: If a node's subtree becomes too unbalanced (depth > log_{1/α}(size)), rebuild it into a perfectly balanced tree.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

struct Node {
    int key, size;
    Node *left, *right;
    Node(int k) : key(k), size(1), left(nullptr), right(nullptr) {}
};

int getSize(Node* n) { return n ? n->size : 0; }
void updateSize(Node* n) { if (n) n->size = 1 + getSize(n->left) + getSize(n->right); }

// Flatten tree to sorted array
void flatten(Node* n, std::vector<Node*>& nodes) {
    if (!n) return;
    flatten(n->left, nodes);
    nodes.push_back(n);
    flatten(n->right, nodes);
}

// Build balanced tree from sorted array
Node* buildBalanced(std::vector<Node*>& nodes, int lo, int hi) {
    if (lo > hi) return nullptr;
    int mid = (lo + hi) / 2;
    Node* n = nodes[mid];
    n->left = buildBalanced(nodes, lo, mid - 1);
    n->right = buildBalanced(nodes, mid + 1, hi);
    updateSize(n);
    return n;
}

Node* rebuild(Node* root) {
    std::vector<Node*> nodes;
    flatten(root, nodes);
    return buildBalanced(nodes, 0, nodes.size() - 1);
}

int main() {
    std::cout << "Scapegoat tree: rebuild subtree when depth > log_{1/alpha}(size)\n";
    std::cout << "Alpha typically 0.5-0.75\n";
    std::cout << "No rotation needed, just rebuild\n";
    return 0;
}
```

---

## 99.2 AA Trees

AA trees are red-black trees with one constraint: red nodes can only be right children. This simplifies implementation dramatically.

```cpp
#include <iostream>

struct AANode {
    int key, level;
    AANode *left, *right;
    AANode(int k) : key(k), level(1), left(nullptr), right(nullptr) {}
};

class AATree {
    AANode* root;
    
    AANode* skew(AANode* n) {
        if (n && n->left && n->left->level == n->level) {
            AANode* l = n->left;
            n->left = l->right;
            l->right = n;
            return l;
        }
        return n;
    }
    
    AANode* split(AANode* n) {
        if (n && n->right && n->right->right && 
            n->right->right->level == n->level) {
            AANode* r = n->right;
            n->right = r->left;
            r->left = n;
            r->level++;
            return r;
        }
        return n;
    }
    
    AANode* insert(AANode* n, int key) {
        if (!n) return new AANode(key);
        if (key < n->key) n->left = insert(n->left, key);
        else if (key > n->key) n->right = insert(n->right, key);
        n = skew(n);
        n = split(n);
        return n;
    }
    
public:
    AATree() : root(nullptr) {}
    void insert(int key) { root = insert(root, key); }
    
    bool search(int key) {
        AANode* curr = root;
        while (curr) {
            if (key == curr->key) return true;
            curr = (key < curr->key) ? curr->left : curr->right;
        }
        return false;
    }
};

int main() {
    AATree tree;
    for (int x : {10, 5, 15, 3, 7, 12, 20}) tree.insert(x);
    for (int x : {7, 15, 100})
        std::cout << "Search " << x << ": " << tree.search(x) << "\n";
    return 0;
}
```

---

## Summary

| Tree | Key Idea | Rotations | Rebuilds |
|---|---|---|---|
| Scapegoat | Rebuild unbalanced subtrees | None | On insertion |
| AA Tree | Red only as right child | Simple skew/split | None |

---

## See Also

- [Chapter 13: Trees](ch13-trees.md) — Tree fundamentals: traversals, recursion, and basic tree properties.
- [Chapter 14: Binary Search Trees](ch14-bst.md) — The foundation; Scapegoat and AA trees are balanced BST variants.
- [Chapter 98: Splay Trees](ch98-splay-trees.md) — Another self-adjusting BST; compare amortized guarantees vs worst-case guarantees.
- [Chapter 74: Skip Lists](ch74-skip-lists.md) — A probabilistic alternative to balanced BSTs with simpler implementation.
- [Chapter 100: Van Emde Boas Trees](ch100-van-emde-boas.md) — For integer keys in a bounded range, vEB trees achieve O(log log n).
