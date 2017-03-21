(clear)
(clear-colour 1)

;(hint-none)
;(hint-wire)
;(hint-points)
;(hint-normal)
(point-width 3)
(line-width 1)

(define (x-light) 
    (light-diffuse 0.2 (vector 0.6 0 1))
    (light-position l (vector (* 10(cos(time))) 50 80))        
    (y))


(define l (make-light 'point 'free))

(define obj (build-nurbs-plane 40 40)) 

(define obj1 (build-nurbs-sphere 40 40))

(light-diffuse l (vector 1 1 1))
(shadow-light l)

(define (y) 

(with-state
    (translate (vector 0 0 0))
    (hint-cast-shadow)
    (with-primitive obj1
    ;(wire-colour (vector 0 1 1 0.01)) 
        (pdata-map! (lambda (p)
            (vadd (vmul (hsrndvec) 0.03) p))
        "p")))

(with-state
    (rotate (vector 290 10 0))     
    (with-primitive obj
    ;(normal-colour (vector 0 1 1 0.2)) 
        (pdata-map! (lambda (p)
            (vadd (vmul (hsrndvec) 0.03) p))
        "p"))))

(fog (vector 0 1 1) 0.09 1 1000)

(every-frame (x-light))
