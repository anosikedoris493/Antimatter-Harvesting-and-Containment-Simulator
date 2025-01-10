;; Energy Conversion Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))

;; Data Variables
(define-data-var conversion-rate uint u1000000) ;; 1 unit of antimatter = 1,000,000 units of energy
(define-data-var total-energy-produced uint u0)

;; Public Functions
(define-public (set-conversion-rate (new-rate uint))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (> new-rate u0) err-invalid-parameters)
        (var-set conversion-rate new-rate)
        (ok true)
    )
)

(define-public (convert-antimatter (amount uint))
    (let ((energy-produced (* amount (var-get conversion-rate))))
        (var-set total-energy-produced (+ (var-get total-energy-produced) energy-produced))
        (ok energy-produced)
    )
)

;; Read-only Functions
(define-read-only (get-conversion-rate)
    (var-get conversion-rate)
)

(define-read-only (get-total-energy-produced)
    (var-get total-energy-produced)
)

