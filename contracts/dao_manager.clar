;; Contract Name: DAO Membership Manager
;; Purpose: Manage memberships in a Decentralized Autonomous Organization (DAO). 
;; Provides functionalities for adding/removing members, 
;; setting limits, and querying membership status.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants and Error Codes ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Contract administrator (defaulted to the transaction sender during initialization)
(define-constant CONTRACT_ADMIN tx-sender)

;; Error codes for various operations
(define-constant ERR_NOT_ADMIN (err u200))                   ;; Caller is not the admin
(define-constant ERR_ALREADY_MEMBER (err u201))             ;; User is already a member
(define-constant ERR_NOT_MEMBER (err u202))                 ;; User is not a member
(define-constant ERR_MEMBER_LIMIT_REACHED (err u203))       ;; Member limit has been reached
(define-constant ERR_INVALID_USER (err u204))               ;; Invalid user provided
(define-constant ERR_INVALID_LIMIT (err u205))              ;; Invalid membership limit provided

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Data Variables           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Current number of DAO members
(define-data-var current-member-count uint u0)

;; Maximum allowable DAO members
(define-data-var max-member-limit uint u100)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Data Structures (Maps)    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mapping to track active DAO members (true = member, false = not a member)
(define-map MEMBERSHIP_REGISTRY principal bool)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Private Utility Functions ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Check if a user is an active DAO member
(define-private (is-active-member (user principal))
    (default-to false (map-get? MEMBERSHIP_REGISTRY user)))

;; Internal helper to add a member to the DAO
(define-private (add-member (new-member principal))
    (begin
        ;; Ensure the user is not already a member
        (asserts! (not (is-active-member new-member)) ERR_ALREADY_MEMBER)
        ;; Ensure the member limit is not exceeded
        (asserts! (< (var-get current-member-count) (var-get max-member-limit)) ERR_MEMBER_LIMIT_REACHED)
        ;; Add the member and increment the member count
        (map-set MEMBERSHIP_REGISTRY new-member true)
        (var-set current-member-count (+ (var-get current-member-count) u1))
        (ok true)))

;; Internal helper to remove a member from the DAO
(define-private (remove-member (member principal))
    (begin
        ;; Ensure the user is currently a member
        (asserts! (is-active-member member) ERR_NOT_MEMBER)
        ;; Remove the member and decrement the member count
        (map-set MEMBERSHIP_REGISTRY member false)
        (var-set current-member-count (- (var-get current-member-count) u1))
        (ok true)))

;; Get the current total number of DAO members
(define-private (fetch-member-count)
    (ok (var-get current-member-count)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Public Functions          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Validate input before using in add-dao-member
(define-public (add-dao-member (new-member principal))
    (begin
        ;; Ensure the provided input is valid (e.g., not null or the admin itself)
        (asserts! (not (is-eq new-member tx-sender)) ERR_INVALID_USER)
        ;; Validate the caller is the admin
        (asserts! (is-eq tx-sender CONTRACT_ADMIN) ERR_NOT_ADMIN)
        ;; Use helper function to add the member
        (add-member new-member)))

;; Validate input before using in remove-dao-member
(define-public (remove-dao-member (member principal))
    (begin
        ;; Ensure the provided input is valid (e.g., not null or the admin itself)
        (asserts! (not (is-eq member tx-sender)) ERR_INVALID_USER)
        ;; Validate the caller is the admin
        (asserts! (is-eq tx-sender CONTRACT_ADMIN) ERR_NOT_ADMIN)
        ;; Use helper function to remove the member
        (remove-member member)))