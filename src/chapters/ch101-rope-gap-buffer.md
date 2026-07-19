# Chapter 101: Rope and Gap Buffer

## Prerequisites
- Binary trees, strings

## Interview Frequency: ★

Text editor data structures. Rarely asked but show systems knowledge.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Rope | ★ | Medium | Tree-based string |
| Gap Buffer | ★ | Medium | Array with gap |

---

## 101.1 Rope

A rope is a binary tree where leaves hold string fragments. Supports O(log n) concatenation, split, and insert.

```cpp
#include <iostream>
#include <string>

struct RopeNode {
    std::string data;
    int weight; // Size of left subtree + own data
    RopeNode *left, *right;
    RopeNode(const std::string& s) : data(s), weight(s.size()), left(nullptr), right(nullptr) {}
};

class Rope {
    RopeNode* root;
    
    int getWeight(RopeNode* n) { return n ? n->weight : 0; }
    
    char charAt(RopeNode* n, int index) {
        if (!n) return '\0';
        if (!n->left && !n->right) return n->data[index];
        if (index < getWeight(n->left)) return charAt(n->left, index);
        return charAt(n->right, index - getWeight(n->left));
    }
    
public:
    Rope(const std::string& s) : root(new RopeNode(s)) {}
    
    char charAt(int index) { return charAt(root, index); }
    
    // Concatenate two ropes
    static RopeNode* concat(RopeNode* a, RopeNode* b) {
        RopeNode* n = new RopeNode("");
        n->left = a;
        n->right = b;
        n->weight = getWeight(a) + (a ? a->data.size() : 0);
        return n;
    }
};

int main() {
    Rope rope("Hello, World!");
    for (int i = 0; i < 13; i++)
        std::cout << rope.charAt(i);
    std::cout << "\n";
    return 0;
}
```

---

## 101.2 Gap Buffer

A gap buffer maintains a gap (empty space) at the cursor position in a text editor. Insert/delete at cursor is O(1); moving the cursor requires O(n) to shift the gap.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

class GapBuffer {
    std::vector<char> buffer;
    int gapStart, gapEnd;
    
public:
    GapBuffer(int capacity) : buffer(capacity, ' '), gapStart(0), gapEnd(capacity) {}
    
    void moveGap(int position) {
        while (gapStart < position) {
            buffer[gapStart++] = buffer[gapEnd++];
        }
        while (gapStart > position) {
            buffer[--gapEnd] = buffer[--gapStart];
        }
    }
    
    void insert(int position, char c) {
        moveGap(position);
        buffer[gapStart++] = c;
    }
    
    std::string getText() {
        std::string result;
        for (int i = 0; i < gapStart; i++) result += buffer[i];
        for (int i = gapEnd; i < (int)buffer.size(); i++) result += buffer[i];
        return result;
    }
};

int main() {
    GapBuffer gb(100);
    std::string text = "Hello World";
    for (int i = 0; i < (int)text.size(); i++) gb.insert(i, text[i]);
    std::cout << gb.getText() << "\n";
    return 0;
}
```

---

## Summary

| Structure | Insert at cursor | Move cursor | Space |
|---|---|---|---|
| Rope | O(log n) | O(1) | O(n) |
| Gap Buffer | O(1) | O(n) worst | O(n) |
| Array | O(n) | O(1) | O(n) |
