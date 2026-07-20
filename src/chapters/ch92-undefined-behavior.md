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

---

### Delta Debugging Implementation

```cpp
#include <iostream>
#include <vector>
#include <functional>
#include <string>

// Delta Debugging: Find minimal input that triggers a bug
// 'test' returns true if the bug occurs
std::vector<int> deltaDebug(std::vector<int> input, 
                             std::function<bool(const std::vector<int>&)> test) {
    int n = input.size();
    
    // Try removing each element
    for (int i = 0; i < n; i++) {
        std::vector<int> reduced;
        for (int j = 0; j < n; j++)
            if (j != i) reduced.push_back(input[j]);
        if (test(reduced)) {
            return deltaDebug(reduced, test); // Recurse on smaller input
        }
    }
    
    // Try splitting in half
    if (n > 2) {
        int mid = n / 2;
        std::vector<int> left(input.begin(), input.begin() + mid);
        std::vector<int> right(input.begin() + mid, input.end());
        
        if (test(left)) return deltaDebug(left, test);
        if (test(right)) return deltaDebug(right, test);
    }
    
    return input; // Can't reduce further
}

int main() {
    // Example: Find minimal input that causes a crash
    std::vector<int> input = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    
    // Simulated bug: crashes when input contains both 3 and 7
    auto testBug = [](const std::vector<int>& v) -> bool {
        bool has3 = false, has7 = false;
        for (int x : v) {
            if (x == 3) has3 = true;
            if (x == 7) has7 = true;
        }
        return has3 && has7;
    };
    
    auto minimal = deltaDebug(input, testBug);
    std::cout << "Minimal reproducing input: ";
    for (int x : minimal) std::cout << x << " ";
    std::cout << "\\n"; // Should be {3, 7} or similar
    
    return 0;
}
```

---

## Interview Questions

### Q1: What is undefined behavior? Give three examples.
**Answer**: Undefined behavior (UB) is code whose behavior is not defined by the C++ standard — the compiler can do anything. Examples: signed integer overflow (`INT_MAX + 1`), null pointer dereference (`*nullptr`), use-after-free (`delete p; *p = 1`), and out-of-bounds array access.

### Q2: Why is signed integer overflow UB but unsigned overflow is well-defined?
**Answer**: The C++ standard defines unsigned arithmetic as modular (wraps at 2^n). Signed overflow was left undefined to allow compilers to optimize without worrying about wraparound — for example, assuming `x + 1 > x` is always true for signed `x`.

### Q3: How do you safely erase elements from a vector while iterating?
**Answer**: Use the erase-remove idiom: `v.erase(std::remove_if(v.begin(), v.end(), pred), v.end())`. Erasing during a range-based for loop invalidates iterators and is UB. Alternatively, use the iterator-returning erase in a while loop, capturing the returned iterator.

### Q4: What's the difference between UB and implementation-defined behavior?
**Answer**: UB has no guarantees — anything can happen. Implementation-defined behavior is unspecified by the standard but must be documented by the compiler (e.g., `sizeof(int)` is typically 4 but the compiler defines it). Both vary across compilers, but only UB can cause the optimizer to generate surprising code.

### Q5: How can sanitizers help detect UB?
**Answer**: Compilers offer sanitizers like `-fsanitize=undefined` (UBSan) and `-fsanitize=address` (ASan) that insert runtime checks. UBSan catches signed overflow, null derefs, misaligned access, etc. ASan catches use-after-free, buffer overflows, and memory leaks. They turn silent UB into loud crashes with stack traces.

---

## Exercises

1. **Signed vs. Unsigned**: Write a function `safeAdd(int a, int b, int& result)` that returns `false` if the addition would overflow. Test it with edge cases like `INT_MAX + 1` and `-1 + INT_MIN`.

2. **Iterator Invalidation Bug**: The following code has a bug. Find and fix it:
   ```cpp
   std::vector<int> v = {1, 2, 3, 4, 5, 6};
   for (auto it = v.begin(); it != v.end(); ++it)
       if (*it % 2 == 0) v.erase(it);
   ```

3. **Sanitizer Practice**: Compile the following with `-fsanitize=undefined` and explain what the sanitizer reports:
   ```cpp
   int x = 2147483647;
   int y = x + 1;
   ```

4. **Defensive Coding**: Add assertions to this function to catch UB at runtime:
   ```cpp
   int& get(std::vector<int>& v, int i) {
       return v[i];
   }
   ```

5. **Type Punning**: Explain why `reinterpret_cast` between unrelated types is UB, and describe the safe alternative using `memcpy`.

---

## See Also

- [Chapter 127: Move Semantics](ch127-move-semantics.md) — Move semantics interact with object lifetimes; moving from an object and then using it is a form of use-after-move (not UB per se, but the object is in a valid-but-unspecified state).
- [Chapter 94: Hashing Deep Dive](ch94-hashing-deep-dive.md) — Hash function implementations must avoid UB (signed overflow, type punning).
- [Chapter 126: RAII and Smart Pointers](ch126-raii-smart-pointers.md) — RAII prevents use-after-free and double-free, two common sources of UB.
- [Chapter 91: Debugging Techniques](ch91-debugging.md) — Sanitizers (UBSan, ASan) and tools like Valgrind detect UB at runtime.
- [Chapter 129: Compiler Optimizations](ch129-compiler-optimizations.md) — Compilers exploit UB to optimize aggressively; understanding this helps predict surprising behavior.
- [Chapter 124: Branch Prediction](ch124-branch-prediction.md) — UB can affect branch prediction behavior due to compiler assumptions about undefined cases.
