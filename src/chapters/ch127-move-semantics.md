# Chapter 127: Move Semantics Deep Dive

## Prerequisites
- C++ basics, RAII, smart pointers

## Interview Frequency: ★★★★

Move semantics enable efficient resource transfer. **Google**, **Meta**, **Amazon** test this.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| std::move | ★★★★ | Medium | Cast to rvalue ref |
| Rvalue references | ★★★ | Medium | T&& |
| Perfect forwarding | ★★ | Hard | std::forward |
| Move constructors | ★★★★ | Medium | Rule of 5 |

---

## 127.1 Rvalue References

An rvalue reference `T&&` binds to temporary objects (rvalues). This enables "stealing" resources from temporaries.

```cpp
#include <iostream>
#include <cstring>
#include <utility>
#include <vector>

class MyString {
    char* data;
    size_t len;
    
public:
    // Constructor
    MyString(const char* s = "") : len(strlen(s)) {
        data = new char[len + 1];
        memcpy(data, s, len + 1);
        std::cout << "Constructed: \"" << data << "\"\n";
    }
    
    // Destructor
    ~MyString() {
        std::cout << "Destroyed: \"" << (data ? data : "null") << "\"\n";
        delete[] data;
    }
    
    // Copy constructor (deep copy)
    MyString(const MyString& other) : len(other.len) {
        data = new char[len + 1];
        memcpy(data, other.data, len + 1);
        std::cout << "Copied: \"" << data << "\"\n";
    }
    
    // Move constructor (steal resources)
    MyString(MyString&& other) noexcept : data(other.data), len(other.len) {
        other.data = nullptr;
        other.len = 0;
        std::cout << "Moved: \"" << data << "\"\n";
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
        std::cout << "\"" << (data ? data : "") << "\" (len=" << len << ")\n";
    }
};

int main() {
    MyString s1("Hello");
    MyString s2 = s1;              // Copy
    MyString s3 = std::move(s1);   // Move
    MyString s4 = MyString("World"); // Move (temporary)
    
    s1.print(); // Empty (moved from)
    s2.print(); // Hello
    s3.print(); // Hello
    s4.print(); // World
    
    // Move in vector operations
    std::vector<MyString> vec;
    vec.push_back(MyString("A")); // Move
    vec.push_back(MyString("B")); // Move (if no reallocation)
    
    return 0;
}
```

---

## 127.2 When Move Happens

| Expression | Type | Move? |
|---|---|---|
| `MyString s("hi")` | Named variable | No |
| `MyString s = MyString("hi")` | Temporary | Yes |
| `MyString s = std::move(other)` | Explicit move | Yes |
| `vec.push_back(s)` | Named variable | Copy |
| `vec.push_back(std::move(s))` | Explicit move | Yes |

---

## 127.3 Perfect Forwarding

`std::forward<T>(arg)` preserves the value category (lvalue/rvalue) of the argument.

```cpp
#include <iostream>
#include <utility>

template<typename T>
void wrapper(T&& arg) {
    // Forward preserves lvalue/rvalue nature
    std::cout << "Forwarded: ";
    // In real code: target(std::forward<T>(arg));
    std::cout << arg << "\n";
}

int main() {
    int x = 42;
    wrapper(x);           // T = int&, arg is lvalue
    wrapper(42);          // T = int, arg is rvalue
    wrapper(std::move(x)); // T = int, arg is rvalue
    return 0;
}
```

---

## 127.4 Move and Containers

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <chrono>

int main() {
    const int N = 1000000;
    
    // Copy vs Move benchmark
    auto start = std::chrono::high_resolution_clock::now();
    std::vector<std::string> vec1;
    for (int i = 0; i < N; i++) {
        std::string s = "hello world this is a test string";
        vec1.push_back(s); // Copy
    }
    auto end = std::chrono::high_resolution_clock::now();
    auto copyTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    
    start = std::chrono::high_resolution_clock::now();
    std::vector<std::string> vec2;
    for (int i = 0; i < N; i++) {
        std::string s = "hello world this is a test string";
        vec2.push_back(std::move(s)); // Move
    }
    end = std::chrono::high_resolution_clock::now();
    auto moveTime = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    
    std::cout << "Copy: " << copyTime.count() << "ms\n";
    std::cout << "Move: " << moveTime.count() << "ms\n";
    
    return 0;
}
```

---

## Summary

| Concept | Purpose | When to Use |
|---|---|---|
| `T&&` (rvalue ref) | Bind to temporaries | Move constructor/assignment |
| `std::move` | Cast to rvalue | When you won't use variable again |
| `std::forward` | Preserve value category | Perfect forwarding in templates |
| Move constructor | Steal resources | Rule of 5 |
| `noexcept` | Enable container optimization | All move operations |

---

## 127.5 Rule of Zero

If your class doesn't manage resources directly, don't define any special member functions. Let the compiler generate them.

```cpp
#include <iostream>
#include <string>
#include <vector>

// BAD: Unnecessary destructor
class Bad {
    std::string name;
    std::vector<int> data;
public:
    ~Bad() {} // Unnecessary! Compiler would do the same
};

// GOOD: Rule of Zero
class Good {
    std::string name;
    std::vector<int> data;
    // No destructor, copy/move constructors needed!
    // Compiler generates correct ones.
};

int main() {
    Good g1;
    Good g2 = g1; // Compiler-generated copy works fine
    Good g3 = std::move(g1); // Compiler-generated move works fine
    std::cout << "Rule of Zero: let the compiler handle it!\n";
    return 0;
}
```

---

## 127.6 Memory Alignment

Data should be aligned to its size for optimal access. Misaligned access can cause crashes or performance penalties.

```cpp
#include <iostream>
#include <cstddef>

struct BadLayout {
    char a;     // 1 byte + 7 padding
    double b;   // 8 bytes
    char c;     // 1 byte + 7 padding
}; // sizeof = 24 bytes

struct GoodLayout {
    double b;   // 8 bytes
    char a;     // 1 byte
    char c;     // 1 byte + 6 padding
}; // sizeof = 16 bytes

int main() {
    std::cout << "BadLayout size: " << sizeof(BadLayout) << "\n";  // 24
    std::cout << "GoodLayout size: " << sizeof(GoodLayout) << "\n"; // 16
    
    // alignof
    std::cout << "alignof(double): " << alignof(double) << "\n"; // 8
    std::cout << "alignof(int): " << alignof(int) << "\n";       // 4
    
    return 0;
}
```

---

## 127.7 Placement New

Construct an object at a pre-allocated memory location. Used in custom allocators and container implementations.

```cpp
#include <iostream>
#include <new> // for placement new
#include <memory>

int main() {
    // Pre-allocate memory
    alignas(int) char buffer[sizeof(int) * 5];
    
    // Construct ints in the buffer
    int* arr = reinterpret_cast<int*>(buffer);
    for (int i = 0; i < 5; i++) {
        new (&arr[i]) int(i * 10); // Placement new
    }
    
    for (int i = 0; i < 5; i++)
        std::cout << arr[i] << " ";
    std::cout << "\n";
    
    // Destruct (for non-trivial types, call destructor manually)
    // For int, nothing needed
    
    return 0;
}
```
