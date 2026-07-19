# Chapter 104: Cartesian Trees and Tournament Trees

## Prerequisites
- BST, heap, RMQ

## Interview Frequency: ★★

Cartesian trees bridge arrays and trees. Tournament trees model competitions.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Cartesian tree | ★★★ | Medium | Heap + inorder = array |
| Tournament tree | ★ | Medium | Winner tree |

---

## 104.1 Cartesian Tree

Built from array: heap property on values, inorder traversal = original array. LCA of two nodes = RMQ on original array.

```cpp
#include <iostream>
#include <vector>
#include <stack>

struct CartNode {
    int val, idx;
    CartNode *left, *right;
    CartNode(int v, int i) : val(v), idx(i), left(nullptr), right(nullptr) {}
};

CartNode* buildCartesianTree(const std::vector<int>& arr) {
    int n = arr.size();
    if (n == 0) return nullptr;
    std::stack<CartNode*> st;
    
    for (int i = 0; i < n; i++) {
        CartNode* node = new CartNode(arr[i], i);
        CartNode* last = nullptr;
        while (!st.empty() && st.top()->val > arr[i]) {
            last = st.top();
            st.pop();
        }
        node->left = last;
        if (!st.empty()) st.top()->right = node;
        st.push(node);
    }
    while (st.size() > 1) st.pop();
    return st.top();
}

void printTree(CartNode* node, int depth = 0) {
    if (!node) return;
    printTree(node->right, depth + 1);
    for (int i = 0; i < depth; i++) std::cout << "  ";
    std::cout << node->val << "(i=" << node->idx << ")\n";
    printTree(node->left, depth + 1);
}

int main() {
    std::vector<int> arr = {3, 2, 6, 1, 9, 7, 4};
    CartNode* root = buildCartesianTree(arr);
    std::cout << "Cartesian Tree:\n";
    printTree(root);
    return 0;
}
```

---

## 104.2 Tournament Tree

A complete binary tree where each internal node stores the winner (min/max) of its children. Used in external sorting (k-way merge).

---

## Summary

| Structure | Build | Key Property |
|---|---|---|
| Cartesian tree | O(n) stack | LCA = RMQ |
| Tournament tree | O(n) | K-way merge winner |
