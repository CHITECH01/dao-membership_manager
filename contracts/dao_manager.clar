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
