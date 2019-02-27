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