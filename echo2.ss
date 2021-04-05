#!/usr/bin/env swish

(define listener (listen-tcp "::" 5300 self))

(printf "Waiting for connection on port ~a\n" (listener-port-number listener))
(let lp ()
  (receive
   [#(accept-tcp ,_ ,ip ,op)
    (printf "Handling new connection\n")
    (spawn&link
     (lambda ()
       (let process ()
         (let ([x (get-bytevector-some ip)])
           (unless (eof-object? x)
             (put-bytevector op x)
             (flush-output-port op)
             (process))))))
    (lp)]
   [#(accept-tcp-failed ,_ ,_ ,_)
    (printf "Good bye!\n")]))
