# Chapter 69: Correctness Proofs and Loop Invariants

## Prerequisites

- Basic algorithms
- Mathematical induction

## Interview Frequency: ★★★

Proving correctness is essential for confident algorithm design. **Google** and **Microsoft** interviewers appreciate candidates who can argue why their solution works. Loop invariants are particularly important for iterative algorithms.

| Topic | Frequency | Difficulty | Notes |
|---|---|---|---|
| Loop invariants | ★★★★ | Medium | Prove iterative correctness |
| Induction proofs | ★★★★ | Medium | Prove recursive correctness |
| Exchange argument | ★★★ | Medium | Prove greedy correctness |
| Invariant maintenance | ★★★★ | Medium | Maintain during updates |

---

## 69.1 Loop Invariants

A **loop invariant** is a condition that:
1. **Initialization**: True before the loop starts
2. **Maintenance**: True at the start of each iteration (if true at start of previous)
3. **Termination**: True when the loop ends → gives us the correct result

### Example: Binary Search

```cpp
#include <iostream>
#include <vector>
#include <cassert>

// Loop invariant: if target exists, it's in arr[lo..hi]
int binarySearch(const std::vector<int>& arr, int target) {
    int lo = 0, hi = arr.size() - 1;
    
    // Invariant: target ∈ arr[lo..hi] if it exists in arr
    while (lo <= hi) {
        int mid = lo + (hi - lo) / 2;
        
        if (arr[mid] == target) return mid;
        if (arr[mid] < target) lo = mid + 1;
        else hi = mid - 1;
        // Invariant maintained: narrowed range correctly
    }
    
    // Termination: lo > hi, range is empty, target not found
    return -1;
}

int main() {
    std::vector<int> arr = {1, 3, 5, 7, 9, 11};
    assert(binarySearch(arr, 7) == 3);
    assert(binarySearch(arr, 4) == -1);
    assert(binarySearch(arr, 1) == 0);
    assert(binarySearch(arr, 11) == 5);
    std::cout << "All binary search tests passed.\n";
    return 0;
}
```

### Binary Search Loop Invariant Proof

```
Initialization: lo=0, hi=n-1. If target exists, it's in arr[0..n-1]. ✓

Maintenance: If target exists in arr[lo..hi]:
  - If arr[mid] == target: found, return
  - If arr[mid] < target: target must be in arr[mid+1..hi] (since sorted)
  - If arr[mid] > target: target must be in arr[lo..mid-1] (since sorted)
  Invariant maintained. ✓

Termination: lo > hi → range is empty → target not found. ✓
```

---

## 69.2 Proof by Induction

For recursive algorithms, use mathematical induction.

### Example: Merge Sort Correctness

**Claim**: Merge sort correctly sorts any array of n elements.

**Base case**: n ≤ 1 is trivially sorted. ✓

**Inductive step**: Assume merge sort correctly sorts arrays of size < n.
- Split array into two halves, each of size < n
- By induction, each half is correctly sorted
- Merge step combines two sorted arrays into one sorted array
- Therefore, the full array is correctly sorted. ✓

```cpp
#include <iostream>
#include <vector>
#include <algorithm>
#include <cassert>

void merge(std::vector<int>& arr, int lo, int mid, int hi) {
    std::vector<int> left(arr.begin() + lo, arr.begin() + mid + 1);
    std::vector<int> right(arr.begin() + mid + 1, arr.begin() + hi + 1);
    
    int i = 0, j = 0, k = lo;
    while (i < (int)left.size() && j < (int)right.size()) {
        if (left[i] <= right[j]) arr[k++] = left[i++];
        else arr[k++] = right[j++];
    }
    while (i < (int)left.size()) arr[k++] = left[i++];
    while (j < (int)right.size()) arr[k++] = right[j++];
}

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
    
    std::vector<int> expected = {3, 9, 10, 27, 38, 43, 82};
    assert(arr == expected);
    std::cout << "Merge sort correctness verified.\n";
    
    return 0;
}
```

---

## 69.3 The Exchange Argument (Greedy Correctness)

To prove a greedy algorithm is correct:

1. Let OPT be an optimal solution
2. Let GREEDY be our greedy solution
3. Show we can transform OPT into GREEDY without making it worse
4. Conclude GREEDY is also optimal

### Example: Activity Selection

**Greedy**: Always pick the activity that finishes earliest.

**Proof**:
1. Let OPT = {a₁, a₂, ..., aₖ} sorted by finish time
2. Let GREEDY = {g₁, g₂, ..., gₘ} sorted by finish time
3. Claim: m ≥ k (greedy picks at least as many)
4. Proof: g₁ finishes no later than a₁ (greedy picks earliest finish)
5. Therefore g₁ leaves more room for future activities
6. By induction, greedy picks at least as many as optimal

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

struct Activity { int start, end; };

int activitySelection(std::vector<Activity>& activities) {
    std::sort(activities.begin(), activities.end(),
              [](const Activity& a, const Activity& b) {
                  return a.end < b.end;
              });
    
    int count = 0, lastEnd = -1;
    for (auto& act : activities) {
        if (act.start >= lastEnd) {
            count++;
            lastEnd = act.end;
        }
    }
    return count;
}

int main() {
    std::vector<Activity> acts = {{1,4}, {3,5}, {0,6}, {5,7}, {3,9}, {5,9}};
    std::cout << "Max activities: " << activitySelection(acts) << "\n";
    return 0;
}
```

---

## 69.4 Invariant Maintenance in Data Structures

Data structures maintain invariants that ensure correctness.

### BST Invariant

For every node: left subtree values < node value < right subtree values

```cpp
#include <iostream>
#include <climits>

struct TreeNode {
    int val;
    TreeNode *left, *right;
    TreeNode(int v) : val(v), left(nullptr), right(nullptr) {}
};

// Invariant: all values in subtree are in (minVal, maxVal)
bool isValidBST(TreeNode* node, long long minVal = LLONG_MIN, 
                long long maxVal = LLONG_MAX) {
    if (!node) return true;
    if (node->val <= minVal || node->val >= maxVal) return false;
    return isValidBST(node->left, minVal, node->val) &&
           isValidBST(node->right, node->val, maxVal);
}

int main() {
    TreeNode* root = new TreeNode(5);
    root->left = new TreeNode(3);
    root->right = new TreeNode(7);
    root->left->left = new TreeNode(1);
    root->left->right = new TreeNode(4);
    
    std::cout << "Is valid BST: " << isValidBST(root) << "\n";
    
    root->left->right->val = 6; // Violates BST property
    std::cout << "Is valid BST: " << isValidBST(root) << "\n";
    
    return 0;
}
```

---

## Summary

| Proof Technique | When to Use | Key Idea |
|---|---|---|
| Loop Invariant | Iterative algorithms | Init → Maintenance → Termination |
| Induction | Recursive algorithms | Base case + inductive step |
| Exchange Argument | Greedy algorithms | Transform OPT to GREEDY |
| Invariant Maintenance | Data structures | Property holds after every operation |
