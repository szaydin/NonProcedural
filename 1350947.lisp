; Sumeyye Aydin 1350947
; CMPUT 325 
; Assignment # 2

;Run interpreter.
;E is Expression
;P is Program

(defun fl-interp (E P)
  (cond 
	((atom E) E)   %this includes the case where E is nil or a number
        (t
           (let ( (f (car E))  (arg (cdr E)) )
	      (cond 
                ; handle built-in functions
                ; Primitive functions
                ((eq f 'if) (if (fl-interp (car arg) P) (fl-interp (cadr arg) P) (fl-interp (caddr arg) P))) ;three arguments
                ((eq f 'null)  (null (fl-interp (car arg) P))) ;one argument
                ((eq f 'atom)  (atom (fl-interp (car arg) P))) ;one argument
                ((eq f 'eq)  (eq (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f 'first)  (car (fl-interp (car arg) P))) ;one argument
                ((eq f 'rest)  (cdr (fl-interp (car arg) P))) ;one argument
                ((eq f 'cons)  (cons (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f 'equal)  (equal (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f 'isnumber)  (numberp (fl-interp (car arg) P))) ;one argument              
                ((eq f '+)  (+ (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f '-)  (- (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f '*)  (* (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f '>)  (> (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f '<)  (< (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f '=)  (= (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f 'and)  (and (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f 'or)  (or (fl-interp (car arg) P) (fl-interp (cadr arg) P))) ;two arguments
                ((eq f 'not)  (not (fl-interp (car arg) P))) ;one argument

	        ..... 

	        ; if f is a user-defined function,
                ;    then evaluate the arguments 
                ;         and apply f to the evaluated arguments 
                ;             (applicative order reduction) 
                .....
                ((user-defined f P)
                  (fl-interp (map_args (param (getP f P)) (arg_eval arg P) (get_main (getP f P))) P)
                )
                (T E)
            )
        )
    )
)


(defun user-defined (f P) ;checking if the user-defined or not
    (cond 
        ((null P) nil) ;handle if program is empty
        ((equal f (caar P)) car P) ;checks the name of P if they are equal or not
        ((null (cdr P)) nil) ;handle the end of the list
        (t (user-defined f (cdr P))) ;doing recursion and if user-defined returns to T, else nil
    )
)


(defun map_args (param arg main)  ;replacing the main part of the program with evaluated argument 
    (cond 
        ((eq para nil) main) ; checks if parameter is nil or not
        (t (map_args (cdr param) (cdr arg) (replace_main (car param) (car arg) main))) ;recursive call
    )
)
