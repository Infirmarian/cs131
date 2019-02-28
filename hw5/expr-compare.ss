#lang racket
(provide expr-compare)
(define (expr-compare x y)
  (cond
    [(and (boolean? x) (boolean? y)) (if (not (boolean=? x y)) (if x '% '(not %)) x)]
    [(and (number? x) (number? y)) (if (= x y) x `(if % ,x ,y))]
    [(and (string? x) (string? y)) (display x) (if (string=? x y) x `(if ,x % ,y))]
    [(and (list? x) (list? y))
     (if (empty? x)
         y (if (empty? y)
               x
               (cond
                 [(and (eq? 'list (car x)) (eq? 'list (car y))) (if (equal? x y) x `(if % ,x ,y))]
                 [(and (eq? 'quote (car x)) (eq? 'quote (car y))) (if (equal? x y) x `(if % ,x ,y))]
                 [(and (or (eq? 'if (car x)) (eq? 'if (car y))) (not (eq? (car x) (car y)))) `(if % ,x ,y)]
                 [(and (lambda? (car x)) (lambda? (car y))) (cons (car y) (cmplambda (cdr x) (cdr y)))]
                 [else (cons (expr-compare (car x) (car y)) (expr-compare (cdr x) (cdr y)))]
                 )
               ))]

    [(equal? x y) x]
    [(not (equal? x y)) `(if % ,x ,y)]
    [else #f])
  )
(define (cmplambda x y)
  (cond 
  [(and (list? x) (list? y) (not (empty? x)) (not (empty? y))) (cons (cmplambda (car x) (car y)) (cmplambda (cdr x) (cdr y)))]
  [else (if (equal? x y) x (orsymbol x y))]
  ))
; This is super janky, but I was able to combine into a symbol this way....
(define (orsymbol x y)
  (string->symbol (string-append (string-append (symbol->string x) "!") (symbol->string y))))
      
      
(define (lambda) (string->symbol "\u03BB"))
(define (lambda? y)
  (cond
    [(equal? y 'lambda) #t]
    [(equal? y (lambda)) #t]
    [else #f]
    )
  )
