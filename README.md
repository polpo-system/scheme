# Scheme for Oberon, for polpo

The Scheme interpreter of ETH Oberon System 3, written by Erich Oswald at ETH Zurich (2000)
and shipped with Native Oberon 2.3.7 and Oberon on Linux (OLR). It has exact rationals and
reals beside the integers, ports and files, and most of the procedures of R4RS, partly written
in Scheme itself (`Scheme.Init`). polpo compiles it on all its architectures (x86, ARM, ARMv7,
RISC-V, MIPS).

The smaller Scheme of Ceres Oberon (Michael Franz, 1989-1992) is the `mfscheme` package; both
can be installed together.

## What is here

    Scheme.Tool           the tool text: commands to click and what the interpreter has
    Scheme.Init           the library procedures written in Scheme (map, equal?, assoc, string
                          and vector procedures, display ...), read when Scheme is loaded
    src/Scheme.Mod        the engine: objects, reader, writer, evaluator, Scheme.Execute
    src/SchemeOps.Mod     the built-in procedures (numbers, pairs, strings, vectors, ports ...)
    test/SchemeTest.Mod   the test

## Installing

With portia, the package manager of polpo: `portia.Install scheme`. `Scheme.Tool` goes to
`tools/` and `Scheme.Init` to `share/`, where polpo finds them by name from any directory.

## Using it

In the desktop (`loksh System.Init`), open `Scheme.Tool` and click its commands with the middle
button. `Scheme.Execute` evaluates the forms after it, up to `#~`, and writes the value of the
last one to the log:

    Scheme.Execute (define (fact n) (if (= n 0) 1 (* n (fact (- n 1))))) (fact 12) #~
    Scheme.Execute (/ 1 3) #~
    Scheme.Execute *        the text of the marked viewer
    Scheme.Execute @        from the selection to the end of its text
    Scheme.Execute ^        the file whose name is selected

Each `Scheme.Execute` starts from the global definitions, so a `define` lasts for that one
command. There is no call-with-current-continuation, quasiquote or big integers (an integer
that overflows becomes a real).

## Changes for polpo

  * SchemeOps: the procedure `new`, which makes an object from a generator procedure such as
    `"Gadgets.New..."`, called `Gadgets.CreateObject`; it calls the generator itself now
    (`Oberon.Call`), so the package does not need Gadgets.
  * Reals are written without the leading blanks and the trailing zeros of the fraction
    (`3.5`, not `          3.5000000000`).
  * Scheme.Init: `call-with-input-file` and `call-with-output-file` passed the port to `apply`
    instead of calling the procedure with it, and always failed.
  * The ARM changes of OLR (record types named, no `ASH` in a constant) are kept; the sources
    are plain text instead of Oberon texts, indented with spaces, and so is `Scheme.Init`.

## Testing

`SchemeTest.Run` gives 19 forms to `Scheme.Execute` and compares what it writes (needs the
desktop modules: DISPLAY set; an Xvnc will do):

    SchemeTest: 19 checks, 0 failed

On the older ARM port (`bin/arm`) the heap stays at the 16 MB it gets at the start, and a long
computation can run out of it ("out of memory", trap 14): a loop of 10000 steps runs, one of
100000 does not.

The license is GPL-3 (`LICENSE`); the code comes from ETH Oberon, whose license (`LICENSE.ETH`)
asks to keep its copyright notice and conditions, which `LICENSE.ETH` does.
