#lang racket

(define-struct memory (val left right) #:transparent)

(define mem-empty (make-memory '() '() '()))

(define (shift-left m)
  (if (empty? (memory-right m))
      (make-memory '()
                   (cons (memory-val m) (memory-left m))
                   '())
      (make-memory (car (memory-right m))
                   (cons (memory-val m) (memory-left m))
                   (cdr (memory-right m)))))

(define (shift-right m)
  (if (empty? (memory-left m))
      (make-memory '()
                   '()
                   (cons (memory-val m) (memory-right m)))
      (make-memory (car (memory-left m))
                   (cdr (memory-left m))
                   (cons (memory-val m) (memory-right m)))))

(define (get-val m)
  (memory-val m))

(define (set-val m v)
  (make-memory v
               (memory-left m)
               (memory-right m)))


(define (output-state m tostring)
  (displayln (output-state-helper m tostring))
  (newline)
  m)

(define (output-state-helper m tostring)
  (define left (stack-left m tostring))
  (foldl (lambda (x acc)
           (string-append x " " acc))
         (car left)
         (cdr left)))

(define (stack-left m tostring)
  (flip-stack (cons (string-append "[" (tostring (memory-val m)) "]") (map tostring (memory-left m)))
              (map tostring (memory-right m))))


(define (flip-stack new old)
  (if (empty? old)
      new
      (flip-stack (cons (car old) new) (cdr old))))


(define (program-step m input)
  (cond
    [(or (symbol? input)
         (list? input))
     (case (car input)
       [(sl mr) (shift-left m)]
       [(sr ml) (shift-right m)]
       ['gv (begin (println (get-val m))
                   m)]
       ['sv (set-val m (cadr input))]
       ['halt (cons 'halted m)]
       [else (begin
               (displayln "Not a valid command!")
               m)])]
    [(string? input)
     (foldl (lambda (x acc)
              (program-step acc x))
            m
            (parse-to-command-list (string-split input) '()))]
    [else (begin "Not a valid command format!"
                 m)]))

(define (program m inputfunc [tostring default-tostring])
  (define new-state (program-step m (inputfunc m)))
  (if (memory? new-state)
      (program (output-state new-state tostring)
               inputfunc
               tostring)
      (begin (output-state (cdr new-state) tostring)
             (println (car new-state)))))


(define (parse-to-command-list input list)
  (if (empty? input)
      (flip-stack '() list)
      (parse-to-command-list (if (string=? (car input) "sv")
                                 (cddr input)
                                 (cdr input))
                             (cons (parse-to-command-single input) list))))

(define (parse-to-command-single input)
  (if (string=? (car input) "sv")
      (list 'sv (if (number? (string->number (cadr input)))
                    (string->number (cadr input))
                    (string->symbol (cadr input))))
      (list (string->symbol (car input)) '())))


(define (default-tostring v)
  (cond
    [(empty? v) "'()"]
    [(number? v) (number->string v)]
    [else (symbol->string v)]))

(define (get-user-symbol-input m)
  (define s (read))
  (if (equal? s 'sv)
      (list s (read))
      (list s)))


(define (start inputfunc [mem-init mem-empty] [tostring default-tostring])
  (output-state mem-init default-tostring)
  (program mem-init
           inputfunc
           tostring))



(define (mem-gen-fill size origin fill)
  (mem-gen size origin (lambda (x) fill)))

(define (mem-gen size origin gen)
  (define l (build-list size gen))
  (cond
    [(>= origin 0) (call shift-left (make-memory (car l) '() (cdr l)) origin)]
    [else (call shift-right (make-memory (car l) '() (cdr l)) (- origin))]))

(define (call f acc n)
  (if (> n 0)
      (call f (f acc) (sub1 n))
      acc))



(define (sample-program m)
  (define out (case (memory-val m)
                ['() "sv 0"]
                [(0) "mr sv 1"]
                [(1) "mr sv 0"]))
  (sleep 1)
  (displayln out)
  out)

(define (sample-program-2 m)
  (define out (case (memory-val m)
                ['() "sv 0"]
                [(0) "sv 1 mr sv 1"]
                [(1) "sv 0 ml ml ml"]))
  (sleep 2)
  (displayln out)
  out)

(define (sample-program-3 m)
  (define out (case (memory-val m)
                ['() "sv 0"]
                [(0) "sv 1"]
                [(1) "halt"]))
  (sleep 1)
  (displayln out)
  out)

;(mem-gen 4 2 (lambda (x) x))
;(mem-gen-fill 4 2 0)

;(start sample-program)
;(start sample-program (mem-gen-fill 1 0 1))
;(start sample-program-2)
;(start sample-program-2 (mem-gen-fill 1 4 1))
;(start sample-program-3)

;(start get-user-symbol-input)
