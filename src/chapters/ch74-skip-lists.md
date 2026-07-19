# Chapter 74: Skip Lists

## Prerequisites

- Linked lists
- Probability basics
- Binary search trees

## Interview Frequency: ★★

Skip Lists are a probabilistic alternative to balanced BSTs. They're used in **Redis**, **LevelDB**, and **Apache Lucene**. **Google** and **Amazon** occasionally ask about skip lists to test understanding of probabilistic data structures.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Skip List structure | ★★ | Medium | Multi-level linked list |
| Skip List operations | ★★ | Medium | Search, insert, delete |
| Expected height | ★ | Hard | Probability analysis |

---

## 74.1 Structure

A Skip List is a layered linked list where:
- Level 0: Contains all elements (sorted)
- Level 1: Contains ~n/2 elements (randomly chosen)
- Level 2: Contains ~n/4 elements
- ...
- Top level: Contains ~1 element

Each node has a random number of forward pointers.

```
HEAD ──────────────────────────→ 5 ───────────→ NULL
HEAD ───────────→ 3 ───────────→ 5 ──→ 7 ─────→ NULL
HEAD ──→ 1 ─────→ 3 ──→ 4 ─────→ 5 ──→ 7 ──→ 9 → NULL
```

---

## 74.2 Complete Implementation

```cpp
#include <iostream>
#include <vector>
#include <random>
#include <chrono>
#include <climits>
#include <iomanip>

class SkipList {
    struct Node {
        int val;
        std::vector<Node*> next;
        Node(int v, int level) : val(v), next(level + 1, nullptr) {}
    };
    
    Node* head;
    int maxLevel;
    int currentLevel;
    int size;
    std::mt19937 rng;
    
    int randomLevel() {
        int level = 0;
        while (std::uniform_real_distribution<double>(0.0, 1.0)(rng) < 0.5 
               && level < maxLevel) {
            level++;
        }
        return level;
    }
    
public:
    SkipList(int maxLvl = 32) : maxLevel(maxLvl), currentLevel(0), size(0),
        rng(std::chrono::steady_clock::now().time_since_epoch().count()) {
        head = new Node(INT_MIN, maxLevel);
    }
    
    bool search(int val) {
        Node* curr = head;
        for (int i = currentLevel; i >= 0; i--) {
            while (curr->next[i] && curr->next[i]->val < val) {
                curr = curr->next[i];
            }
        }
        curr = curr->next[0];
        return curr && curr->val == val;
    }
    
    void insert(int val) {
        std::vector<Node*> update(maxLevel + 1, nullptr);
        Node* curr = head;
        
        for (int i = currentLevel; i >= 0; i--) {
            while (curr->next[i] && curr->next[i]->val < val) {
                curr = curr->next[i];
            }
            update[i] = curr;
        }
        
        int newLevel = randomLevel();
        if (newLevel > currentLevel) {
            for (int i = currentLevel + 1; i <= newLevel; i++) {
                update[i] = head;
            }
            currentLevel = newLevel;
        }
        
        Node* newNode = new Node(val, newLevel);
        for (int i = 0; i <= newLevel; i++) {
            newNode->next[i] = update[i]->next[i];
            update[i]->next[i] = newNode;
        }
        size++;
    }
    
    bool erase(int val) {
        std::vector<Node*> update(maxLevel + 1, nullptr);
        Node* curr = head;
        
        for (int i = currentLevel; i >= 0; i--) {
            while (curr->next[i] && curr->next[i]->val < val) {
                curr = curr->next[i];
            }
            update[i] = curr;
        }
        
        curr = curr->next[0];
        if (!curr || curr->val != val) return false;
        
        for (int i = 0; i <= currentLevel; i++) {
            if (update[i]->next[i] != curr) break;
            update[i]->next[i] = curr->next[i];
        }
        
        while (currentLevel > 0 && !head->next[currentLevel]) {
            currentLevel--;
        }
        
        delete curr;
        size--;
        return true;
    }
    
    void print() {
        for (int i = currentLevel; i >= 0; i--) {
            std::cout << "Level " << i << ": ";
            Node* curr = head->next[i];
            while (curr) {
                std::cout << curr->val << " ";
                curr = curr->next[i];
            }
            std::cout << "\n";
        }
    }
    
    int getSize() const { return size; }
};

int main() {
    SkipList sl;
    
    for (int x : {3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5}) {
        sl.insert(x);
    }
    
    std::cout << "Skip List structure:\n";
    sl.print();
    
    std::cout << "\nSearch results:\n";
    for (int x : {1, 3, 5, 7, 9}) {
        std::cout << "  Search " << x << ": " 
                  << (sl.search(x) ? "found" : "not found") << "\n";
    }
    
    sl.erase(3);
    std::cout << "\nAfter erasing 3:\n";
    std::cout << "  Search 3: " << (sl.search(3) ? "found" : "not found") << "\n";
    
    return 0;
}
```

---

## 74.3 Complexity Analysis

| Operation | Expected | Worst | Space |
|---|---|---|---|
| Search | O(log n) | O(n) | O(n) |
| Insert | O(log n) | O(n) | O(n) |
| Delete | O(log n) | O(n) | O(n) |

### Why Expected O(log n)?

The expected height is O(log n) because each level has ~half the nodes of the level below. The probability of a node having k levels is 1/2^k.

---

## 74.4 Skip List vs Balanced BST

| Aspect | Skip List | AVL/Red-Black |
|---|---|---|
| Balance | Probabilistic | Deterministic |
| Implementation | Simple | Complex |
| Concurrent access | Easy (lock-free) | Hard |
| Space | O(n) expected | O(n) |
| Cache behavior | Poor (pointer chasing) | Better |
| Range queries | Easy (follow level 0) | Need successor |

---

## Summary

| Property | Value |
|---|---|
| Search | O(log n) expected |
| Insert | O(log n) expected |
| Delete | O(log n) expected |
| Space | O(n) expected |
| Best for | Concurrent systems, simple implementation |
