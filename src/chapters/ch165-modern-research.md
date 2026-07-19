# Chapter 165: Modern Research Topics

## Prerequisites
- Advanced algorithms, complexity theory

## Interview Frequency: ★

---

## 165.1 Fine-Grained Complexity

Conditional lower bounds based on conjectures like SETH (Strong Exponential Time Hypothesis).

**SETH**: No O((2-ε)^n) algorithm for CNF-SAT.

**Implications**: Many problems have tight conditional lower bounds:
- Edit Distance: O(n²) is optimal (under SETH)
- Longest Common Subsequence: O(n²) is optimal
- Diameter: O(n²) is optimal for sparse graphs

---

## 165.2 Property Testing

Determine if object has property P or is ε-far from P, using poly(1/ε) queries (independent of n).

```cpp
#include <iostream>
#include <vector>
#include <random>
#include <cmath>

// Property testing: Is array sorted?
// If sorted: always accept
// If ε-far from sorted: reject with high probability

bool isSortedPropertyTest(const std::vector<int>& arr, double epsilon, int trials = 100) {
    int n = arr.size();
    std::mt19937 rng(42);
    std::uniform_int_distribution<int> dist(0, n - 2);
    
    for (int t = 0; t < trials; t++) {
        int i = dist(rng);
        if (arr[i] > arr[i + 1]) return false; // Found inversion
    }
    return true; // Probably sorted
}

int main() {
    std::vector<int> sorted = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    std::vector<int> unsorted = {1, 2, 3, 4, 5, 6, 7, 8, 10, 9};
    
    std::cout << "Sorted array: " << isSortedPropertyTest(sorted, 0.1) << "\n";
    std::cout << "Unsorted array: " << isSortedPropertyTest(unsorted, 0.1) << "\n";
    
    return 0;
}
```

---

## 165.3 Sublinear Algorithms

Algorithms using o(n) time or space.

| Problem | Sublinear Algorithm | Time |
|---|---|---|
| Count connected components | Random sampling | O(n polylog n) |
| Estimate average degree | Sample edges | O(1) |
| Test bipartiteness | Random walks | O(√n) |

---

## 165.4 Quantum Algorithms

| Algorithm | Problem | Speedup |
|---|---|---|
| Grover's | Unstructured search | O(√n) vs O(n) |
| Shor's | Integer factoring | Polynomial vs exponential |
| Quantum Walk | Graph problems | Various |
| HHL | Linear systems | Exponential (with caveats) |

---

## 165.5 Differential Privacy

Add calibrated noise to protect individual data while preserving statistical properties.

**Key concept**: ε-differential privacy. Changing one individual's data changes output probability by at most e^ε.

---

## 165.6 Communication Complexity

Minimum bits exchanged between parties to compute a function. Used in distributed computing, streaming lower bounds.

---

## Summary

| Area | Key Idea | Impact |
|---|---|---|
| Fine-Grained | Conditional lower bounds | Tight complexity |
| Property Testing | Few queries, approximate | Sublinear algorithms |
| Sublinear | o(n) time algorithms | Big data |
| Quantum | Quantum speedup | Future computing |
| Differential Privacy | Noise for privacy | Data protection |
