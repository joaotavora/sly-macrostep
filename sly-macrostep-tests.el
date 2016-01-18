(require 'sly)
(require 'sly-macrostep)
(require 'sly-tests "lib/sly-tests")

(define-sly-ert-test sly-macrostep-basic-test ()
  (with-temp-buffer
    (lisp-mode)
    (should sly-macrostep-mode)
    (should-not sly-macrostep--last-reported-feature)
    (sly-macrostep)
    (should sly-macrostep--last-reported-feature)
    (should (keywordp sly-macrostep--last-reported-feature))))
