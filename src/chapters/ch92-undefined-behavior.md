# Chapter 92: Undefined Behavior in C++

## Prerequisites

- C++ basics

## Interview Frequency: ★★★

Understanding UB is critical for writing correct C++. **Google** and **Meta** test this knowledge.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Integer overflow | ★★★★ | Easy | Signed overflow is UB |
| Null dereference | ★★★ | Easy | Crash or worse |
| Iterator invalidation | ★★★ | Medium | Modifying during iteration |
| Use after free | ★★★ | Medium | Dangling pointers |

---

## 92.1 Common Undefined Behaviors

| UB | Example | Consequence |
|---|---|---|
| Signed integer overflow | `int x = INT_MAX + 1` | Unpredictable |
| Null pointer dereference | `*nullptr` | Crash |
| Array out of bounds | `arr[n+1]` | Unpredictable |
| Use after free | `delete p; *p = 1` | Unpredictable |
| Double free | `delete p; delete p` | Crash |
| Shift by negative | `1 << -1` | Unpredictable |
| Signed division by zero | `1 / 0` | Crash |

```cpp
#include <iostream>
#include <climits>

int main() {
    // Signed overflow is UB (don't rely on wraparound)
    int x = INT_MAX;
    // x + 1 is undefined! Use unsigned or check first.
    
    // Safe approach:
    if (x < INT_MAX) {
        x = x + 1; // Safe
    }
    
    std::cout << "x = " << x << "\n";
    
    // Unsigned overflow is well-defined (wraps around)
    unsigned int y = UINT_MAX;
    y++; // Well-defined: wraps to 0
    std::cout << "y = " << y << "\n";
    
    return 0;
}
```

---

## 92.2 Iterator Invalidation

```cpp
#include <iostream>
#include <vector>

int main() {
    std::vector<int> v = {1, 2, 3, 4, 5};
    
    // WRONG: Erasing during range-based for
    // for (int x : v) if (x % 2 == 0) v.erase(...); // UB!
    
    // CORRECT: Erase-remove idiom
    v.erase(std::remove_if(v.begin(), v.end(), 
            [](int x) { return x % 2 == 0; }), v.end());
    
    for (int x : v) std::cout << x << " ";
    std::cout << "\n";
    
    return 0;
}
```

---

## Summary

| Category | Examples | Prevention |
|---|---|---|
| Arithmetic | Overflow, div by zero | Check bounds, use unsigned |
| Memory | Use-after-free, null deref | Smart pointers, RAII |
| Iterators | Invalidation | Erase-remove idiom |
| Type punning | Reinterpret cast | Use memcpy |

---

## 92.3 Defensive Programming

Write code that fails fast and clearly when assumptions are violated.

```cpp
#include <iostream>
#include <cassert>
#include <stdexcept>

// Use assertions for internal invariants
int binarySearch(const int* arr, int n, int target) {
    assert(arr != nullptr && "Array must not be null");
    assert(n >= 0 && "Size must be non-negative");
    
    int lo = 0, hi = n - 1;
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) lo = mid + 1;
        else hi = mid - 1;
    }
    return -1;
}

// Use exceptions for external errors
int parseInt(const std::string& s) {
    try {
        return std::stoi(s);
    } catch (...) {
        throw std::invalid_argument("Invalid integer: " + s);
    }
}

int main() {
    int arr[] = {1, 3, 5, 7, 9};
    std::cout << "Found 5 at: " << binarySearch(arr, 5, 5) << "\n";
    std::cout << "Parsed: " << parseInt("42") << "\n";
    return 0;
}
```

---

## 92.4 Delta Debugging (Overview)

Systematically isolate the minimal input that causes a bug:
1. Split input into two halves
2. Test each half
3. If one half fails, recurse on that half
4. If both fail, try smaller splits
5. Continue until minimal reproducing case found
