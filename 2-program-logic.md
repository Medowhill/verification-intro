* Title: Program Logic
* Subtitle: Introduction to Program Verification --- Part 2
* Author: Jaemin Hong

* Note: When converting to LaTeX, every character except metavariables in the
  abstract syntax should use \texttt.
* Note: Specific program variables like x, y, z, etc. should use \texttt, while
  the metavariable x should not.
* Note: Inference rules should use \inferrule from the mathpartir package.
* Note: A number after a symbol in the math mode should be in the subscript.
* Note: Do not insert these notes into the LaTeX code.

# Program Verification

* How can we state properties of programs?
* Can we have proof techniques that can be applied to a wide range of programs?

# Today's Topics

* Preconditions and postconditions
* Program logic
  * Hoare logic
  * Separation logic
    * Separating conjunction
    * Frame rule
  * Iris
    * Resource algebras
    * Invariants

# Inference Rules

```math
premise1  premise2  ...
-----------------------
conclusion
```

means "if all premises can be proven, then the conclusion can be proven."

# Inference Rules: Example

* Modus ponens

```math
A   A => B
----------
B
```

# Imp Language: Syntax

```math
a ::= n | x | a + a | a - a | a * a | ...
b ::= true | false | a == a | a <= a | b && b | ...
c ::= skip | x := a | c; c | if b then c else c | while b do c
```

# Imp Language: Semantics (Arithmetic)

```math
{\it State} = {\it Var} \to \mathbb{Z}

-----------
S |- n => n


--------------
S |- x => S(x)


S |- a1 => n1   S |- a2 => n2
------------------------------
S |- a1 + a2 => n1 + n2
```

# Imp Language: Semantics (Boolean)

```math
-----------------------
S |- true => {\sf true}

S |- a1 => n1   S |- a2 => n2
------------------------------
S |- a1 == a2 => n1 = n2

S |- b1 => B1   S |- b2 => B2
------------------------------
S |- b1 && b2 => B1 /\ B2
```

# Imp Language: Semantics (Command)

```math
--------------
S |- skip => S

S |- a => n
-----------------------------
S |- x := a => S[x \mapsto n]

S0 |- c1 => S1   S1 |- c2 => S2
-------------------------------
S0 |- c1; c2 => S2
```

# Imp Language: Semantics (Command)

```math
S0 |- b => true   S0 |- c1 => S1
--------------------------------
S0 |- if b then c1 else c2 => S1

S0 |- b => false   S0 |- c2 => S2
---------------------------------
S0 |- if b then c1 else c2 => S2

S0 |- b => true   S0 |- c => S1   S1 |- while b do c => S2
-----------------------------------------------------------
S0 |- while b do c => S2

S |- b => false
----------------------
S |- while b do c => S
```

# Assertions

* An *assertion* is a logical claim about the state of a program's memory.
* Formally, an assertion is a predicate over $\it State$.

# Assertions: Examples

* $S \mapsto {\sf True}$, or ${\sf True}$ if it is clear that this expresses an assertion.
* $S \mapsto {\sf False}$, or ${\sf False}$.
* $S \mapsto S(\texttt{x}) = 5$, or $\texttt{x} = 5$.
* $S \mapsto S(\texttt{x}) = 5 \land S(\texttt{y}) = 7$, or $\texttt{x} = 5
  \land \texttt{y} = 7$.

# Assertion Implication

* Where $P$ and $Q$ are assertions, $P$ *implies* $Q$ iff, whenever $P$ holds in
  some state, $Q$ also holds.
* $P \Rightarrow Q$ iff $\forall S. P(S) \to Q(S)$.
* Examples:
  * $\texttt{x} = 5 \land \texttt{y} = 7$ implies $\texttt{x} = 5$.
  * Any assertion implies $\sf True$.
  * $\sf False$ implies any assertion.

# Hoare Triples

* A *Hoare triple* is a claim about the state before and after executing a command.
* A standard notation is $\{P\} c \{Q\}$, meaning
  * If $c$ begins execution in a state satisfying $P$ (precondition)
  * and if $c$ terminates,
  * then the final state satisfies $Q$ (postcondition).

# Hoare Triples: Examples

* $\{ {\sf True} \} \texttt{x} := 5 \{ \texttt{x} = 5 \}$ is valid.
* $\{ \texttt{x} = 5 \} \texttt{y} := 10 \{ \texttt{x} = 5 \}$ is valid.
* $\{ {\sf False} \} \texttt{x} := 5 \{ \texttt{x} = 10 \}$ is valid.
* $\{ {\sf True} \} \texttt{x} := 5 \{ {\sf False} \}$ is not valid.
* $\{ \texttt{x} = 5 \} \texttt{x} := 7 \{ \texttt{x} = 5 \}$ is not valid.

# Program Verification with Hoare Triples

* A *specification* of a program $prog$ can be stated with a precondition $P$
  and a postcondition $Q$.
* Verifying $prog$ with respect to the specification means proving that the
  Hoare triple $\{P\} prog \{Q\}$ is valid.

# Hoare Logic

* Hoare logic provides a compositional method for proving the validity of Hoare
  triples.
* The structure of a program's correctness proof mirrors the structure of the
  program.
* Proposed by Tony Hoare in 1969[^1] and subsequently refined by others.

[^1]: An axiomatic basis for computer programming (Hoare, 1969)

# Hoare Logic: Skip

```math
----------------
{ P } skip { P }
```

# Hoare Logic: Sequencing

```math
{ P } c1 { Q }   { Q } c2 { R }
-------------------------------
{ P } c1; c2 { R }
```

# Hoare Logic: Assignments

```math
-------------------------------
{ P[x \mapsto a] } x := a { P }
```

* Intuition: If we want $x := a$ to terminate in a state that satisfies P, then
  it suffices to start in a state that also satisfies P, except where every
  occurrence of $x$ is substituted with $a$. 

# Hoare Logic: Assignments --- Examples

* ${ 3=3 } \texttt{x} := 3 { \texttt{x} = 3 }$
* ${ \texttt{x}+1 \lt 5 } \texttt{x} := \texttt{x}+1 { \texttt{x} \lt 5 }$
* ${ \texttt{y} = 1 } \texttt{x} := \texttt{y} { \texttt{x} = 1 }$

# Hoare Logic: Consequence

```math
P \Rightarrow P'   { P' } c { Q' }   Q' \Rightarrow Q
-----------------------------------------------------
{ P } c { Q }
```

# Hoare Logic: Consequence --- Example

```math
True => 3=3   { 3=3 } x := 3 { x = 3 }   x=3 => x=3
----------------------------------------------------
{ True } \texttt{x} := 3 { \texttt{x} = 3 }
```

# Hoare Logic: Conditionals

```math
{ P \land b } c1 { Q }   { P \land \lnot b } c2 { Q }
----------------------------------------------------
{ P } if b then c1 else c2 { Q }
```

# Hoare Logic: Conditionals --- Example

* Let $c$ be $\texttt{if x == 0 then y := 2 else y := x + 1}$.

```math
True\land x=0 => x=0\land2=2   {x=0\land 2=2}y:=2{x=0\land y=2} x=0\land y=2 => x\le y
--------------------------------------------------------------------------------------
{True \land x=0} y := 2 { x \le y}


True\land \lnot x=0 => x+1=x+1  {x+1=x+1}y:=x+1{y=x+1} y=x+1 => x\le y
--------------------------------------------------------------------------------------
{True \land \lnot x=0} y := x + 1 { x \le y}


{True \land x=0} y := 2 { x \le y}  {True \land \lnot x=0} y := x + 1 { x \le y}
--------------------------------------------------------------------------------
{True} c { x \le y }
```

# Hoare Logic: Conditionals --- Example

```math
{ True }
if x == 0 then
  { True \land x=0 } =>
  { x=0 \land 2=2 }
  y := 2
  { x=0 \land y=2 } =>
  { x \le y }
else
  { True \land \lnot x=0 } =>
  { x+1=x+1 }
  y := x + 1
  { y=x+1 } =>
  { x \le y }
{ x \le y }
```

# Hoare Logic: While Loops

```math
{ P \land b } c { P }
---------------------------------------
{ P } while b do c { P \land \lnot b }
```

* $P$ is called a *loop invariant*.

# Hoare Logic: While Loops --- Example

```math
{x = 0} =>
{x \le 3}
while x <= 2 do
  {x \le 3 \land x \le 2} =>
  {x+1 \le 3}
  x := x + 1
  {x \le 3}
{ x \le 3 \land \lnot x \le 2 } =>
{ x = 3 }
```

# Hoare Logic: Soundness, Completeness, and Undecidability

* Soundness: any Hoare triple derived by the inference rules of Hoare logic is
  valid.
* Completeness: if a Hoare triple is valid, then it can be derived by the
  inference rules of Hoare logic.
* Undecidability: there is no algorithm that can determine whether an arbitrary
  Hoare triple is valid.

# Verifying Programs that Manipulate Pointers

* Is the following valid? ${ x\mapsto 0 \land y\mapsto 0 } *x := 1 { x\mapsto 1 \land y\mapsto 0 }$
  * Here, $x\mapsto v$ means that $x$ is a pointer to a memory cell containing $v$.

# Separation Logic

* Program logic that supports reasoning about programs that manipulate pointers.
* Key ideas: separating conjunction and frame rule.
* Proposed by Peter O'Hearn, John Reynolds, and Hongseok Yang in 2001[^2].

[^2]: Local reasoning about programs that alter data structures (O'Hearn et al.,
  2001)

# Memory Model

* ${\it Store} = {\it Var} \to {\it Val}$
* ${\it Heap} = \cup_{A\overset{\sf fin}{\subseteq} {\it Addr}} (A \to {\it Val})$
* ${\it State} = {\it Store} \times {\it Heap}$

# Notations for Heaps

* $H_1 \bot H_2$ means $dom(H_1) \cap dom(H_2) = \emptyset$.
* $H_1 \uplus H_2$ is the union of $H_1$ and $H_2$ if $H_1 \bot H_2$.

# Assertions

* An *assertion* is a logical claim about the state of a program's memory.
* Formally, an assertion is a predicate over $\it State$.

# Assertions in Separation Logic

* The assertion $\sf emp$ represents $(S, H)\mapsto dom(H) = \emptyset$.
* A *points-to* assertion $x\mapsto v$ represents $(S, H)\mapsto dom(H) =
  \{S(x)\} \land H(S(x)) = v$.
* A *separating conjunction* $P * Q$ represents $(S, H)\mapsto \exists H_1, H_2.
  H_1 \bot H_2 \land H_1 \uplus H_2 = H \land P(S, H_1) \land Q(S, H_2)$.
* A *separating implication* (*magic wand*) $P -* Q$ represents $(S, H)\mapsto
  \forall H'. H' \bot H \land P(S, H') \to Q(S, H \uplus H')$.

# Separating Conjunction: Examples

* $\texttt{x} \mapsto 3
  * tikz diagram: a single memory cell pointed to by x containing 3.
* $\texttt{x} \mapsto 3 * {\sf True}$
  * tikz diagram: a single memory cell pointed to by x containing 3, and a zero
    or more other memory cells that are not pointed to by x.
* $\texttt{x} \mapsto 3 * \texttt{y} \mapsto 3$
  * tikz diagram: two separate memory cells, one pointed to by x containing 3,
    and the other pointed to by y containing 3.
* $\texttt{x} \mapsto 3 \land \texttt{y} \mapsto 3$
  * tikz diagram: a single memory cell pointed to by both x and y containing 3.

# Separating Conjunction: Examples

* $\texttt{x} \mapsto 3 * \texttt{x} \mapsto 3$
  * Equivalent to $\sf False$
* $\texttt{x} \mapsto 3 \land \texttt{y} \mapsto 5$
  * Equivalent to $\sf False$

# Separation Logic is Substructural

* In general, $P$ does not imply $P * P$.

# Pure Assertions

* An assertion is *pure* if it is independent of the heap.
  * Syntactically, an assertion is pure if it does not contain $\sf emp$ or
    $\mapsto$.
* When assertions are pure, separating conjunction behaves like ordinary
  conjunction.
  * $P \land Q$ implies $P * Q$ if $P$ or $Q$ is pure.
  * $P * Q$ implies $P \land Q$ if $P$ and $Q$ are pure.

# Separation Logic: Frame Rule

```math
{ P } c { Q }
---------------------
{ P * R } c { Q * R }
```

where no variable in $R$ is modified by $c$.

* The key to *local reasoning* about the heap.

# Separation Logic: Allocation

```math
{ \sf emp } x := alloc(e) { x \mapsto e }
```

# Separation Logic: Mutation

```math
{ x \mapsto v } *x := e { x \mapsto e }
```

# Separation Logic: Deallocation

```math
{ x \mapsto v } free(x) { \sf emp }
```

# Concurrent Separation Logic (CSL)[^3]

```math
{ P } c1 { Q }   { R } c2 { S }
---------------------------------------
{ P * R } c1 || c2 { Q * S }
```

where neither command modifies a variable occurring in the other command or
its specification.

[^3]: Resources, concurrency, and local reasoning (O'Hearn, 2007)

# Extending CSL

> In recent years, separation logic has brought great advances in the world of
verification. However, there is a disturbing trend for each new library or
concurrency primitive to require a new separation logic.[^4]

[^4]: The next 700 separation logics (Parkinson, 2010)

# Iris[^5]

* Iris is a higher-order concurrent separation logic with user-defined resource
  algebras and invariants.

[^5]: Iris: Monoids and invariants as an orthogonal basis for concurrent
  reasoning (Jung et al., 2015)

# Iris: Example[^6]

* Code:

```math
mk_oneshot \triangleq \lambda _. let x = alloc(inl(0)) in
  { tryset = \lambda n. CAS(x, inl(0), inr(n)),
    check = \lambda _. let y = *x in \lambda _.
      match y, *x with
      | inl(_), _ => ()
      | inr(_), inl(_) => assert(false)
      | inr(n), inr(m) => assert(n = m)
      end
```

* Specification:

```math
{True} mk_oneshot() { c. \forall v. {True} c.tryset(v) { w. w ∈ {true, false} } ∗
                                   {True} c.check() { f. {True} f () {True} } }
```

[^6]: Iris from the ground up: A modular foundation for higher-order concurrent
  separation logic (Jung et al., 2018)

# Iris: Example --- Resource Algebra (Elements)

* We can define a resource algebra $M$ to reflect the state of the physical location $\texttt{x}$:

```math
M \triangleeq {\sf pending} | {\sf shot}(n : \mathbb{Z}) | ↯
```

* $\sf pending$ represents that the single update has not yet happened.
* $\sf shot(n)$ represents that the location has been set to $n$.
* $↯$ is the invalid state.

# Iris: Example --- Resource Algebra (Composition)

* We define how to compose elements of $M$: 
  * ${\sf shot}(n) \cdot {\sf shot}(n) = {\sf shot}(n)$.
  * Otherwise, $a \cdot b = ↯$.
* Intuitions
  * If we own $\sf pending$, we know that no other thread can own another part
    of this location. 
  * Once a value has been picked, it becomes the only possible value of the
    location; every thread agrees on what that value is.

# Iris: Example --- Frame-Preserving Updates

* Which updates are allowed for $M$?
* We can do a frame-preserving update from $a$ to $b$ (written $a \leadsto b$)
  when the following condition is met:

```math
\forall c^? \in M^?. a \cdot c^? \neq ↯ \to b \cdot c^? \neq ↯
```
where
```math
M^? \triangleeq M \uplus \{\bot\} and
a^? \cdot \bot \triangleeq \bot \cdot a^? \triangleeq a^?
```

* Frame-preserving updates for $M$
  * ${\sf pending} \leadsto {\sf shot}(n)$
  * ${\sf shot}(n) \leadsto {\sf shot}(n)$

# Iris: Example --- Invariant

* Connection between the physical location $\texttt{x}$ and the resource algebra
  $M$:

```math
I \triangleq (\texttt{x} \mapsto inl(0) * {\sf pending}) \lor (\exists n. \texttt{x}
\mapsto inr(n) * {\sf shot}(n))
```

# Iris: Example --- Verification Idea

```math
let x = alloc(inl(0)) in
{ x \mapsto inl(0) * {\sf pending} }
{ I }
{
  tryset = \lambda n.
  { I }
  CAS(x, inl(0), inr(n)),
  { I }
  check = \lambda _.
  { I }
  let y = *x in
  { I * (y=inl(0) \lor \exists n. y=inr(n) * {\sf shot}(n)) }
    \lambda _.
    { I * (y=inl(0) \lor \exists n. y=inr(n) * {\sf shot}(n)) }
    let z = *x in
    { I * (y=inl(0) \lor \exists n. y=z=inr(n)) }
    match y, z with ...
}
```

# Summary

* A specification of a program can be stated with a precondition and a
  postcondition.
* Program logic provides a compositional method for program verification.
* Separating conjunction, frame rule, resource algebras, and invariants are key
  concepts for complex verification tasks.
