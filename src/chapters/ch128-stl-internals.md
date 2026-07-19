# Chapter 128: STL Internals

## Prerequisites
- C++ STL basics

## Interview Frequency: ★★★

Understanding STL internals helps write efficient code. **Google** and **Amazon** test this.

---

## 128.1 std::vector Internals

```cpp
#include <iostream>
#include <vector>

// Simplified vector implementation
template<typename T>
class SimpleVector {
    T* data_;
    size_t size_, capacity_;
    
public:
    SimpleVector() : data_(nullptr), size_(0), capacity_(0) {}
    
    ~SimpleVector() { delete[] data_; }
    
    void push_back(const T& val) {
        if (size_ == capacity_) {
            size_t newCap = capacity_ == 0 ? 1 : capacity_ * 2;
            T* newData = new T[newCap];
            for (size_t i = 0; i < size_; i++) newData[i] = data_[i];
            delete[] data_;
            data_ = newData;
            capacity_ = newCap;
        }
        data_[size_++] = val;
    }
    
    T& operator[](size_t i) { return data_[i]; }
    size_t size() const { return size_; }
    size_t capacity() const { return capacity_; }
};

int main() {
    SimpleVector<int> v;
    for (int i = 0; i < 10; i++) {
        v.push_back(i);
        std::cout << "size=" << v.size() << " cap=" << v.capacity() << "\n";
    }
    return 0;
}
```

---

## 128.2 Hash Map Internals

| Implementation | Collision | Load Factor | Cache |
|---|---|---|---|
| `std::unordered_map` | Chaining | 1.0 | Poor |
| `google::dense_hash_map` | Open addressing | 0.5 | Good |
| `robin_hood::unordered_map` | Robin Hood | 0.8 | Good |
| `absl::flat_hash_map` | Swiss table | 0.875 | Excellent |

---

## 128.3 Tree Internals

| Container | Implementation | Notes |
|---|---|---|
| `std::set` | Red-black tree | Self-balancing |
| `std::map` | Red-black tree | Ordered key-value |
| `std::priority_queue` | Binary heap | Max-heap by default |

---

## Summary

| Container | Underlying Structure | Key Operation |
|---|---|---|
| vector | Dynamic array | Amortized O(1) push_back |
| deque | Block array | O(1) push front/back |
| list | Doubly linked list | O(1) insert/erase |
| set/map | Red-black tree | O(log n) operations |
| unordered_* | Hash table | O(1) average |
