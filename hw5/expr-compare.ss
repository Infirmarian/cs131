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
               (cons (expr-compare (car x) (car y)) (expr-compare (cdr x) (cdr y)))))]

    [(equal? x y) x]
    [(not (equal? x y)) `(if % ,x ,y)]
    [else #f])
  )

