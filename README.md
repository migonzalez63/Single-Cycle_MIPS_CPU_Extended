# team07

Gonzalez, Miguel Angel <migonzalez@unm.edu>

Using the Single-Cycle CPU from Lab2, added functinality to the following
instructions:
* Differentiating between BNE and BEQ.
* Mutliplication, mfhi, mflo
* Direct-mapped Cache

Lab3 contains the entire project as in Lab2, but with some modified components.
Components that have been modified in order to add functionality:
* CPU
* registers
* instruct_mem
* mem

I have also added components to the CPU that provide the described functionallity.
All added components will be described in their respective parts.

## Part 1
* Added a component called Branch_Funt which given a signal and if the results of
  the given registers is zero, it can determine if what signals it must send
  in order to correctly perform the instruction

## Part 2
* Added component Mult_Unit, which performs a stall on the CPU until the execution
  the multiplication has been completed.
* Mult_unit contains multiple components inside of it that allow for the 
  multiplication and stall to happen.
* Multiplier is the component which actually performs the multiplication algorithm.
  Given a control component and a product register, it will continously shift the
  register to the right while checking the LSB of the product in order to see if
  we must add the sum of the multiplicand and the old upper 32 bits in order to
  form a new product result.
* Counter keeps track of the cycles left before the stall has officially end
  Will start off at zero with the reset of the CPU, but once a stall is initiated,
  will be set to 32 and stall the CPU for the full 32 cycles. When the contents of
  the register are zero, we will output this as a signal. This will allow for other
  components, such as the special HILO registers, to be able to read in the information
  of the hi and lo results of the product and also disable parts of our CPU for the
  stall
* Decrement will take in the current value of the Counter register and give
  a new value that is one less. This will allow us count our cycles for the stall
  and prevents infinitely stallling our CPU when a mult instruction is read. 