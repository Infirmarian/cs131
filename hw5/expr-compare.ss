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
                 [(and (lambda? (car x)) (lambda? (car y))) (cons (car y) (cons (lambdaParams (cadr x) (cadr y)) (cons (newcmp (cadr x) (cadr y) (caddr x) (caddr y)) (expr-compare (cdddr x) (cdddr y)))))]
                 [else (cons (expr-compare (car x) (car y)) (expr-compare (cdr x) (cdr y)))]
                 )
               ))]

    [(equal? x y) x]
    [(not (equal? x y)) `(if % ,x ,y)]
    [else #f])
  )
(define (lambdaParamsMap m x y)
  (cond 
  [(and (list? x) (list? y) (not (empty? x)) (not (empty? y))) (cons (lambdaParamsMap (car m) (car x) (car y)) (lambdaParamsMap (cdr m) (cdr x) (cdr y)))]
  [(empty? x) x]
  [(empty? y) y]
  [else (if (equal? x y) (list m x) (list m (orsymbol x y)))]
  ))
(define (lambdaParams x y)
  (cond
    [(and (list? x) (list? y) (not (empty? x)) (not (empty? y))) (cons (lambdaParams (car x) (car y)) (lambdaParams (cdr x) (cdr y)))]
    [else (if (equal? x y) x (orsymbol x y))]))

(define (newcmp a1 a2 v1 v2)
  (let ([p1 (lambdaParamsMap a1 a1 a2)]) (let ([p2 (lambdaParamsMap a2 a1 a2)])
    (expr-compare (replacevalues p1 v1) (replacevalues p2 v2)))))

(define (replacevalues map v)
  (cond
    [(empty? map) v]
    [(empty? v) v]
    [(not (list? v)) (list (loopMap map v))]
    [else (cons (loopMap map (car v)) (replacevalues map (cdr v)))]))

(define (loopMap map v)
  (if (empty? map) v (if (equal? (car (car map)) v) (cadr (car map)) (loopMap (cdr map) v))))

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

       