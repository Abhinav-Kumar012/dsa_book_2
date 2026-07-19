# Chapter 30: Dynamic Programming Fundamentals

Dynamic Programming (DP) is one of the most powerful algorithmic paradigms in computer science and one of the most heavily tested topics in technical interviews. At its core, DP is about **solving complex problems by breaking them into simpler subproblems, solving each subproblem once, and storing the results** to avoid redundant computation. This chapter builds DP intuition from the ground up.

---

## 30.1 What Is DP?

Dynamic Programming is an optimization technique applied to problems that exhibit two key properties:

1. **Overlapping Subproblems** — The same subproblems are solved multiple times.
2. **Optimal Substructure** — The optimal solution to the problem can be constructed from optimal solutions to its subproblems.

If a problem has both properties, DP can transform an exponential-time brute-force solution into a polynomial-time algorithm.

### The Key Insight

Consider computing the Fibonacci sequence. The naive recursive definition is:

```
F(0) = 0, F(1) = 1
F(n) = F(n-1) + F(n-2)
```

This looks elegant, but it's catastrophically inefficient. Why? Because `F(n-1)` and `F(n-2)` both recompute `F(n-3)`, `F(n-4)`, etc. The same values are calculated exponentially many times.

**DP's insight**: If we've already computed `F(k)`, store it. When we need `F(k)` again, look it up in O(1) instead of recomputing it.

This simple idea — **compute once, reuse many times** — is the foundation of all dynamic programming.

---

## 30.2 Overlapping Subproblems

A problem has **overlapping subproblems** when a recursive algorithm revisits the same subproblems repeatedly.

### Fibonacci: The Canonical Example

Let's trace the recursion tree for `F(5)`:

```
                        F(5)
                      /      \
                  F(4)        F(3)
                /    \       /    \
            F(3)    F(2)   F(2)  F(1)
           /   \    / \    / \
       F(2)  F(1) F(1) F(0) F(1) F(0)
      / \
  F(1) F(0)
```

Notice: `F(3)` is computed **twice**, `F(2)` is computed **three times**, `F(1)` is computed **five times**. For `F(n)`, the time complexity is O(2^n) — exponential!

The number of unique subproblems is only `n+1` (from `F(0)` to `F(n)`), but without memoization, we compute each one exponentially many times.

### Naive Recursive Implementation

```cpp
#include <iostream>
#include <chrono>

// Naive recursive Fibonacci — O(2^n) time
long long fib_naive(int n) {
    if (n <= 1) return n;
    return fib_naive(n - 1) + fib_naive(n - 2);
}

int main() {
    auto start = std::chrono::high_resolution_clock::now();
    std::cout << "F(40) = " << fib_naive(40) << "\n";
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    std::cout << "Time: " << duration.count() << " ms\n";
    return 0;
}
```

For `n = 40`, this takes several seconds. For `n = 50`, it would take minutes.

### With Memoization

```cpp
#include <iostream>
#include <vector>
#include <chrono>

// Memoized Fibonacci — O(n) time, O(n) space
long long fib_memo(int n, std::vector<long long>& memo) {
    if (n <= 1) return n;
    if (memo[n] != -1) return memo[n];  // Already computed
    memo[n] = fib_memo(n - 1, memo) + fib_memo(n - 2, memo);
    return memo[n];
}

int main() {
    int n = 40;
    std::vector<long long> memo(n + 1, -1);
    
    auto start = std::chrono::high_resolution_clock::now();
    std::cout << "F(40) = " << fib_memo(n, memo) << "\n";
    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    std::cout << "Time: " << duration.count() << " microseconds\n";
    return 0;
}
```

The memoized version runs in microseconds. The difference is dramatic.

---

## 30.3 Optimal Substructure

A problem has **optimal substructure** if an optimal solution to the problem contains optimal solutions to its subproblems.

### Shortest Path Example

Consider finding the shortest path from A to D in a weighted graph. If the shortest path goes A → B → C → D, then:
- The path from A to C (A → B → C) must be the shortest path from A to C.
- The path from B to D (B → C → D) must be the shortest path from B to D.

If this weren't true — if there were a shorter path from A to C — we could substitute it and get a shorter path from A to D, contradicting our assumption.

### When Optimal Substructure Fails

Not all problems have optimal substructure. For example, the **longest simple path** problem in a general graph does NOT have optimal substructure because the subproblems share vertices and edges, making them non-independent.

**Key distinction**: Problems with optimal substructure allow us to combine subproblem solutions without them interfering with each other.

### How Subproblems Combine

In DP, we express the solution to a problem in terms of solutions to smaller subproblems using a **recurrence relation**. For example:

```
LCS(X[0..m-1], Y[0..n-1]) = 
    if X[m-1] == Y[n-1]:  1 + LCS(X[0..m-2], Y[0..n-2])
    else:                  max(LCS(X[0..m-2], Y[0..n-1]), LCS(X[0..m-1], Y[0..n-2]))
```

This recurrence captures the optimal substructure of the Longest Common Subsequence problem.

---

## 30.4 Memoization vs Tabulation

There are two approaches to implementing DP:

### Top-Down (Memoization)

- Start from the original problem and recurse.
- Cache results of each subproblem.
- Uses recursion + a memo table (usually a hash map or array).

### Bottom-Up (Tabulation)

- Start from the smallest subproblems.
- Build up solutions iteratively.
- Uses a DP table filled in a specific order.

### Code Comparison: Fibonacci

**Top-Down (Memoization)**:

```cpp
#include <iostream>
#include <vector>

class FibonacciTopDown {
    std::vector<long long> memo;
    
public:
    FibonacciTopDown(int n) : memo(n + 1, -1) {}
    
    long long solve(int n) {
        if (n <= 1) return n;
        if (memo[n] != -1) return memo[n];
        memo[n] = solve(n - 1) + solve(n - 2);
        return memo[n];
    }
};

int main() {
    FibonacciTopDown fib(50);
    for (int i = 0; i <= 10; ++i) {
        std::cout << "F(" << i << ") = " << fib.solve(i) << "\n";
    }
    return 0;
}
```

**Bottom-Up (Tabulation)**:

```cpp
#include <iostream>
#include <vector>

long long fib_bottom_up(int n) {
    if (n <= 1) return n;
    std::vector<long long> dp(n + 1);
    dp[0] = 0;
    dp[1] = 1;
    for (int i = 2; i <= n; ++i) {
        dp[i] = dp[i - 1] + dp[i - 2];
    }
    return dp[n];
}

int main() {
    for (int i = 0; i <= 10; ++i) {
        std::cout << "F(" << i << ") = " << fib_bottom_up(i) << "\n";
    }
    return 0;
}
```

### Tradeoffs

| Aspect | Memoization (Top-Down) | Tabulation (Bottom-Up) |
|--------|----------------------|----------------------|
| **Intuition** | Closer to natural recursion | Requires understanding order |
| **Computation** | Only computes needed subproblems | Computes ALL subproblems |
| **Stack usage** | Uses call stack (risk of stack overflow) | No recursion overhead |
| **Space** | Memo table + call stack | DP table only |
| **Debugging** | Harder to trace | Easier (iterative) |
| **Optimization** | Harder to space-optimize | Easy to space-optimize |

**Rule of thumb**: Start with memoization to get the recurrence right, then convert to tabulation for space optimization.

---

## 30.5 The DP Framework

Every DP problem can be solved by following this systematic framework:

### Step 1: Define the State

What information do we need to represent a subproblem? This is the most critical step.

- **State variables**: What parameters uniquely identify a subproblem?
- **State meaning**: What does `dp[i]` (or `dp[i][j]`, etc.) represent?

### Step 2: Write the Recurrence Relation

Express the current state in terms of smaller states.

```
dp[i] = f(dp[i-1], dp[i-2], ...)
```

### Step 3: Identify Base Cases

What are the smallest subproblems whose answers are known directly?

### Step 4: Determine Computation Order

For bottom-up: In what order should we fill the DP table so that dependencies are satisfied?

### Step 5: Extract the Answer

Where is the final answer in the DP table?

### Example: Climbing Stairs

**Problem**: You can climb 1 or 2 steps at a time. How many distinct ways to reach step `n`?

1. **State**: `dp[i]` = number of ways to reach step `i`
2. **Recurrence**: `dp[i] = dp[i-1] + dp[i-2]` (reach step `i` from step `i-1` or step `i-2`)
3. **Base case**: `dp[0] = 1` (one way to stay at ground), `dp[1] = 1`
4. **Order**: Compute `dp[0], dp[1], ..., dp[n]`
5. **Answer**: `dp[n]`

```cpp
#include <iostream>
#include <vector>

int climb_stairs(int n) {
    if (n <= 1) return 1;
    
    // Space-optimized: only need last two values
    int prev2 = 1;  // dp[0]
    int prev1 = 1;  // dp[1]
    
    for (int i = 2; i <= n; ++i) {
        int curr = prev1 + prev2;
        prev2 = prev1;
        prev1 = curr;
    }
    return prev1;
}

int main() {
    for (int n = 0; n <= 10; ++n) {
        std::cout << "Ways to climb " << n << " stairs: " << climb_stairs(n) << "\n";
    }
    return 0;
}
```

**Output**:
```
Ways to climb 0 stairs: 1
Ways to climb 1 stairs: 1
Ways to climb 2 stairs: 2
Ways to climb 3 stairs: 3
Ways to climb 4 stairs: 5
Ways to climb 5 stairs: 8
Ways to climb 6 stairs: 13
Ways to climb 7 stairs: 21
Ways to climb 8 stairs: 34
Ways to climb 9 stairs: 55
Ways to climb 10 stairs: 89
```

---

## 30.6 Classic Problems

Let's work through four classic DP problems, showing the progression from brute force to optimized solution.

### 30.6.1 Coin Change

**Problem**: Given coin denominations and a target amount, find the minimum number of coins needed.

#### Brute Force

Try every combination of coins. For each coin, try using it and recurse on the remaining amount.

```cpp
#include <iostream>
#include <vector>
#include <climits>

// Brute force — exponential time
int coin_change_brute(const std::vector<int>& coins, int amount) {
    if (amount == 0) return 0;
    if (amount < 0) return -1;
    
    int min_coins = INT_MAX;
    for (int coin : coins) {
        int result = coin_change_brute(coins, amount - coin);
        if (result != -1) {
            min_coins = std::min(min_coins, 1 + result);
        }
    }
    return (min_coins == INT_MAX) ? -1 : min_coins;
}
```

#### Memoization

```cpp
#include <iostream>
#include <vector>
#include <climits>

int coin_change_memo_helper(const std::vector<int>& coins, int amount, 
                            std::vector<int>& memo) {
    if (amount == 0) return 0;
    if (amount < 0) return -1;
    if (memo[amount] != -2) return memo[amount];
    
    int min_coins = INT_MAX;
    for (int coin : coins) {
        int result = coin_change_memo_helper(coins, amount - coin, memo);
        if (result != -1) {
            min_coins = std::min(min_coins, 1 + result);
        }
    }
    memo[amount] = (min_coins == INT_MAX) ? -1 : min_coins;
    return memo[amount];
}

int coin_change_memo(const std::vector<int>& coins, int amount) {
    std::vector<int> memo(amount + 1, -2);  // -2 means "not computed"
    return coin_change_memo_helper(coins, amount, memo);
}

int main() {
    std::vector<int> coins = {1, 5, 10, 25};
    int amount = 30;
    std::cout << "Min coins for " << amount << ": " 
              << coin_change_memo(coins, amount) << "\n";
    return 0;
}
```

#### Tabulation

```cpp
#include <iostream>
#include <vector>
#include <climits>

int coin_change_tab(const std::vector<int>& coins, int amount) {
    // dp[i] = minimum coins to make amount i
    std::vector<int> dp(amount + 1, INT_MAX);
    dp[0] = 0;  // base case: 0 coins for amount 0
    
    for (int i = 1; i <= amount; ++i) {
        for (int coin : coins) {
            if (coin <= i && dp[i - coin] != INT_MAX) {
                dp[i] = std::min(dp[i], dp[i - coin] + 1);
            }
        }
    }
    return (dp[amount] == INT_MAX) ? -1 : dp[amount];
}

int main() {
    std::vector<int> coins = {1, 5, 10, 25};
    std::cout << "Min coins for 30: " << coin_change_tab(coins, 30) << "\n";
    std::cout << "Min coins for 11 (coins={1,5,6}): " 
              << coin_change_tab({1, 5, 6}, 11) << "\n";
    return 0;
}
```

**Complexity**: O(amount × |coins|) time, O(amount) space.

### 30.6.2 0/1 Knapsack

**Problem**: Given `n` items with weights and values, and a knapsack of capacity `W`, maximize the total value. Each item can be used at most once.

#### Brute Force

Try all 2^n subsets. For each subset, check if total weight ≤ W and track maximum value.

#### Tabulation (Bottom-Up)

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

int knapsack_01(const std::vector<int>& weights, const std::vector<int>& values, 
                int capacity) {
    int n = weights.size();
    // dp[i][w] = max value using items 0..i-1 with capacity w
    std::vector<std::vector<int>> dp(n + 1, std::vector<int>(capacity + 1, 0));
    
    for (int i = 1; i <= n; ++i) {
        for (int w = 0; w <= capacity; ++w) {
            // Don't take item i-1
            dp[i][w] = dp[i - 1][w];
            // Take item i-1 (if it fits)
            if (weights[i - 1] <= w) {
                dp[i][w] = std::max(dp[i][w], 
                                     dp[i - 1][w - weights[i - 1]] + values[i - 1]);
            }
        }
    }
    return dp[n][capacity];
}

// Space-optimized version using 1D array
int knapsack_01_optimized(const std::vector<int>& weights, 
                          const std::vector<int>& values, int capacity) {
    int n = weights.size();
    std::vector<int> dp(capacity + 1, 0);
    
    for (int i = 0; i < n; ++i) {
        // Traverse backwards to avoid using an item twice
        for (int w = capacity; w >= weights[i]; --w) {
            dp[w] = std::max(dp[w], dp[w - weights[i]] + values[i]);
        }
    }
    return dp[capacity];
}

int main() {
    std::vector<int> weights = {2, 3, 4, 5};
    std::vector<int> values  = {3, 4, 5, 6};
    int capacity = 8;
    
    std::cout << "Max value (2D): " << knapsack_01(weights, values, capacity) << "\n";
    std::cout << "Max value (1D): " << knapsack_01_optimized(weights, values, capacity) << "\n";
    return 0;
}
```

**Output**:
```
Max value (2D): 10
Max value (1D): 10
```

**Complexity**: O(n × W) time. 2D version: O(n × W) space. 1D version: O(W) space.

### 30.6.3 Longest Common Subsequence (LCS)

**Problem**: Given two strings, find the length of their longest common subsequence.

#### Tabulation

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

int lcs(const std::string& s1, const std::string& s2) {
    int m = s1.size(), n = s2.size();
    // dp[i][j] = LCS of s1[0..i-1] and s2[0..j-1]
    std::vector<std::vector<int>> dp(m + 1, std::vector<int>(n + 1, 0));
    
    for (int i = 1; i <= m; ++i) {
        for (int j = 1; j <= n; ++j) {
            if (s1[i - 1] == s2[j - 1]) {
                dp[i][j] = 1 + dp[i - 1][j - 1];
            } else {
                dp[i][j] = std::max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    return dp[m][n];
}

// Space-optimized: O(min(m,n)) space
int lcs_optimized(const std::string& s1, const std::string& s2) {
    // Make s1 the shorter string
    if (s1.size() > s2.size()) return lcs_optimized(s2, s1);
    
    int m = s1.size(), n = s2.size();
    std::vector<int> prev(m + 1, 0), curr(m + 1, 0);
    
    for (int j = 1; j <= n; ++j) {
        for (int i = 1; i <= m; ++i) {
            if (s1[i - 1] == s2[j - 1]) {
                curr[i] = 1 + prev[i - 1];
            } else {
                curr[i] = std::max(prev[i], curr[i - 1]);
            }
        }
        std::swap(prev, curr);
        std::fill(curr.begin(), curr.end(), 0);
    }
    return prev[m];
}

int main() {
    std::string s1 = "ABCBDAB";
    std::string s2 = "BDCABA";
    std::cout << "LCS length (2D): " << lcs(s1, s2) << "\n";
    std::cout << "LCS length (1D): " << lcs_optimized(s1, s2) << "\n";
    return 0;
}
```

**Output**:
```
LCS length (2D): 4
LCS length (1D): 4
```

The LCS is "BCBA" (length 4).

**Complexity**: O(m × n) time, O(m × n) or O(min(m, n)) space.

---

## 30.7 State Space Design

The hardest part of DP is choosing the right state definition. Here are principles to guide you:

### Single Variable State

When the problem involves one sequence or one dimension of choice:

```
dp[i] = answer for the prefix [0..i]
```

**Examples**: Climbing stairs, house robber, maximum subarray.

### Multiple Variable State

When the problem involves two sequences or two dimensions:

```
dp[i][j] = answer for prefixes s1[0..i-1] and s2[0..j-1]
```

**Examples**: LCS, edit distance, knapsack.

### State Design Principles

1. **State should capture all information needed** to solve the subproblem independently.
2. **State should be minimal** — include only what's necessary.
3. **State should lead to a recurrence** that expresses the current state in terms of smaller states.

### Example: Why State Matters

Consider a problem: "Find the maximum profit from buying and selling a stock at most `k` times."

**Bad state**: `dp[i]` = max profit up to day `i`. (Doesn't track how many transactions used.)

**Good state**: `dp[i][j][0/1]` = max profit up to day `i`, with at most `j` transactions, where 0 = not holding, 1 = holding.

The state must capture everything that affects future decisions.

### Dry Run: Coin Change

Let's trace `coin_change_tab({1, 5, 6}, 11)`:

```
dp[0]  = 0  (base case)
dp[1]  = dp[0] + 1 = 1  (use coin 1)
dp[2]  = dp[1] + 1 = 2
dp[3]  = dp[2] + 1 = 3
dp[4]  = dp[3] + 1 = 4
dp[5]  = min(dp[4]+1, dp[0]+1) = min(5, 1) = 1  (use coin 5)
dp[6]  = min(dp[5]+1, dp[1]+1, dp[0]+1) = min(2, 2, 1) = 1  (use coin 6)
dp[7]  = min(dp[6]+1, dp[2]+1, dp[1]+1) = min(2, 3, 2) = 2
dp[8]  = min(dp[7]+1, dp[3]+1, dp[2]+1) = min(3, 4, 3) = 3
dp[9]  = min(dp[8]+1, dp[4]+1, dp[3]+1) = min(4, 5, 4) = 4
dp[10] = min(dp[9]+1, dp[5]+1, dp[4]+1) = min(5, 2, 5) = 2
dp[11] = min(dp[10]+1, dp[6]+1, dp[5]+1) = min(3, 2, 2) = 2
```

Answer: 2 (coins 5 + 6).

---

## Interview Tips

1. **Always start with the recurrence relation**. Don't worry about optimization until you have a correct recurrence.

2. **Draw the recursion tree** for small inputs. This reveals overlapping subproblems and guides your state definition.

3. **State definition is 80% of the work**. If you get the state right, the recurrence almost writes itself.

4. **Start with memoization**, then convert to tabulation. It's easier to think recursively.

5. **Space optimization**: If `dp[i]` only depends on `dp[i-1]`, you only need two rows (or one row with backward iteration).

6. **Verify base cases carefully**. Off-by-one errors in base cases are the #1 source of bugs.

7. **Trace through a small example** by hand before coding. Fill in a DP table on paper.

## Common Mistakes

| Mistake | Why It's Wrong | Fix |
|---------|---------------|-----|
| Forgetting base cases | Leads to wrong answers or infinite recursion | Always define base cases first |
| Wrong iteration order | Bottom-up needs dependencies computed first | Draw dependency graph |
| Not initializing DP table | Garbage values lead to wrong comparisons | Initialize to appropriate sentinel |
| Using INT_MAX without overflow checks | `INT_MAX + 1` overflows | Check before adding |
| Off-by-one in indices | `dp[i]` vs `dp[i-1]` confusion | Be explicit about what `i` represents |
| Space optimization breaks order | 1D knapsack must iterate backwards | Understand why direction matters |

## Practice Problems

1. **Min Cost Climbing Stairs** (LeetCode 746) — `dp[i] = min(dp[i-1]+cost[i-1], dp[i-2]+cost[i-2])`
2. **House Robber** (LeetCode 198) — `dp[i] = max(dp[i-1], dp[i-2]+nums[i])`
3. **Decode Ways** (LeetCode 91) — Count ways to decode a digit string
4. **Unique Paths** (LeetCode 62) — 2D DP on a grid
5. **Minimum Path Sum** (LeetCode 64) — 2D DP with cost accumulation
6. **Partition Equal Subset Sum** (LeetCode 416) — 0/1 Knapsack variant
7. **Coin Change 2** (LeetCode 518) — Count number of combinations
8. **Longest Palindromic Subsequence** (LeetCode 516) — LCS variant
9. **Edit Distance** (LeetCode 72) — Classic 2D DP
10. **Word Break** (LeetCode 139) — DP + dictionary lookup
