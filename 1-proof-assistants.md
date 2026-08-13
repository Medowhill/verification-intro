* Title: Proof Assistants
* Subtitle: Introduction to Program Verification --- Part 1
* Author: Jaemin Hong

# Install Lean

* 1. Install VS Code
* 2. Install the Lean 4 extension
* Refer to <https://lean-lang.org/install>

# Program Verification

* Proving a property of a program
* Some interesting properties
  * Absence of memory safety violations
  * Information flow security
  * (Non-)termination
  * Type soundness
  * Compiler correctness
  * This program computes the Fibonacci number of its input

# Comparison with Other Approaches

* Testing
  * Can prove the presence of bugs, but not their absence
  * Typically requires an executable oracle
* (Sound) static analysis
  * Suffers from false positives
  * Each analyzer targets a specific class of properties

# Validation of Proofs

* How can we trust a proof consisting of thousands of lines?

# Proof Assistants

> *Formal proof assistants* are pieces of software designed to help their users
carry out computer-checked proofs. We usually call them *proof assistants*, or
*interactive theorem provers*, but a frustrated student coined the phrase
"proof-preventing beasts," and dictation software occasionally misunderstands
"theorem prover" as "fear improver."

(Baanen et al., The Hitchhiker's Guide to Logical Verification[^1])

[^1]: <https://github.com/lean-forward/logical_verification_2025>

# Formal Proofs

> A *formal proof* is a logical argument expressed in a logical
formalism. In this context, "formal" means "logical" or "logic-based."

> An *informal proof* is what a mathematician would normally call a
proof. The level of detail can vary a lot, and phrases such as "it is obvious
that," "clearly," and "without loss of generality" move some of the proof burden
onto the reader. 

(Baanen et al., The Hitchhiker's Guide to Logical Verification)

# Different Proof Assistants

* Grouped by their logical foundation
  * Dependent type theory: Agda, Lean, Rocq (formerly known as Coq)
  * Simple type theory: Isabelle/HOL
  * Set theory: Isabelle/ZF

# Formal Verification in the Real World

* CompCert, CakeML: verified compilers
* seL4, CertiKOS: verified kernels

# Formal Proofs in the AI Era

> We are sharing a selection of ten results, each of which resolves or makes
substantial progress on a long-standing open problem. These problems span
high-dimensional geometry, coding theory, arithmetic circuit complexity, group
theory, operator algebras, quantum complexity, lattice cryptography and extremal
combinatorics.

> The model formalized each argument in a Lean certificate.

(OpenAI, Ten advances in mathematics and theoretical computer science[^2])

[^2]: <https://openai.com/index/ten-advances-in-mathematics>

# Formal Verification in the AI Era

* From vibe coding to "veri-coding"
  * AIs write programs
  * AIs write proofs
  * Proofs are machine-checkable

* Humans should decide and understand the proven properties

# Curry-Howard Correspondence

* The core mechanism behind proof assistants based on dependent type theory
  * Proposition = Type
  * Proof = Term (Program)
  * Validating a proof = Type checking a term

# Today's Topics

* Functions and inductive types
* Polymorphism
* Dependent types
* Curry-Howard correspondence

# Live Coding

* Material at <https://github.com/plrg-unist/lean-intro>
* Use VS Code or Lean Playground (<https://live.lean-lang.org/>)

# How to Verify Programs

* Option 1: Write a program in a proof assistant and prove its properties
* Option 2: Embed a program written in another language into a proof assistant
  and prove its properties

# More Resources

* Software Foundations: <https://softwarefoundations.cis.upenn.edu/>
* The Hitchhiker's Guide to Logical Verification

# Part 2 Preview

* How can we state properties of programs?
* Can we have proof techniques that can be applied to a wide range of programs?
