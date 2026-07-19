# Chapter 137: Profiling Tools Reference

## Prerequisites
- Command line basics

## Interview Frequency: ★★

Know your tools for performance analysis.

---

## 137.1 Time Measurement

```cpp
#include <iostream>
#include <chrono>

template<typename Func>
double benchmark(Func f, int iterations = 100) {
    auto start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; i++) f();
    auto end = std::chrono::high_resolution_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(end - start).count() 
           / 1000.0 / iterations;
}

int main() {
    double ms = benchmark([]() {
        volatile int sum = 0;
        for (int i = 0; i < 1000000; i++) sum += i;
    }, 10);
    
    std::cout << "Average time: " << ms << "ms\n";
    return 0;
}
```

---

## 137.2 Tool Reference

| Tool | Platform | What It Measures |
|---|---|---|
| `chrono` | Cross-platform | Wall time |
| `perf` | Linux | CPU cycles, cache misses, branch mispredicts |
| `gprof` | Linux | Function call profiling |
| `valgrind --tool=callgrind` | Linux/Mac | Call graph profiling |
| `valgrind --tool=memcheck` | Linux/Mac | Memory leaks |
| `AddressSanitizer` | GCC/Clang | Memory errors |
| `UndefinedBehaviorSanitizer` | GCC/Clang | UB detection |
| `ThreadSanitizer` | GCC/Clang | Data races |
| `Instruments` | Mac | CPU, memory, energy |
| `Visual Studio Profiler` | Windows | CPU, memory |

---

## 137.3 Sanitizer Compilation

```bash
# AddressSanitizer
g++ -fsanitize=address -g program.cpp -o program

# UndefinedBehaviorSanitizer
g++ -fsanitize=undefined -g program.cpp -o program

# ThreadSanitizer
g++ -fsanitize=thread -g program.cpp -o program

# MemorySanitizer
g++ -fsanitize=memory -g program.cpp -o program
```

---

## Summary

| Need | Tool |
|---|---|
| Measure time | chrono, perf |
| Find memory bugs | ASan, Valgrind |
| Find UB | UBSan |
| Find race conditions | TSan |
| Profile CPU | perf, gprof, Instruments |
