#!/usr/bin/env swish

(define (echo:start&link ip op)
  (define (reader who)
    (let ([x (get-bytevector-some ip)])
      (unless (eof-object? x)
        (send who `#(echo ,x))
        (reader who))))
  (define (init)
    (let ([me self])
      (spawn&link
       (lambda ()
         (reader me))))
    `#(ok #f))
  (define (terminate reason state)
    (close-port op)
    'ok)
  (define (handle-call msg from state) (match msg))
  (define (handle-cast msg state) (match msg))
  (define (handle-info msg state)
    (match msg
      [#(echo ,bv)
       (put-bytevector op bv)
       (flush-output-port op)
       `#(no-reply ,state)]))
  (gen-server:start&link #f))

(define (echo-server:start&link)
  (define-state-tuple <echo-server> listener)
  (define (init)
    (let ([listener (listen-tcp "::" 5300 self)])
      (printf "Waiting for connection on port ~a\n"
        (listener-port-number listener))
      `#(ok
         ,(<echo-server> make
            [listener listener]))))
  (define (terminate reason state)
    (close-tcp-listener ($state listener))
    'ok)
  (define (handle-call msg from state) (match msg))
  (define (handle-cast msg state) (match msg))
  (define (handle-info msg state)
    (match msg
      [#(accept-tcp ,_ ,ip ,op)
       (printf "Handling new connection\n")
       (echo:start&link ip op)
       `#(no-reply ,state)]
      [#(accept-tcp-failed ,_ ,_ ,_)
       (printf "Good bye!\n")
       `#(stop ,msg ,state)]))
  (gen-server:start&link 'echo-server))

(echo-server:start&link)
(receive)
