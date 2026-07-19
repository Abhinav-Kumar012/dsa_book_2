# Chapter 90: C++ Deep Dive for Interviews

## Prerequisites

- C++ basics
- OOP concepts

## Interview Frequency: ★★★★

Deep C++ knowledge is tested at **Google**, **Meta**, **Amazon**, and systems companies.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Rule of 5 | ★★★★ | Medium | Copy/move semantics |
| Move semantics | ★★★★ | Medium | std::move, rvalue refs |
| Smart pointers | ★★★ | Medium | unique_ptr, shared_ptr |
| Value categories | ★★★ | Medium | lvalue, rvalue, xvalue |
| RAII | ★★★★ | Medium | Resource management |

---

## 90.1 Rule of Five

If you define any of: destructor, copy constructor, copy assignment, move constructor, move assignment — you should define all five.

```cpp
#include <iostream>
#include <cstring>
#include <utility>

class MyString {
    char* data;
    size_t len;
    
public:
    // Constructor
    MyString(const char* s = "") : len(strlen(s)) {
        data = new char[len + 1];
        memcpy(data, s, len + 1);
    }
    
    // Destructor
    ~MyString() { delete[] data; }
    
    // Copy constructor
    MyString(const MyString& other) : len(other.len) {
        data = new char[len + 1];
        memcpy(data, other.data, len + 1);
    }
    
    // Copy assignment
    MyString& operator=(const MyString& other) {
        if (this != &other) {
            delete[] data;
            len = other.len;
            data = new char[len + 1];
            memcpy(data, other.data, len + 1);
        }
        return *this;
    }
    
    // Move constructor
    MyString(MyString&& other) noexcept : data(other.data), len(other.len) {
        other.data = nullptr;
        other.len = 0;
    }
    
    // Move assignment
    MyString& operator=(MyString&& other) noexcept {
        if (this != &other) {
            delete[] data;
            data = other.data;
            len = other.len;
            other.data = nullptr;
            other.len = 0;
        }
        return *this;
    }
    
    void print() const {
        std::cout << (data ? data : "(null)") << "\n";
    }
};

int main() {
    MyString s1("Hello");
    MyString s2 = s1;           // Copy constructor
    MyString s3 = std::move(s1); // Move constructor
    
    s2.print(); // Hello
    s3.print(); // Hello
    s1.print(); // (null)
    
    return 0;
}
```

---

## 90.2 Smart Pointers

| Type | Ownership | Use Case |
|---|---|---|
| `unique_ptr` | Single owner | Default choice |
| `shared_ptr` | Shared ownership | Reference counted |
| `weak_ptr` | Non-owning ref | Break cycles |

```cpp
#include <iostream>
#include <memory>

struct Node {
    int val;
    std::unique_ptr<Node> next;
    Node(int v) : val(v) {}
};

int main() {
    auto head = std::make_unique<Node>(1);
    head->next = std::make_unique<Node>(2);
    head->next->next = std::make_unique<Node>(3);
    
    for (auto* curr = head.get(); curr; curr = curr->next.get())
        std::cout << curr->val << " ";
    std::cout << "\n";
    
    // Automatic cleanup when head goes out of scope
    return 0;
}
```

---

## 90.3 Value Categories

| Category | Example | Can move from? |
|---|---|---|
| lvalue | `x`, `*p`, `arr[i]` | No (can bind to lvalue ref) |
| prvalue | `42`, `x + y`, `MyString("hi")` | Yes (temporary) |
| xvalue | `std::move(x)`, `f()` returning ref | Yes (expiring) |

---

## Summary

| Concept | Key Point |
|---|---|
| Rule of 5 | Define all or none of special members |
| RAII | Acquire in constructor, release in destructor |
| unique_ptr | Default smart pointer, zero overhead |
| move semantics | Transfer ownership, avoid copies |
