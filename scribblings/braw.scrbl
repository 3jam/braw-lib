#lang scribble/manual

@(require scribble/racket
          (for-label racket/base
                     braw))

@title[#:version "0.1"]{@racketmodname[braw]}

@author[
@author+email["Jen Mojallali" "jam@z80.computer"]]

@defmodule[braw]

This module fascilitates swapping a tty in and out of raw mode, as well as sending and receiving characters

@defproc[(braw? [b any/c]) boolean?]{

Returns @racket[#t] if @racket[b] is a @racket[braw?] , @racket[#f] otherwise.}

@defproc[(braw-get) braw?]{

Returns terminal state as a @racket[braw?] .}

@defproc[(braw-start [b braw?]) void?]{

Enter raw mode using @racket[b] as a reference.}

@defproc[(braw-stop [b braw?]) void?]{

Exit raw mode using @racket[b] as a reference.}

@defproc[(braw-read [timeout @racket[number?]]) char?]{

Return the next @racket[char] sent by the terminal.
This procedure will block for @racket[timeout] seconds, or until it gets a character from the terminal.
When @racket[timeout] is less than 0, this procedure will block indefinitely until it gets a character.
}

@defproc[(braw-write [c char?]) void?]{

Send @racket[c] to the terminal.}

Usage:

@racketblock[
(require braw)

(define snapshop (braw-get))
(braw-start snapshot)
(braw-write (braw-read -1.0))
(braw-stop snapshot)

]
