# Chapter 5: Sorting

Sorting is one of the most studied problems in computer science. Nearly every algorithm course starts with sorting, and for good reason: sorting is a building block for countless other algorithms, and the techniques used in sorting (divide and conquer, incremental construction, heap operations) appear everywhere in interviews.

---

## 5.1 Why Sorting Matters

Sorting enables efficient solutions to many problems:

| Problem | Without Sorting | With Sorting |
|---|---|---|
| Find duplicates | O(n²) nested loops | O(n log n) sort + O(n) scan |
| Find pair with sum K | O(n²) or O(n) with hash | O(n log n) sort + O(n) two pointers |
| Find median | O(n) quickselect | O(n log n) sort + O(1) access |
| Interval scheduling | Exponential | O(n log n) sort + O(n) greedy |

Many interview problems have a hidden sorting step that transforms a hard problem into an easy one.

---

## 5.2 Bubble Sort

### Concept

Repeatedly step through the array, compare adjacent elements, and swap them if they're in the wrong order. After each pass, the largest unsorted element "bubbles up" to its correct position.

### Visualization

```
Initial:  [5, 3, 8, 1, 2]

Pass 1:
  Compare 5,3 → swap → [3, 5, 8, 1, 2]
  Compare 5,8 → ok   → [3, 5, 8, 1, 2]
  Compare 8,1 → swap → [3, 5, 1, 8, 2]
  Compare 8,2 → swap → [3, 5, 1, 2, 8]  ← 8 is in place

Pass 2:
  Compare 3,5 → ok   → [3, 5, 1, 2, 8]
  Compare 5,1 → swap → [3, 1, 5, 2, 8]
  Compare 5,2 → swap → [3, 1, 2, 5, 8]  ← 5 is in place

Pass 3:
  Compare 3,1 → swap → [1, 3, 2, 5, 8]
  Compare 3,2 → swap → [1, 2, 3, 5, 8]  ← 3 is in place

Pass 4:
  Compare 1,2 → ok   → [1, 2, 3, 5, 8]  ← No swaps → DONE
```

### Code

```cpp
#include <iostream>
#include <vector>

// Optimized Bubble Sort with early termination
// Time: Best O(n), Average O(n²), Worst O(n²)
// Space: O(1)
// Stable: Yes
void bubbleSort(std::vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        bool swapped = false;
        for (int j = 0; j < n - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                std::swap(arr[j], arr[j + 1]);
                swapped = true;
            }
        }
        // If no swaps in this pass, array is sorted
        if (!swapped) break;
    }
}

int main() {
    std::vector<int> arr = {64, 34, 25, 12, 22, 11, 90};
    bubbleSort(arr);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 11 12 22 25 34 64 90
    return 0;
}
```

### Complexity

| Case | Time | When? |
|---|---|---|
| Best | O(n) | Already sorted (with optimization) |
| Average | O(n²) | Random order |
| Worst | O(n²) | Reverse sorted |

**Space:** O(1) — in-place.
**Stable:** Yes — equal elements maintain relative order.

### When to Use

Almost never in practice. It's mainly used for educational purposes. Insertion sort is always preferred for small or nearly sorted arrays.

---

## 5.3 Selection Sort

### Concept

Find the minimum element in the unsorted portion and swap it with the first unsorted element.

### Visualization

```
Initial:  [64, 25, 12, 22, 11]

Pass 1: Find min in [64, 25, 12, 22, 11] → 11, swap with 64
         [11, 25, 12, 22, 64]
          ✓

Pass 2: Find min in [25, 12, 22, 64] → 12, swap with 25
         [11, 12, 25, 22, 64]
          ✓   ✓

Pass 3: Find min in [25, 22, 64] → 22, swap with 25
         [11, 12, 22, 25, 64]
          ✓   ✓   ✓

Pass 4: Find min in [25, 64] → 25, no swap needed
         [11, 12, 22, 25, 64]
          ✓   ✓   ✓   ✓   ✓  DONE
```

### Code

```cpp
#include <iostream>
#include <vector>

// Selection Sort
// Time: O(n²) always (best, average, worst)
// Space: O(1)
// Stable: No (can be made stable with linked lists)
void selectionSort(std::vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[minIdx]) {
                minIdx = j;
            }
        }
        if (minIdx != i) {
            std::swap(arr[i], arr[minIdx]);
        }
    }
}

int main() {
    std::vector<int> arr = {64, 25, 12, 22, 11};
    selectionSort(arr);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 11 12 22 25 64
    return 0;
}
```

### Complexity

| Case | Time |
|---|---|
| Best | O(n²) |
| Average | O(n²) |
| Worst | O(n²) |

**Always** O(n²) because we always scan the entire unsorted portion.
**Space:** O(1) — in-place.
**Stable:** No. Example: [5a, 5b, 3] → after first pass: [3, 5b, 5a] — relative order of 5a and 5b changed.

**Minimum swaps:** O(n) — at most n-1 swaps. This is a theoretical advantage when swaps are expensive.

---

## 5.4 Insertion Sort

### Concept

Build the sorted array one element at a time. For each new element, insert it into its correct position in the already-sorted portion.

### Visualization

```
Initial:  [5, 3, 8, 1, 2]

i=1: Insert 3 into [5]       → [3, 5, 8, 1, 2]
i=2: Insert 8 into [3, 5]    → [3, 5, 8, 1, 2]  (8 already in place)
i=3: Insert 1 into [3, 5, 8] → [1, 3, 5, 8, 2]
i=4: Insert 2 into [1, 3, 5, 8] → [1, 2, 3, 5, 8]
```

### Code

```cpp
#include <iostream>
#include <vector>

// Insertion Sort
// Time: Best O(n), Average O(n²), Worst O(n²)
// Space: O(1)
// Stable: Yes
void insertionSort(std::vector<int>& arr) {
    int n = arr.size();
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;

        // Shift elements greater than key to the right
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
}

int main() {
    std::vector<int> arr = {12, 11, 13, 5, 6};
    insertionSort(arr);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 5 6 11 12 13
    return 0;
}
```

### Why Insertion Sort Is Good

1. **Nearly sorted arrays:** O(n) — each element moves only a few positions.
2. **Small arrays:** Low overhead, fast in practice for n < 20-50.
3. **Online algorithm:** Can sort elements as they arrive.
4. **Stable:** Preserves relative order of equal elements.
5. **Adaptive:** Fewer comparisons when data is partially sorted.

**Real-world use:** Many hybrid sorting algorithms (like `std::sort` in C++) switch to insertion sort for small subarrays (typically n ≤ 16-32).

---

## 5.5 Merge Sort

### Concept

**Divide and Conquer:**
1. **Divide** the array into two halves.
2. **Recursively** sort each half.
3. **Merge** the two sorted halves.

### Visualization

```
              [38, 27, 43, 3, 9, 82, 10]
                /                    \
        [38, 27, 43, 3]        [9, 82, 10]
          /          \            /       \
      [38, 27]    [43, 3]    [9, 82]    [10]
       /    \      /    \     /    \       |
     [38]  [27]  [43]  [3]  [9]  [82]   [10]
       \    /      \    /     \    /       |
      [27, 38]    [3, 43]    [9, 82]    [10]
          \          /            \       /
        [3, 27, 38, 43]        [9, 10, 82]
                \                    /
           [3, 9, 10, 27, 38, 43, 82]
```

### Code

```cpp
#include <iostream>
#include <vector>

// Merge two sorted subarrays arr[lo..mid] and arr[mid+1..hi]
void merge(std::vector<int>& arr, int lo, int mid, int hi) {
    std::vector<int> temp;
    int i = lo, j = mid + 1;

    while (i <= mid && j <= hi) {
        if (arr[i] <= arr[j]) {
            temp.push_back(arr[i++]);
        } else {
            temp.push_back(arr[j++]);
        }
    }

    while (i <= mid) temp.push_back(arr[i++]);
    while (j <= hi) temp.push_back(arr[j++]);

    // Copy back
    for (int k = 0; k < (int)temp.size(); k++) {
        arr[lo + k] = temp[k];
    }
}

// Merge Sort
// Time: O(n log n) always
// Space: O(n)
// Stable: Yes
void mergeSort(std::vector<int>& arr, int lo, int hi) {
    if (lo >= hi) return;

    int mid = lo + (hi - lo) / 2;
    mergeSort(arr, lo, mid);
    mergeSort(arr, mid + 1, hi);
    merge(arr, lo, mid, hi);
}

int main() {
    std::vector<int> arr = {38, 27, 43, 3, 9, 82, 10};
    mergeSort(arr, 0, arr.size() - 1);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 3 9 10 27 38 43 82
    return 0;
}
```

### Complexity

| Case | Time |
|---|---|
| Best | O(n log n) |
| Average | O(n log n) |
| Worst | O(n log n) |

**Always** O(n log n) — the recurrence is T(n) = 2T(n/2) + O(n).
**Space:** O(n) — temporary arrays for merging.
**Stable:** Yes — during merge, we pick from the left subarray first when elements are equal.

### When to Use

- When stability is required.
- When guaranteed O(n log n) is needed.
- For linked lists (merge sort on linked lists uses O(1) extra space).
- For external sorting (data too large for memory).

---

## 5.6 Quick Sort

### Concept

**Divide and Conquer:**
1. **Pick a pivot** element.
2. **Partition:** Rearrange so elements < pivot are on the left, elements > pivot are on the right.
3. **Recursively** sort left and right partitions.

### Lomuto Partition Scheme

```cpp
#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>

// Lomuto partition: pivot is last element
int partition(std::vector<int>& arr, int lo, int hi) {
    int pivot = arr[hi];
    int i = lo;  // Boundary for elements <= pivot

    for (int j = lo; j < hi; j++) {
        if (arr[j] <= pivot) {
            std::swap(arr[i], arr[j]);
            i++;
        }
    }
    std::swap(arr[i], arr[hi]);  // Place pivot in correct position
    return i;
}

// Quick Sort with randomized pivot
// Time: Best O(n log n), Average O(n log n), Worst O(n²)
// Space: O(log n) average (recursion stack)
// Stable: No
void quickSort(std::vector<int>& arr, int lo, int hi) {
    if (lo >= hi) return;

    // Randomize pivot to avoid worst case
    int pivotIdx = lo + rand() % (hi - lo + 1);
    std::swap(arr[pivotIdx], arr[hi]);

    int p = partition(arr, lo, hi);
    quickSort(arr, lo, p - 1);
    quickSort(arr, p + 1, hi);
}

int main() {
    srand(time(nullptr));
    std::vector<int> arr = {10, 7, 8, 9, 1, 5};
    quickSort(arr, 0, arr.size() - 1);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 1 5 7 8 9 10
    return 0;
}
```

### Hoare Partition Scheme

```cpp
#include <iostream>
#include <vector>

// Hoare partition: more efficient, fewer swaps
int hoarePartition(std::vector<int>& arr, int lo, int hi) {
    int pivot = arr[lo + (hi - lo) / 2];
    int i = lo - 1, j = hi + 1;

    while (true) {
        do { i++; } while (arr[i] < pivot);
        do { j--; } while (arr[j] > pivot);
        if (i >= j) return j;
        std::swap(arr[i], arr[j]);
    }
}

void quickSortHoare(std::vector<int>& arr, int lo, int hi) {
    if (lo >= hi) return;
    int p = hoarePartition(arr, lo, hi);
    quickSortHoare(arr, lo, p);
    quickSortHoare(arr, p + 1, hi);
}

int main() {
    std::vector<int> arr = {10, 7, 8, 9, 1, 5};
    quickSortHoare(arr, 0, arr.size() - 1);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    return 0;
}
```

### Pivot Selection Strategies

| Strategy | How | Worst Case |
|---|---|---|
| First element | `arr[lo]` | Sorted array → O(n²) |
| Last element | `arr[hi]` | Sorted array → O(n²) |
| Random element | `arr[random(lo,hi)]` | Extremely unlikely O(n²) |
| Median of three | median of first, middle, last | Very unlikely O(n²) |

### Complexity

| Case | Time | When? |
|---|---|---|
| Best | O(n log n) | Balanced partitions |
| Average | O(n log n) | Random data |
| Worst | O(n²) | Already sorted (with bad pivot) |

**Space:** O(log n) average (recursion stack), O(n) worst case.
**Stable:** No — partitioning can change relative order of equal elements.

### Why Quick Sort Is Often Preferred

Despite O(n²) worst case:
1. **Small constant factors** — fewer comparisons and swaps than merge sort.
2. **Cache-friendly** — operates on contiguous memory.
3. **In-place** — O(log n) auxiliary space vs O(n) for merge sort.
4. **Randomized version** has O(n²) probability that's astronomically low.

---

## 5.7 Heap Sort

### Concept

1. Build a max-heap from the array.
2. Repeatedly extract the maximum (swap root with last unsorted element, reduce heap size, heapify).

### Code

```cpp
#include <iostream>
#include <vector>

// Heapify subtree rooted at index i
void heapify(std::vector<int>& arr, int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    if (left < n && arr[left] > arr[largest]) {
        largest = left;
    }
    if (right < n && arr[right] > arr[largest]) {
        largest = right;
    }

    if (largest != i) {
        std::swap(arr[i], arr[largest]);
        heapify(arr, n, largest);
    }
}

// Heap Sort
// Time: O(n log n) always
// Space: O(1)
// Stable: No
void heapSort(std::vector<int>& arr) {
    int n = arr.size();

    // Build max heap: O(n) — start from last non-leaf node
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(arr, n, i);
    }

    // Extract elements one by one
    for (int i = n - 1; i > 0; i--) {
        std::swap(arr[0], arr[i]);  // Move max to end
        heapify(arr, i, 0);          // Heapify reduced heap
    }
}

int main() {
    std::vector<int> arr = {12, 11, 13, 5, 6, 7};
    heapSort(arr);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 5 6 7 11 12 13
    return 0;
}
```

### Dry Run

```
Initial:  [12, 11, 13, 5, 6, 7]

Build max-heap:
  Start from index 2 (value 13): no swap needed
  Index 1 (value 11): children 5, 6. No swap needed.
  Index 0 (value 12): children 11, 13. Swap with 13.
  → [13, 11, 12, 5, 6, 7]

  After heapify at index 2: 12 has child 7. No swap.
  Final heap: [13, 11, 12, 5, 6, 7]

Extract max (13), swap with last:
  [7, 11, 12, 5, 6, | 13]
  Heapify: swap 7 and 12 → [12, 11, 7, 5, 6, | 13]
  Heapify: swap 7 and 6? No, 7 > 6. Done.
  → [12, 11, 7, 5, 6, 13]

Extract max (12), swap with 6:
  [6, 11, 7, 5, | 12, 13]
  Heapify: swap 6 and 11 → [11, 6, 7, 5, | 12, 13]
  Heapify: swap 6 and 5? No, 6 > 5. Done.
  → [11, 6, 7, 5, 12, 13]

... continues until sorted: [5, 6, 7, 11, 12, 13]
```

### Complexity

| Case | Time |
|---|---|
| Best | O(n log n) |
| Average | O(n log n) |
| Worst | O(n log n) |

**Space:** O(1) — fully in-place.
**Stable:** No.

**Advantage:** Guaranteed O(n log n) with O(1) space — the best of both worlds (guaranteed like merge sort, in-place like quick sort).

**Disadvantage:** Poor cache performance — parent and child nodes can be far apart in memory.

---

## 5.8 Counting Sort

### Concept

A **non-comparison** sort. Count the occurrences of each value, then reconstruct the sorted array.

**Constraint:** Works only for integers in a known range [0, k].

### Code

```cpp
#include <iostream>
#include <vector>

// Counting Sort
// Time: O(n + k) where k is the range of values
// Space: O(n + k)
// Stable: Yes (with prefix sums)
void countingSort(std::vector<int>& arr) {
    if (arr.empty()) return;

    int maxVal = *std::max_element(arr.begin(), arr.end());
    int minVal = *std::min_element(arr.begin(), arr.end());
    int range = maxVal - minVal + 1;

    std::vector<int> count(range, 0);
    std::vector<int> output(arr.size());

    // Count occurrences
    for (int x : arr) {
        count[x - minVal]++;
    }

    // Compute prefix sums (for stable sort)
    for (int i = 1; i < range; i++) {
        count[i] += count[i - 1];
    }

    // Build output array (traverse in reverse for stability)
    for (int i = arr.size() - 1; i >= 0; i--) {
        output[count[arr[i] - minVal] - 1] = arr[i];
        count[arr[i] - minVal]--;
    }

    arr = output;
}

int main() {
    std::vector<int> arr = {4, 2, 2, 8, 3, 3, 1};
    countingSort(arr);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 1 2 2 3 3 4 8
    return 0;
}
```

### Complexity

| Case | Time |
|---|---|
| All | O(n + k) |

**Space:** O(n + k).
**Stable:** Yes (with the prefix sum approach).

**When to use:** When k is not much larger than n. If k = O(n), the sort is O(n) — faster than comparison sorts!

**When NOT to use:** When the range k is very large (e.g., sorting 10 numbers in range [0, 10^9]) — the count array would be huge.

---

## 5.9 Radix Sort

### Concept

Sort numbers **digit by digit**, from least significant to most significant. Use a stable sort (like counting sort) for each digit.

### Visualization

```
Initial:  [170, 45, 75, 90, 802, 24, 2, 66]

Sort by ones digit:
  [170, 90, 802, 2, 24, 45, 75, 66]

Sort by tens digit:
  [802, 2, 24, 45, 66, 170, 75, 90]

Sort by hundreds digit:
  [2, 24, 45, 66, 75, 90, 170, 802]  ✓
```

### Code

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Counting sort by a specific digit (used as subroutine)
void countingSortByDigit(std::vector<int>& arr, int exp) {
    int n = arr.size();
    std::vector<int> output(n);
    std::vector<int> count(10, 0);

    // Count occurrences of each digit
    for (int i = 0; i < n; i++) {
        int digit = (arr[i] / exp) % 10;
        count[digit]++;
    }

    // Prefix sums
    for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
    }

    // Build output (reverse for stability)
    for (int i = n - 1; i >= 0; i--) {
        int digit = (arr[i] / exp) % 10;
        output[count[digit] - 1] = arr[i];
        count[digit]--;
    }

    arr = output;
}

// Radix Sort (LSD — Least Significant Digit first)
// Time: O(d × (n + b)) where d = number of digits, b = base (10)
// Space: O(n + b)
// Stable: Yes
void radixSort(std::vector<int>& arr) {
    if (arr.empty()) return;

    int maxVal = *std::max_element(arr.begin(), arr.end());

    // Sort by each digit, from least significant to most
    for (int exp = 1; maxVal / exp > 0; exp *= 10) {
        countingSortByDigit(arr, exp);
    }
}

int main() {
    std::vector<int> arr = {170, 45, 75, 90, 802, 24, 2, 66};
    radixSort(arr);

    std::cout << "Sorted: ";
    for (int x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 2 24 45 66 75 90 170 802
    return 0;
}
```

### Complexity

| Case | Time |
|---|---|
| All | O(d × (n + b)) |

Where d = number of digits, b = base (10 for decimal), n = number of elements.

If numbers have a fixed number of digits (e.g., 32-bit integers), d is constant and Radix Sort is **O(n)**.

**Space:** O(n + b).
**Stable:** Yes.

### When to Use

- When numbers have a bounded number of digits.
- When n is large but the range is manageable.
- As a subroutine for other algorithms.

---

## 5.10 Bucket Sort

### Concept

Distribute elements into buckets, sort each bucket individually, then concatenate. Works well when input is **uniformly distributed**.

### Code

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

// Bucket Sort for floating-point numbers in [0, 1)
// Time: O(n + k) average, O(n²) worst case
// Space: O(n + k)
// Stable: Depends on the sort used for buckets
void bucketSort(std::vector<float>& arr) {
    int n = arr.size();
    if (n <= 1) return;

    // Create n buckets
    std::vector<std::vector<float>> buckets(n);

    // Distribute elements into buckets
    for (float x : arr) {
        int idx = static_cast<int>(x * n);  // Map [0,1) to [0,n)
        if (idx >= n) idx = n - 1;
        buckets[idx].push_back(x);
    }

    // Sort each bucket
    for (auto& bucket : buckets) {
        std::sort(bucket.begin(), bucket.end());
    }

    // Concatenate buckets
    int idx = 0;
    for (auto& bucket : buckets) {
        for (float x : bucket) {
            arr[idx++] = x;
        }
    }
}

int main() {
    std::vector<float> arr = {0.897, 0.565, 0.656, 0.1234, 0.665, 0.3434};
    bucketSort(arr);

    std::cout << "Sorted: ";
    for (float x : arr) std::cout << x << " ";
    std::cout << std::endl;
    // Output: 0.1234 0.3434 0.565 0.656 0.665 0.897
    return 0;
}
```

### Complexity

| Case | Time | When? |
|---|---|---|
| Best | O(n + k) | Uniformly distributed |
| Average | O(n + k) | Uniformly distributed |
| Worst | O(n²) | All elements in one bucket |

**Space:** O(n + k) where k = number of buckets.

---

## 5.11 STL Sorting

### std::sort

The C++ standard library's `std::sort` is typically **IntroSort** — a hybrid of Quick Sort, Heap Sort, and Insertion Sort.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <string>

int main() {
    // Basic sort — ascending
    std::vector<int> nums = {5, 2, 8, 1, 9, 3};
    std::sort(nums.begin(), nums.end());
    // nums: {1, 2, 3, 5, 8, 9}

    // Descending sort
    std::sort(nums.begin(), nums.end(), std::greater<int>());
    // nums: {9, 8, 5, 3, 2, 1}

    // Sort with custom comparator
    std::vector<std::string> words = {"banana", "apple", "cherry", "date"};
    std::sort(words.begin(), words.end(),
        [](const std::string& a, const std::string& b) {
            return a.size() < b.size();  // Sort by length
        });
    // words: {"date", "apple", "banana", "cherry"}

    // Sort subarray
    std::vector<int> arr = {5, 2, 8, 1, 9, 3};
    std::sort(arr.begin() + 1, arr.begin() + 4);  // Sort indices [1, 4)
    // arr: {5, 1, 2, 8, 9, 3}

    // Partial sort — get the k smallest elements
    std::vector<int> ps = {5, 2, 8, 1, 9, 3};
    std::partial_sort(ps.begin(), ps.begin() + 3, ps.end());
    // First 3 elements are the 3 smallest, sorted: {1, 2, 3, ...}

    // nth_element — partition around the nth element
    std::vector<int> ne = {5, 2, 8, 1, 9, 3};
    std::nth_element(ne.begin(), ne.begin() + 2, ne.end());
    // ne[2] is the 3rd smallest element. Elements before are <= ne[2], after are >= ne[2]

    return 0;
}
```

### std::stable_sort

Preserves the relative order of equal elements:

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <string>

struct Student {
    std::string name;
    int grade;
};

int main() {
    std::vector<Student> students = {
        {"Alice", 85}, {"Bob", 90}, {"Charlie", 85}, {"Diana", 90}
    };

    // Sort by grade — stable sort preserves original order for equal grades
    std::stable_sort(students.begin(), students.end(),
        [](const Student& a, const Student& b) {
            return a.grade < b.grade;
        });

    for (const auto& s : students) {
        std::cout << s.name << ": " << s.grade << "\n";
    }
    // Alice: 85, Charlie: 85, Bob: 90, Diana: 90
    // Alice and Charlie maintain their original relative order
    // Bob and Diana maintain their original relative order

    return 0;
}
```

### Custom Comparators

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <tuple>

int main() {
    // Sort tuples by multiple criteria
    std::vector<std::tuple<int, int, std::string>> items = {
        {1, 3, "apple"},
        {2, 1, "banana"},
        {1, 2, "cherry"},
        {2, 1, "date"}
    };

    // Sort by first element ascending, then second element descending
    std::sort(items.begin(), items.end(),
        [](const auto& a, const auto& b) {
            if (std::get<0>(a) != std::get<0>(b))
                return std::get<0>(a) < std::get<0>(b);
            return std::get<1>(a) > std::get<1>(b);
        });

    for (const auto& [x, y, name] : items) {
        std::cout << "(" << x << ", " << y << ", " << name << ")\n";
    }
    // (1, 3, apple), (1, 2, cherry), (2, 1, banana), (2, 1, date)

    return 0;
}
```

---

## 5.12 Comparison of All Algorithms

| Algorithm | Best | Average | Worst | Space | Stable | In-Place |
|---|---|---|---|---|---|---|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | ✅ | ✅ |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | ❌ | ✅ |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | ✅ | ✅ |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | ✅ | ❌ |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | ❌ | ✅ |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) | ❌ | ✅ |
| Counting Sort | O(n+k) | O(n+k) | O(n+k) | O(n+k) | ✅ | ❌ |
| Radix Sort | O(d(n+b)) | O(d(n+b)) | O(d(n+b)) | O(n+b) | ✅ | ❌ |
| Bucket Sort | O(n+k) | O(n+k) | O(n²) | O(n+k) | ✅ | ❌ |

### Decision Guide

```
Need stable sort?
├── Yes → Merge Sort (general) or Counting/Radix (integers)
└── No
    ├── Need guaranteed O(n log n)? → Heap Sort or Merge Sort
    ├── Need in-place? → Quick Sort (average) or Heap Sort
    ├── Small array (n < 50)? → Insertion Sort
    ├── Nearly sorted? → Insertion Sort or Timsort
    └── General purpose? → Quick Sort or std::sort
```

### The Comparison Sort Lower Bound

**Theorem:** Any comparison-based sorting algorithm requires Ω(n log n) comparisons in the worst case.

**Proof sketch:** There are n! possible permutations of n elements. Each comparison eliminates at most half the possibilities. After k comparisons, at most 2^k outcomes. We need 2^k ≥ n!, so k ≥ log₂(n!) = Ω(n log n).

This means Merge Sort, Quick Sort, and Heap Sort are **asymptotically optimal** among comparison sorts. Counting Sort and Radix Sort beat this bound by not using comparisons.

---

## Interview Tips

1. **Know Merge Sort and Quick Sort cold.** They're the most commonly asked about.

2. **Quick Sort's partition** is a standalone technique. It's used in Quick Select (finding kth element) and other problems.

3. **Stability matters.** When asked to sort by multiple criteria, stability is essential.

4. **std::sort is IntroSort:** Quick Sort for most of the work, switches to Heap Sort if recursion gets too deep, switches to Insertion Sort for small subarrays.

5. **Non-comparison sorts** (Counting, Radix, Bucket) are O(n) but have constraints on input type/range.

6. **Practice the partition step** — it's the core of Quick Sort and appears in many interview problems (e.g., Dutch National Flag).

## Common Mistakes

| Mistake | Why It's Wrong | Fix |
|---|---|---|
| Using `std::sort` on linked list | O(n²) — no random access | Use `list.sort()` |
| Wrong comparator (not strict weak ordering) | Undefined behavior | Ensure `comp(a,a)` is false, transitivity holds |
| Forgetting stability requirement | Wrong answer for multi-key sort | Use `std::stable_sort` |
| Quick Sort pivot = first element on sorted data | O(n²) worst case | Randomize pivot |
| Off-by-one in partition bounds | Infinite loop or wrong result | Test with small examples |
| Not handling equal elements in partition | Infinite loop | Include equality in one side |

## Practice Problems

| # | Problem | Difficulty | Key Concept |
|---|---|---|---|
| 1 | Sort an array of 0s, 1s, and 2s | Easy | Dutch National Flag |
| 2 | Merge two sorted arrays | Easy | Merge step of merge sort |
| 3 | Kth largest element | Medium | Quick Select / Heap |
| 4 | Sort colors (3-way partition) | Medium | Partition variation |
| 5 | Merge intervals | Medium | Sort + linear scan |
| 6 | Largest number (custom sort) | Medium | Custom comparator |
| 7 | Count inversions | Medium | Modified merge sort |
| 8 | Find k closest points to origin | Medium | Partial sort / nth_element |
| 9 | Maximum gap | Hard | Bucket sort / pigeonhole |
| 10 | Count of smaller numbers after self | Hard | Merge sort with indices |

---

*In the next chapter, we'll study searching algorithms — particularly binary search, one of the most powerful and versatile techniques in interviews.*
