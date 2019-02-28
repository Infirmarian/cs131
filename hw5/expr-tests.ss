#lang racket
(require "expr-compare.ss")
(display "0  ") (equal? (expr-compare 12 12) 12) ;0
(display "1  ") (equal? (expr-compare 12 20) '(if % 12 20)) ;1
(display "2  ") (equal? (expr-compare #t #t) #t) ;2
(display "3  ") (equal? (expr-compare #f #f) #f) ;3
(display "4  ") (equal? (expr-compare #t #f) '%) ;4
(display "5  ") (equal? (expr-compare #f #t) '(not %)) ;5
(display "6  ") (equal? (expr-compare 'a '(cons a b)) '(if % a (cons a b))) ;6
(display "7  ") (equal? (expr-compare '(cons a b) '(cons a b)) '(cons a b)) ;7
(display "8  ") (equal? (expr-compare '(cons a b) '(cons a c)) '(cons a (if % b c))) ;8
(display "9  ") (equal? (expr-compare '(cons (cons a b) (cons b c))
                                      '(cons (cons a c) (cons a c)))
                        '(cons (cons a (if % b c)) (cons (if % b a) c))) ;9
(display "10 ") (equal? (expr-compare '(cons a b) '(list a b))
                        '((if % cons list) a b)) ;10
(display "11 ") (equal? (expr-compare '(list) '(list a))
                        '(if % (list) (list a))) ;11
(display "12 ") (equal? (expr-compare ''(a b) ''(a c))  
                        '(if % '(a b) '(a c))) ;12
(display "13 ") (equal? (expr-compare '(quote (a b)) '(quote (a c)))
                        '(if % '(a b) '(a c))) ;13
(display "14 ") (equal? (expr-compare '(quoth (a b)) '(quoth (a c)))
                        '(quoth (a (if % b c)))) ;14
(display "15 ") (equal? (expr-compare '(if x y z) '(if x z z))
                        '(if x (if % y z) z)) ;15
(display "16 ") (equal? (expr-compare '(if x y z) '(g x y z))
                        '(if % (if x y z) (g x y z))) ;16
(display "17 ") (equal? (expr-compare '((lambda (a) (f a)) 1) '((lambda (a) (g a)) 2))
                        '((lambda (a) ((if % f g) a)) (if % 1 2))) ;17
(display "18 ") (equal? (expr-compare '((lambda (a) (f a)) 1) '((λ (a) (g a)) 2))
                        '((λ (a) ((if % f g) a)) (if % 1 2))) ;18
(display "19 ") (equal? (expr-compare '((lambda (a) a) c) '((lambda (b) b) d))
                        '((lambda (a!b) a!b) (if % c d))) ;19
(display "20 ") (equal? (expr-compare ''((λ (a) a) c) ''((lambda (b) b) d))
                        '(if % '((λ (a) a) c) '((lambda (b) b) d))) ;20
(display "21 ") (equal? (expr-compare '(+ #f ((λ (a b) (f a b)) 1 2)) '(+ #t ((lambda (a c) (f a c)) 1 2)))
                        '(+ (not %) ((λ (a b!c) (f a b!c)) 1 2))) ;21
(display "22 ") (equal? (expr-compare '((λ (a b) (f a b)) 1 2) '((λ (a b) (f b a)) 1 2))
                        '((λ (a b) (f (if % a b) (if % b a))) 1 2)) ;22
(display "23 ") (equal? (expr-compare '((λ (a b) (f a b)) 1 2) '((λ (a c) (f c a)) 1 2))
                        '((λ (a b!c) (f (if % a b!c) (if % b!c a))) 1 2)) ;23
(display "24 ") (equal? (expr-compare '((lambda (a) (eq? a ((λ (a b) ((λ (a b) (a b)) b a)) a (lambda (a) a)))) (lambda (b a) (b a)))
                                      '((λ (a) (eqv? a ((lambda (b a) ((lambda (a b) (a b)) b a)) a (λ (b) a)))) (lambda (a b) (a b))))
                        '((λ (a) ((if % eq? eqv?) a ((λ (a!b b!a) ((λ (a b) (a b)) (if % b!a a!b) (if % a!b b!a))) a (λ (a!b) (if % a!b a))))) (lambda (b!a a!b) (b!a a!b)))) ;24