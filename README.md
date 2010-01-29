Just for exploratory fun, I decided to see what it takes to write a prototypical
object system in Lisp. Apparently its not much, I'm far from an experienced
Lisper (barely fluent, if that) and I got it done in ~50 lines. A testament to
Lisp's flexibility and expressiveness.

    CL-USER> (load "/home/fitzgen/dev/protolith/protolith.lisp")
    T
    CL-USER> (in-package :protolith)
    #<PACKAGE "PROTOLITH">
    PROTOLITH> (defobj account ()
                 (bal 0)
                 (deposit (lambda (self x)
                            (funcall self 'set 'bal (+ (funcall self 'bal)
                                                       x)))))
    ACCOUNT
    PROTOLITH> (account 'bal)
    0
    PROTOLITH> (account 'deposit 50)
    50
    PROTOLITH> (account 'bal)
    50
    PROTOLITH> (defobj checking-account (account)
                 (withdraw (lambda (self x)
                             (progn
                               (funcall self 'set 'bal (- (funcall self 'bal)
                                                          x))
                               x))))
    CHECKING-ACCOUNT
    PROTOLITH> (checking-account 'bal)
    50
    PROTOLITH> (checking-account 'withdraw 10)
    10
    PROTOLITH> (checking-account 'withdraw 10)
    10
    PROTOLITH> (checking-account 'bal)
    30
    PROTOLITH> (checking-account 'proto)
    #<CLOSURE ACCOUNT>

