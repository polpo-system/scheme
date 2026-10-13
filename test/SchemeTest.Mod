MODULE SchemeTest;  (** SchemeTest.Run: Scheme.Execute evaluates the forms and writes the right results *)

(* Each case is a text given to Scheme.Execute as its parameter, as a click on the text would; the
   result written to the log is compared with the expected one. The library procedures (map, equal?,
   string-append ...) come from Scheme.Init, so this also checks that it was found. *)

IMPORT Texts, Oberon, Scheme, out;  (* out: the standard output, for the tests of portia *)

VAR W: Texts.Writer; fails, checks: LONGINT;

PROCEDURE Eval(src, expect: ARRAY OF CHAR);
VAR T: Texts.Text; R: Texts.Reader; ch: CHAR; res: ARRAY 128 OF CHAR; i: LONGINT;
BEGIN
  NEW(T); Texts.Open(T, ""); Texts.WriteString(W, src); Texts.WriteString(W, " #~"); Texts.Append(T, W.buf);
  Texts.Delete(Oberon.Log, 0, Oberon.Log.len);
  Oberon.Par.text := T; Oberon.Par.pos := 0; Oberon.Par.frame := NIL;
  Scheme.Execute;
  Texts.OpenReader(R, Oberon.Log, 0); Texts.Read(R, ch); i := 0;
  WHILE ~R.eot & (ch # 0DX) & (ch # 0AX) & (i < LEN(res) - 1) DO res[i] := ch; INC(i); Texts.Read(R, ch) END;
  res[i] := 0X;
  INC(checks);
  IF res # expect THEN
    INC(fails); out.String("SchemeTest: "); out.String(src); out.String(" gave "); out.String(res);
    out.String(", not "); out.String(expect); out.Ln
  END
END Eval;

PROCEDURE Run*;
BEGIN
  fails := 0; checks := 0;
  Eval("(+ 1 2)", "3");
  Eval("(define (fact n) (if (= n 0) 1 (* n (fact (- n 1))))) (fact 12)", "479001600");
  Eval("(/ 1 3)", "1/3");
  Eval("(+ (/ 1 3) (/ 1 6))", "1/2");
  Eval("(/ 7 2.0)", "3.5");
  Eval("(* 65536 65536)", "4294967296.0");
  Eval("(exact->inexact 1/4)", "0.25");
  Eval("(map (lambda (x) (* x x)) '(1 2 3 4))", "(1 4 9 16)");
  Eval("(let loop ((i 0) (acc '())) (if (= i 5) (reverse acc) (loop (+ i 1) (cons i acc))))", "(0 1 2 3 4)");
  Eval("(let* ((x 1) (y (+ x 1))) (list x y))", "(1 2)");
  Eval("(do ((i 0 (+ i 1)) (s 0 (+ s i))) ((= i 5) s))", "10");
  Eval("(force (delay (+ 2 3)))", "5");
  Eval('(string-append "ab" "cd")', '"abcd"');
  Eval("(vector-ref (vector 1 2 3) 1)", "2");
  Eval("(assoc 2 '((1 . one) (2 . two)))", "(2 . two)");
  Eval("(apply + '(1 2 3 4))", "10");
  Eval("(equal? '(1 (2 #(3))) (list 1 (list 2 (vector 3))))", "#t");
  Eval("(define (count n) (if (= n 0) 'done (count (- n 1)))) (count 10000)", "done");
  Eval("(car '())", "Scheme execution error - argument must be pair");
  out.String("SchemeTest: "); out.Int(checks, 0); out.String(" checks, "); out.Int(fails, 0); out.String(" failed"); out.Ln
END Run;

BEGIN Texts.OpenWriter(W)
END SchemeTest.
