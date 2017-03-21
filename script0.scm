(clear)
(clear-colour 0)

(blur 0.)
;(hint-none)
;(hint-wire)
;(hint-points)
;(hint-normal)
(point-width 3)
(line-width 1)

(define (x-light) 
    (light-diffuse 1 (vector 1 1 0))
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
    (wire-colour (vector 1 0 1 )) 
        (pdata-map! (lambda (p)
            (vadd (vmul (srndvec) 0.008) p))
        "p")))

(with-state
    (rotate (vector 290 10 0))     
    (with-primitive obj
    (wire-colour (vector 1 0 1 0.9)) 
        (pdata-map! (lambda (p)
            (vadd (vmul (srndvec) 0.003) p))
        "p"))))

(fog (vector 1 0 1) 0.4 1 1000)

(every-frame (x-light))
