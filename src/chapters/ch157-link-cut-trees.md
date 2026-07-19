# Chapter 157: Link-Cut Trees and Euler Tour Trees

## Prerequisites
- Splay trees, tree basics

## Interview Frequency: ★★

---

## 157.1 Link-Cut Trees

Maintain a dynamic forest with O(log n) per operation:
- `link(u, v)`: Add edge between trees
- `cut(u, v)`: Remove edge
- `findRoot(u)`: Find root of tree
- `pathQuery(u, v)`: Aggregate on path

**Key idea**: Represent preferred paths as splay trees. Access operations change preferred paths.

```cpp
#include <iostream>
#include <vector>

// Simplified Link-Cut Tree for connectivity
class LinkCutTree {
    struct Node {
        int id;
        Node *left, *right, *parent;
        bool reversed;
        Node(int i) : id(i), left(nullptr), right(nullptr), 
                      parent(nullptr), reversed(false) {}
    };
    
    std::vector<Node*> nodes;
    
    bool isRoot(Node* x) {
        return !x->parent || (x->parent->left != x && x->parent->right != x);
    }
    
    void push(Node* x) {
        if (x && x->reversed) {
            x->reversed = false;
            std::swap(x->left, x->right);
            if (x->left) x->left->reversed ^= true;
            if (x->right) x->right->reversed ^= true;
        }
    }
    
    void rotate(Node* x) {
        Node* p = x->parent;
        Node* g = p->parent;
        push(p); push(x);
        
        if (x == p->left) {
            p->left = x->right;
            if (x->right) x->right->parent = p;
            x->right = p;
        } else {
            p->right = x->left;
            if (x->left) x->left->parent = p;
            x->left = p;
        }
        p->parent = x;
        x->parent = g;
        if (g) {
            if (p == g->left) g->left = x;
            else if (p == g->right) g->right = x;
        }
    }
    
    void splay(Node* x) {
        while (!isRoot(x)) {
            Node* p = x->parent;
            if (!isRoot(p)) {
                Node* g = p->parent;
                push(g);
                if ((x == p->left) == (p == g->left)) { rotate(p); rotate(x); }
                else { rotate(x); rotate(x); }
            } else {
                push(p);
                rotate(x);
            }
        }
        push(x);
    }
    
    Node* access(Node* x) {
        Node* last = nullptr;
        for (Node* y = x; y; y = y->parent) {
            splay(y);
            y->right = last;
            last = y;
        }
        splay(x);
        return last;
    }
    
    void makeRoot(Node* x) {
        access(x);
        x->reversed ^= true;
    }
    
public:
    LinkCutTree(int n) : nodes(n) {
        for (int i = 0; i < n; i++) nodes[i] = new Node(i);
    }
    
    void link(int u, int v) {
        makeRoot(nodes[u]);
        nodes[u]->parent = nodes[v];
    }
    
    void cut(int u, int v) {
        makeRoot(nodes[u]);
        access(nodes[v]);
        if (nodes[v]->left == nodes[u]) {
            nodes[v]->left = nullptr;
            nodes[u]->parent = nullptr;
        }
    }
    
    bool connected(int u, int v) {
        makeRoot(nodes[u]);
        access(nodes[v]);
        // After access, v's left subtree contains the path from root to v
        // If u is in that subtree, they're connected
        Node* curr = nodes[v];
        while (curr->left) curr = curr->left;
        return curr == nodes[u];
    }
    
    int findRoot(int u) {
        access(nodes[u]);
        Node* curr = nodes[u];
        while (curr->left) { push(curr); curr = curr->left; }
        splay(curr);
        return curr->id;
    }
};

int main() {
    LinkCutTree lct(6);
    lct.link(0, 1); lct.link(1, 2); lct.link(2, 3);
    
    std::cout << "0-3 connected: " << lct.connected(0, 3) << "\n"; // 1
    lct.cut(1, 2);
    std::cout << "0-3 connected: " << lct.connected(0, 3) << "\n"; // 0
    
    lct.link(3, 4); lct.link(4, 5);
    std::cout << "Find root of 5: " << lct.findRoot(5) << "\n"; // 3
    
    return 0;
}
```

---

## 157.2 Euler Tour Trees

Represent a tree using Euler tour stored in a balanced BST. Supports link/cut in O(log n).

---

## Summary

| Structure | link | cut | connected | path query |
|---|---|---|---|---|
| Link-Cut Tree | O(log n) | O(log n) | O(log n) | O(log n) |
| Euler Tour Tree | O(log n) | O(log n) | O(log n) | O(log² n) |
