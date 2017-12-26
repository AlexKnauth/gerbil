;;; -*- Gerbil -*-
;;; (C) vyzo at hackzen.org
;;; socket server api
package: std/net/server

(import (only-in :gerbil/gambit/threads spawn/group thread-join!)
        (only-in :gerbil/gambit/os time? seconds->time)
        :std/net/server/base
        :std/net/server/basic-server
        :std/os/socket
        :std/os/fd
        :std/os/error
        :std/net/address
        :std/sugar
        :std/error
        :std/logger
        )
(export start-socket-server! stop-socket-server! current-socket-server
        native-poll-server-impl
        server-shutdown!
        server-connect
        server-listen server-accept
        server-send server-send-all
        server-recv server-recv-all
        server-socket-e
        server-close server-close-input server-close-output
        )

(cond-expand
  (linux
   (import :std/net/server/epoll-server)))

(def current-socket-server
  (make-parameter #f))

(def (native-poll-server-impl)
  (cond-expand
    (linux epoll-socket-server)
    (else basic-socket-server)))

(def default-listen-sockopts
  (if (not (fxnegative? SO_REUSEADDR))
    [SO_REUSEADDR]
    []))

;; start a server
(def (start-socket-server! (impl basic-socket-server))
  (cond
   ((current-socket-server) => values)
   (else
    (start-logger!)
    (let (srv (spawn/group 'socket-server impl))
      (current-socket-server srv)
      srv))))

(def (stop-socket-server! (srv (current-socket-server)))
  (server-shutdown! srv))

(def (server-shutdown! srv)
  (!!socket-server.shutdown! srv)
  (thread-join! srv))

(defrules with-error-close ()
  ((_ sock body ...)
   (try body ...
        (catch (e)
          (socket-close sock)
          (raise e)))))

;; => !socket that is connected and ready
(def (server-connect srv addr (timeo #f))
  (let* ((sa (socket-address addr))
         (sock (socket (socket-address-family sa) SOCK_STREAM))
         (rcon (with-error-close sock
                 (socket-connect sock sa)))
         (ssock (!!socket-server.add srv sock)))
    (with ((!socket _ _ _ wait-out close) ssock)
      (unless rcon
        (unless (wait-out ssock (abs-timeout timeo))
          (close ssock 'inout #f)
          (raise-timeout 'server-connect "connect timeout" addr)))
      (let (errno (or rcon (socket-getsockopt sock SOL_SOCKET SO_ERROR)))
        (if (fxzero? errno)
          ssock
          (begin
            (close ssock 'inout #f)
            (raise-os-error errno server-connect srv addr timeo)))))))

;; => !socket that is bound and listening
(def (server-listen srv addr (backlog 10) (opts default-listen-sockopts))
  (let* ((sa (socket-address addr))
         (sock (server-socket (socket-address-family sa) SOCK_STREAM)))
    (with-error-close sock
      (for-each (cut socket-setsockopt sock SOL_SOCKET <> 1)
                opts)
      (socket-bind sock sa)
      (socket-listen sock backlog)
      (!!socket-server.add srv sock))))

;; => !socket
(def (server-accept ssock (sa #f) (timeo #f))
  (with ((!socket sock srv) ssock)
    (let (timeo (abs-timeout timeo))
      (let lp ()
        (let (wait-in (!socket-wait-in ssock))
          (if wait-in
            (let (cli (socket-accept sock sa))
              (if cli
                (!!socket-server.add srv cli)
                (if (wait-in ssock timeo)
                  (lp)
                  (raise-timeout 'server-accept "accept timeout" ssock))))
            (raise-io-error 'server-accept "Socket is not open for input" ssock)))))))

;; => count
(def (server-send ssock buf (start 0) (end (u8vector-length buf)) (timeo #f))
  (with ((!socket sock) ssock)
    (let (timeo (abs-timeout timeo))
      (let lp ()
        (let (wait-out (!socket-wait-out ssock))
          (if wait-out
            (let (r (socket-send sock buf start end))
              (or r
                  (if (wait-out ssock timeo)
                    (lp)
                    (raise-timeout 'server-send "send timeout" ssock))))
            (raise-io-error 'server-send "Socket is not open for output" ssock)))))))

;; => count
(def (server-send-all ssock buf (start 0) (end (u8vector-length buf)) (timeo #f))
  (with ((!socket sock) ssock)
    (let (timeo (abs-timeout timeo))
      (let lp ((count 0) (start start))
        (let (wait-out (!socket-wait-out ssock))
          (if wait-out
            (if (fx< start end)
              (let (r (socket-send sock buf start end))
                (cond
                 (r (lp (fx+ count r) (fx+ start r)))
                 ((wait-out ssock timeo)
                  (lp count start))
                 (else
                  (raise-timeout 'server-send-all "send timeout" ssock))))
              count)
            (raise-io-error 'server-send-all "Socket is not open for output" ssock)))))))

;; => count
(def (server-recv ssock buf (start 0) (end (u8vector-length buf)) (timeo #f))
  (with ((!socket sock) ssock)
    (let (timeo (abs-timeout timeo))
      (let lp ()
        (let (wait-in (!socket-wait-in ssock))
          (if wait-in
            (let (r (socket-recv sock buf start end))
              (or r
                  (if (wait-in ssock timeo)
                    (lp)
                    (raise-timeout 'server-recv "receive timeout" ssock))))
            (raise-io-error 'server-recv "Socket is not open for input" ssock)))))))

;; => count
(def (server-recv-all ssock buf (start 0) (end (u8vector-length buf)) (timeo #f))
  (with ((!socket sock) ssock)
    (let (timeo (abs-timeout timeo))
      (let lp ((count 0) (start start))
        (let (wait-in (!socket-wait-in ssock))
          (if wait-in
            (if (fx>= start end)
              count
              (let (r (socket-recv sock buf start end))
                (cond
                 ((not r)
                  (if (wait-in ssock timeo)
                    (lp count start)
                    (raise-timeout 'server-recv-all "receive timeout" ssock)))
                 ((fxzero? r)
                  count)
                 (else
                  (lp (fx+ count r) (fx+ start r))))))
            (raise-io-error 'server-recv-all "Socket is not open for input" ssock)))))))

;; retrieve the socket in a server socket
(def (server-socket-e ssock)
  (!socket-e ssock))

;; close an ssock
(def (server-close ssock)
  ((!socket-close ssock) ssock 'inout #f))

;; close input side of an ssock
(def (server-close-input ssock (shutdown #f))
  ((!socket-close ssock) ssock 'in (and shutdown SHUT_RD)))

;; close output side of an ssock
(def (server-close-output ssock (shutdown #f))
  ((!socket-close ssock) ssock 'out (and shutdown SHUT_WR)))

;; with-destroy
(defmethod {destroy !socket}
  server-close)

;; utils
(def (abs-timeout timeo)
  (cond
   ((or (not timeo) (time? timeo))
    timeo)
   ((real? timeo)
    (seconds->time (+ (##current-time-point) timeo)))
   (else
    (error "Bad timeout; expected real, time or #f" timeo))))
