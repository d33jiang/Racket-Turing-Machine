# Racket-Turing-Machine

## Backstory

During the review tutorial for the final exam in CS 145, the TA brought up Turing machines as part of the material that the class had covered within the realm of computation models.

He then jokingly suggested to the class that coding up a Turing machine in Racket might be good practice for the exam, but I had already started creating this basic Turing machine emulator by the time he made the suggestion.

## Usage

The commented out lines at the bottom of [`tm.rkt`](/tm.rkt) are lines that can be run in order to see the machine in action.

* `(start sample-program)`, `(start sample-program-2)`, and `(start sample-program-3)` start the respective programs with memory that is lazily initialized with `'()`.
* `(start sample-program (mem-gen-fill 1 0 1))` and `(start sample-program-2 (mem-gen-fill 1 4 1))` start the programs with a user-defined initial state.
* `(start get-user-symbol-input)` starts the emulator, setting it up to receive actions to be taken from user input.

## Disclaimer

It is acknowledged that the permissible transition functions for Turing machines (according to the formal specification of Turing machines) are more limited than those for the emulator presented.

* An actual Turing machine takes as its input only the state of the current cell and, based on its input, determines only its next action.

* This is whereas the emulator can view every cell in memory and evolve the state with a sequence of actions of any length.

The emulator can be used to run programs for a Turing machine; however, the emulator is not, itself, a Turing machine.

The set of valid programs for the emulator is a superset of the set of valid programs for a Turing machine.

