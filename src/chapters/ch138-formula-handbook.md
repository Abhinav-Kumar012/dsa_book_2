# Chapter 138: Formula Handbook

## Quick Reference for Interview Formulas

---

## 138.1 Combinatorics

| Formula | Expression |
|---|---|
| Permutations | P(n,r) = n!/(n-r)! |
| Combinations | C(n,r) = n!/(r!(n-r)!) |
| Stars and Bars | C(n+k-1, k-1) |
| Catalan | C(n) = C(2n,n)/(n+1) |
| Derangements | D(n) = (n-1)(D(n-1)+D(n-2)) |
| Inclusion-Exclusion | |A∪B| = |A|+|B|-|A∩B| |

---

## 138.2 Number Theory

| Formula | Expression |
|---|---|
| Euler's Totient | φ(n) = n × ∏(1 - 1/p) for p|n |
| Modular Inverse | a^(-1) = a^(p-2) mod p (prime p) |
| GCD | gcd(a,b) = gcd(b, a%b) |
| LCM | lcm(a,b) = a*b/gcd(a,b) |
| CRT | x ≡ aᵢ (mod mᵢ), unique mod ∏mᵢ |
| Fermat's Little | a^(p-1) ≡ 1 (mod p) |

---

## 138.3 Sequences

| Sequence | Formula |
|---|---|
| Arithmetic sum | n(a₁+aₙ)/2 |
| Geometric sum | a(rⁿ-1)/(r-1) |
| Fibonacci | F(n) = F(n-1)+F(n-2), F(n) ≈ φⁿ/√5 |
| Harmonic | H(n) ≈ ln(n) + γ |
| Triangular | T(n) = n(n+1)/2 |
| Square pyramidal | Σk² = n(n+1)(2n+1)/6 |

---

## 138.4 Probability

| Formula | Expression |
|---|---|
| Bayes | P(A|B) = P(B|A)P(A)/P(B) |
| Linearity | E[X+Y] = E[X]+E[Y] |
| Birthday paradox | P ≈ 1 - e^(-n²/2d) |
| Coupon collector | E = n×H(n) ≈ n ln n |
| Geometric dist | E = 1/p |

---

## 138.5 Graph Theory

| Formula | Expression |
|---|---|
| Euler's formula | V - E + F = 2 (planar) |
| Handshaking | Σdeg(v) = 2|E| |
| Tree edges | |E| = |V| - 1 |
| DAG paths | Topo sort + DP |
