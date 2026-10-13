Scheme: a Scheme interpreter for Oberon (Erich Oswald, ETH Zurich, 2000)

Click a command with the middle button. Scheme.Execute evaluates the forms that follow it,
up to #~, and writes the value of the last one to the log.

Scheme.Execute (+ 1 2) #~
Scheme.Execute (/ 1 3) #~
Scheme.Execute (sqrt 2.0) #~
Scheme.Execute (define (fact n) (if (= n 0) 1 (* n (fact (- n 1))))) (fact 12) #~
Scheme.Execute (map (lambda (x) (* x x)) '(1 2 3 4 5)) #~
Scheme.Execute (let loop ((i 0) (acc '())) (if (= i 5) (reverse acc) (loop (+ i 1) (cons i acc)))) #~
Scheme.Execute (display "hello") #~

Scheme.Execute *    evaluates the text of the marked viewer (F1 marks it)
Scheme.Execute @    evaluates from the start of the selection to the end of its text
Scheme.Execute ^    loads the file whose name is selected

Each Scheme.Execute starts from the global definitions: define in it what it uses (or put
the definitions in a file and (load "file")).

What it has: integers, exact rationals (1/3) and reals (an integer that overflows becomes a
real), characters, strings, symbols, lists, vectors, lambda with rest arguments, define,
set!, if, cond, case, and, or, let, named let, let*, letrec, begin, do, delay and force,
ports and files (open-input-file, read, write, load, with-output-to-file ...), and the
library procedures of Scheme.Init (map, for-each, equal?, assoc, string and vector
procedures ...).

What it lacks: call-with-current-continuation, quasiquote, big integers, complex numbers.

Scheme.Init is read once, when Scheme is loaded; polpo finds it in share/.
