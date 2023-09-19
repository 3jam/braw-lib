;;;; ------------------------------------------------------------ ;;;;
;;;; Use this simple library to put a unix terminal in raw mode,
;;;; restore the terminal to its original settings, and read and
;;;; write characters to/from the terminal --
;;;;
;;;;     (define snapshot (braw-get))
;;;;     (braw-start snapshot)
;;;;     (braw-write (braw-read -1.0))
;;;;     (braw-stop snapshot)
;;;;
;;;; ------------------------------------------------------------ ;;;;

#lang racket
(require ffi/unsafe
         ffi/unsafe/define)

(provide braw?
         braw-get
         braw-start
         braw-stop
         braw-read
         braw-write)

(define (handle-return value function-name)
  (unless (zero? value)
    (error function-name "failed: ~a" value)))

(define (handle-timeout value character function-name)
  (cond ((zero? value) character)
        ((= value 1) '())
        (error function-name "failed: ~a" value)))

(define-ffi-definer define-braw (ffi-lib "libbraw" '("0.1" #f)))

;; opaque type from the C library
(define _braw_t-pointer (_cpointer 'braw_t))

(define (braw? b)
  (cpointer-has-tag? b 'braw_t))

;; the ffi implementation will catch if malloc() returns NULL,
;; so no need to manually check for that here
(define-braw
  braw_create
  (_fun -> _braw_t-pointer))

(define-braw
  braw_get_terminal_state
  (_fun _braw_t-pointer
        -> (r : _int)
        -> (handle-return r 'braw_get_terminal_state)))

(define-braw
  braw_enable_raw_mode
  (_fun _braw_t-pointer
        -> (r : _int)
        -> (handle-return r 'braw_enable_raw_mode)))

(define-braw
  braw_disable_raw_mode
  (_fun _braw_t-pointer
        -> (r : _int)
        -> (handle-return r 'braw_disable_raw_mode)))

(define-braw
  braw_get_char
  (_fun (o : (_ptr o _ubyte)) _double
        -> (r : _int)
        -> (handle-timeout r o 'braw_get_char)))

(define-braw
  braw_put_char
  (_fun _ubyte -> (r : _int)
               -> (handle-return r 'braw_put_char)))

;; ---------------------------------------------------------------- ;;

;; make a snapshot of the current terminal state
(define (braw-get)
  (let ((braw-t (braw_create)))
    (braw_get_terminal_state braw-t)
    braw-t))

;; enter raw mode using snapshot as reference
(define (braw-start braw-t)
  (braw_enable_raw_mode braw-t))

;; exit raw mode using snapshot as reference
(define (braw-stop braw-t)
  (braw_disable_raw_mode braw-t))

;; read a character sent from the terminal
(define (braw-read timeout)
  (let ((time (if (exact? timeout)
                (exact->inexact timeout)
                timeout)))
    (let ((char (braw_get_char time)))
      (if (null? char)
        #\null
        (integer->char char)))))

;; send a character to the terminal
(define (braw-write char) (braw_put_char (char->integer char)))
