;;; -*- Gerbil -*-
;;; (C) vyzo at hackzen.org
;;; socket server -- basic server implementation
package: std/net/server

(import :gerbil/gambit/threads
        :gerbil/gambit/ports
        :gerbil/gambit/misc
        :gerbil/gambit/os
        :std/net/server/base
        :std/net/server/server
        :std/os/fd)

(export basic-socket-server)

(def (basic-socket-server)
  (def socks (make-hash-table-eq))

  (def (wait-io! io timeo)
    (##wait-for-io! io (if timeo (time->seconds timeo) #t)))

  (def (add-socket sock)
    (let* ((io-in (fd-io-in sock))
           (wait-in
            (and io-in
                 (lambda (ssock timeo)
                   (wait-io! io-in timeo))))
           (io-out (fd-io-out sock))
           (wait-out
            (and io-out
                 (lambda (ssock timeo)
                   (wait-io! io-out timeo))))
           (close
            (lambda (ssock dir shutdown)
              (!!socket-server.close (!socket-srv ssock) ssock dir shutdown)))
           (ssock
            (make-!socket sock (current-thread) wait-in wait-out close))
           (state
            (make-!socket-state sock io-in io-out)))
      (hash-put! socks sock state)
      (make-will ssock (cut close <> 'inout #f))
      ssock))

  (def (close-socket ssock dir shutdown)
    (def (close-io-in! sock)
      (if shutdown
        (shutdown-socket! sock shutdown)
        (close-input-port sock)))

    (def (close-io-out! sock)
      (if shutdown
        (shutdown-socket! sock shutdown)
        (close-output-port sock)))

    (with ((!socket sock _ wait-in wait-out) ssock)
      (when (or wait-in wait-out)
        (let (state (hash-get socks sock))
          (match state
            ((!socket-state _ io-in io-out)
             (case dir
               ((in)
                (set! (!socket-wait-in ssock) #f)
                (set! (!socket-state-io-in state) #f)
                (close-io-in! sock)
                (unless io-out
                  (hash-remove! socks sock)
                  (close-port sock)))
               ((out)
                (set! (!socket-wait-out ssock) #f)
                (set! (!socket-state-io-out state) #f)
                (close-io-out! sock)
                (unless io-in
                  (hash-remove! socks sock)
                  (close-port sock)))
               ((inout)
                (hash-remove! socks sock)
                (when io-in
                  (set! (!socket-wait-in ssock) #f)
                  (set! (!socket-state-io-in state) #f)
                  (close-io-in! sock))
                (when io-out
                  (set! (!socket-wait-out ssock) #f)
                  (set! (!socket-state-io-out state) #f)
                  (close-io-out! sock))
                (close-port sock))
               (else
                (error "Bad direction" dir))))
            (else (void)))))))

  (def (shutdown!)
    (for-each close-port (hash-keys socks))
    ;; release refs to raw devices
    (set! socks #f))

  (server-loop #f void add-socket close-socket shutdown!))
