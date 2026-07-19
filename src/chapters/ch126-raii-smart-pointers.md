# Chapter 126: RAII and Smart Pointers

## Prerequisites
- C++ basics, OOP

## Interview Frequency: ★★★★

RAII is fundamental C++ idiom. **Google**, **Meta**, **Amazon** test this.

---

## 126.1 RAII (Resource Acquisition Is Initialization)

Acquire resources in constructor, release in destructor. Automatic cleanup via scope.

```cpp
#include <iostream>
#include <fstream>
#include <mutex>

class FileHandler {
    std::ofstream file;
public:
    FileHandler(const std::string& name) : file(name) {
        if (!file.is_open()) throw std::runtime_error("Cannot open file");
    }
    // Destructor automatically closes file
    ~FileHandler() { if (file.is_open()) file.close(); }
    
    void write(const std::string& data) { file << data; }
    
    // Non-copyable
    FileHandler(const FileHandler&) = delete;
    FileHandler& operator=(const FileHandler&) = delete;
};

class LockGuard {
    std::mutex& mtx;
public:
    LockGuard(std::mutex& m) : mtx(m) { mtx.lock(); }
    ~LockGuard() { mtx.unlock(); }
    LockGuard(const LockGuard&) = delete;
    LockGuard& operator=(const LockGuard&) = delete;
};

int main() {
    // File automatically closed when fh goes out of scope
    {
        FileHandler fh("/tmp/test.txt");
        fh.write("Hello, RAII!\n");
    } // File closed here
    
    std::cout << "RAII ensures cleanup even if exceptions occur.\n";
    return 0;
}
```

---

## 126.2 Smart Pointers

| Type | Ownership | Use Case |
|---|---|---|
| `unique_ptr` | Single owner | Default choice |
| `shared_ptr` | Shared (ref counted) | Shared ownership |
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
    
    // shared_ptr example
    auto shared = std::make_shared<int>(42);
    auto shared2 = shared; // Reference count = 2
    std::cout << "Use count: " << shared.use_count() << "\n";
    
    return 0;
}
```

---

## Summary

| Idiom | Purpose |
|---|---|
| RAII | Automatic resource management |
| unique_ptr | Exclusive ownership, zero overhead |
| shared_ptr | Shared ownership, ref counted |
| weak_ptr | Non-owning observer, breaks cycles |
