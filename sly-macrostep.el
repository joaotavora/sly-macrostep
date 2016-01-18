;;; sly-macrostep.el --- Support named readtables in Common Lisp files  -*- lexical-binding: t; -*-
;;
;; Version: 0.1
;; URL: https://github.com/capitaomorte/sly-macrostep
;; Keywords: languages, lisp, sly
;; Package-Requires: ((sly "1.0.0-beta2"))
;; Author: João Távora <joaotavora@gmail.com>
;; 
;; Copyright (C) 2015 João Távora
;;
;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;; 
;; `sly-macrostep` is an external contrib for SLY that does nothing
;; special, but acts like a template for writing other external
;; contribs.
;;
;; See README.md
;; 
;;; Code:

(require 'sly)

(define-sly-contrib sly-macrostep
  "Define the `sly-macrostep' contrib.
Depends on the `slynk-macrostep' ASDF system Insinuates itself
in `sly-editing-mode-hook', i.e. lisp files."
  (:slynk-dependencies slynk-macrostep)
  (:on-load (add-hook 'sly-editing-mode-hook 'sly-macrostep-mode))
  (:on-unload (remove-hook 'sly-editing-mode-hook 'sly-macrostep-mode)))

(defvar sly-macrostep--last-reported-feature nil
  "Internal variable for world-helloing purposes")

(defun sly-macrostep ()
  "Interactive command made available in lisp-editing files."
  (interactive)
  (let ((results (sly-eval '(slynk-macrostep:macrostep))))
    (sly-message (first results))
    (setq-local sly-macrostep--last-reported-feature (second results))))

(define-minor-mode sly-macrostep-mode
  "A minor mode active when the contrib is active."
  nil nil nil
  (cond (sly-macrostep-mode
         (add-to-list 'sly-extra-mode-line-constructs
                      'sly-macrostep--mode-line-construct
                      t))
        (t
         (setq sly-extra-mode-line-constructs
               (delq 'sly-macrostep--mode-line-construct
                     sly-extra-mode-line-constructs)))))

(defvar sly-macrostep-map
  "A keymap accompanying `sly-macrostep-mode'."
  (let ((map (make-sparse-keymap)))
    (define-key sly-prefix-map (kbd "C-d C-w") 'sly-macrostep)
    map))

(defun sly-macrostep--mode-line-construct ()
  "A little pretty indicator in the mode-line"
  `(:propertize ,(cond (sly-macrostep--last-reported-feature
                        (symbol-name sly-macrostep--last-reported-feature))
                       (sly-macrostep-mode
                        "hello world")
                       (t
                        "-"))
                face hi-pink
                mouse-face mode-line-highlight
                help-echo ,(if sly-macrostep--last-reported-feature
                               (format "Last reported MACROSTEP feature %s"
                                       sly-macrostep--last-reported-feature)
                             "No MACROSTEP features reported so far")))

;;; Automatically add ourselves to `sly-contribs' when this file is loaded
;;;###autoload
(add-to-list 'sly-contribs 'sly-macrostep 'append)

(provide 'sly-macrostep)
;;; sly-macrostep.el ends here

