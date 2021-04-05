#!/usr/bin/env swish

(define listener (listen-tcp "::" 5300 self))

(printf "Waiting for connection on port ~a\n" (listener-port-number listener))
(receive
 [#(accept-tcp ,_ ,ip ,op)
  (printf "Handling new connection\n")
  (put-bytevector op (string->utf8 "echo\n"))
  (flush-output-port op)
  (close-port op)]
 [#(accept-tcp-failed ,_ ,_ ,_)
  (printf "Good bye!\n")])

(exit)
