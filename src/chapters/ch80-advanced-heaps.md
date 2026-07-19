# Chapter 80: Advanced Heaps

## Prerequisites

- Basic heap (binary heap)
- Priority queue operations

## Interview Frequency: ★★

Advanced heap variants offer better amortized complexities for specific operations. They appear in **Google** interviews and competitive programming.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Binomial Heap | ★★ | Medium | Merge in O(log n) |
| Fibonacci Heap | ★ | Hard | Decrease-key in O(1) |
| Pairing Heap | ★★ | Medium | Practical alternative |

---

## 80.1 Binomial Heap

A binomial heap is a collection of binomial trees with distinct orders.

**Key properties**:
- Merge: O(log n)
- Insert: O(1) amortized
- Extract-min: O(log n)
- Decrease-key: O(log n)

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

struct BinomialNode {
    int key, degree;
    BinomialNode *child, *sibling, *parent;
    BinomialNode(int k) : key(k), degree(0), child(nullptr), 
                           sibling(nullptr), parent(nullptr) {}
};

class BinomialHeap {
    BinomialNode* head;
    
    BinomialNode* mergeTrees(BinomialNode* t1, BinomialNode* t2) {
        if (t1->key > t2->key) std::swap(t1, t2);
        t2->parent = t1;
        t2->sibling = t1->child;
        t1->child = t2;
        t1->degree++;
        return t1;
    }
    
    BinomialNode* mergeHeaps(BinomialNode* h1, BinomialNode* h2) {
        if (!h1) return h2;
        if (!h2) return h1;
        
        BinomialNode* newHead = nullptr;
        BinomialNode** curr = &newHead;
        
        while (h1 && h2) {
            if (h1->degree <= h2->degree) {
                *curr = h1;
                h1 = h1->sibling;
            } else {
                *curr = h2;
                h2 = h2->sibling;
            }
            curr = &((*curr)->sibling);
        }
        *curr = h1 ? h1 : h2;
        
        // Consolidate trees with same degree
        if (!newHead) return nullptr;
        
        BinomialNode *prev = nullptr, *curr2 = newHead, *next = curr2->sibling;
        while (next) {
            if (curr2->degree != next->degree || 
                (next->sibling && next->sibling->degree == curr2->degree)) {
                prev = curr2;
                curr2 = next;
            } else if (curr2->key <= next->key) {
                curr2->sibling = next->sibling;
                curr2 = mergeTrees(curr2, next);
            } else {
                if (prev) prev->sibling = next;
                else newHead = next;
                next = mergeTrees(next, curr2);
                curr2 = next;
            }
            next = curr2->sibling;
        }
        
        return newHead;
    }
    
public:
    BinomialHeap() : head(nullptr) {}
    
    void insert(int key) {
        BinomialNode* node = new BinomialNode(key);
        head = mergeHeaps(head, node);
    }
    
    int getMin() {
        int minVal = INT_MAX;
        BinomialNode* curr = head;
        while (curr) {
            minVal = std::min(minVal, curr->key);
            curr = curr->sibling;
        }
        return minVal;
    }
    
    void merge(BinomialHeap& other) {
        head = mergeHeaps(head, other.head);
        other.head = nullptr;
    }
};

int main() {
    BinomialHeap h1, h2;
    for (int x : {10, 20, 5, 15}) h1.insert(x);
    for (int x : {3, 8, 12, 25}) h2.insert(x);
    
    std::cout << "H1 min: " << h1.getMin() << "\n";
    std::cout << "H2 min: " << h2.getMin() << "\n";
    
    h1.merge(h2);
    std::cout << "Merged min: " << h1.getMin() << "\n";
    
    return 0;
}
```

---

## 80.2 Fibonacci Heap (Overview)

Fibonacci heaps achieve:
- Insert: O(1) amortized
- Find-min: O(1)
- Decrease-key: O(1) amortized
- Merge: O(1)
- Extract-min: O(log n) amortized

**Used in**: Dijkstra's algorithm with Fibonacci heap gives O(E + V log V).

---

## 80.3 Pairing Heap

A simpler alternative to Fibonacci heaps with good practical performance.

- Insert: O(1)
- Merge: O(1)
- Decrease-key: O(log log n) amortized (conjectured)
- Extract-min: O(log n) amortized

---

## Summary

| Heap | Insert | Extract-Min | Decrease-Key | Merge |
|---|---|---|---|---|
| Binary | O(log n) | O(log n) | O(log n) | O(n) |
| Binomial | O(1) amort | O(log n) | O(log n) | O(log n) |
| Fibonacci | O(1) | O(log n) amort | O(1) amort | O(1) |
| Pairing | O(1) | O(log n) amort | O(log log n)* | O(1) |
