;; Containment Protocol Management Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-parameters (err u101))

;; Data Variables
(define-data-var protocol-counter uint u0)
(define-map containment-protocols uint {
    name: (string-ascii 50),
    safety-rating: uint,
    capacity: uint,
    in-use: bool
})

;; Public Functions
(define-public (create-protocol (name (string-ascii 50)) (safety-rating uint) (capacity uint))
    (let ((protocol-id (+ (var-get protocol-counter) u1)))
        (asserts! (and (> safety-rating u0) (<= safety-rating u100) (> capacity u0)) err-invalid-parameters)
        (map-set containment-protocols protocol-id {
            name: name,
            safety-rating: safety-rating,
            capacity: capacity,
            in-use: false
        })
        (var-set protocol-counter protocol-id)
        (ok protocol-id)
    )
)

(define-public (update-protocol (protocol-id uint) (new-safety-rating uint) (new-capacity uint))
    (let ((protocol (unwrap! (map-get? containment-protocols protocol-id) err-invalid-parameters)))
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (asserts! (and (> new-safety-rating u0) (<= new-safety-rating u100) (> new-capacity u0)) err-invalid-parameters)
        (map-set containment-protocols protocol-id (merge protocol {
            safety-rating: new-safety-rating,
            capacity: new-capacity
        }))
        (ok true)
    )
)

(define-public (toggle-protocol-usage (protocol-id uint))
    (let ((protocol (unwrap! (map-get? containment-protocols protocol-id) err-invalid-parameters)))
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)
        (map-set containment-protocols protocol-id (merge protocol {
            in-use: (not (get in-use protocol))
        }))
        (ok true)
    )
)

;; Read-only Functions
(define-read-only (get-protocol (protocol-id uint))
    (map-get? containment-protocols protocol-id)
)

(define-read-only (get-total-protocols)
    (var-get protocol-counter)
)

