;; Financial Calculations

(defun /f (DIVIDEND &rest DIVISORS)
  "Returns first float-point DIVIDEND divided by all the remaining DIVISORS"
  (-reduce '/ (cons (+ DIVIDEND 0.0) DIVISORS)))

(defun interest (P R T)
  "Return the earned simple interest, P is the pricipal, R is the 
  interest rate, and T is times"
  (* P R T))

(defun future-value (P R T)
  "Returns the future value using simple interest. P is the principal, R is the
  interest rate, and T is the times"
  (* P (+ 1 (* R T))))

(defun future-value+ (P R T)
  "Returns the future value using compound interest. P is the principal, R is the
  interest rate, and T is the times"
  (* P (expt (+ 1 R) T)))

(defun interest+ (P R T)
  "Return the earned compound interest, P is the pricipal, R is the
  interest rate, and T is times"
  (- (future-value+ P R T) P))

(defun present-value (F R T)
  "Returns the present value using simple interest. F is the future value, R is 
  the interest rate, and T is the times"
  (/f F (+ 1 (* R T))))

(defun present-value+ (F R T)
  "Returns the present value using compound interest. F is the future value, R is
  the interest rate, and T is the times"
  (/f F (expt (+ 1 R) T)))

(defun times (F P R)
  "Returns the times using simple interest. F is the future value, P is the 
  principal, and R is the interest rate"
  (/f (- (/f F P) 1) R))

(defun times+ (F P R)
  "Returns the times using compound interest. F is the future value, P is the
  principal, and R is the interest rate"
  (/f (log (/f F P)) (log (+ 1 R))))

(defun rate (F P T)
  "Returns the simple interest rate. F is the future value, P is the principal,
  and T is times"
  (/f (- (/f F P) 1) T))

(defun rate+ (F P T)
  "Returns the compound interest rate. F is the future value, P is the principal,
  and T is times"
  (- (expt (/f F P) (/f 1 T)) 1))

