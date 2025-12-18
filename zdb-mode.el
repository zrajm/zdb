;;; zdb-mode.el --- Emacs major mode for ZDB text database files
;;; -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright 2025 zrajm, Uppsala, Sweden

;; Author: zrajm <zdb AT klingonska.org>
;; Version: 1.0
;; Maintainer: zrajm
;; Package-Requires: ((emacs "24.1"))
;; URL: https://zrajm.org/zdb
;; Repository: https://github.com/zrajm/zdb
;; Created: December 2025
;; License: GNU General Public License Version 2
;; Distribution: This file is not part of Emacs

(defun zdb--mark-multiline ()
  "Mark the current match as a multi-line font-lock region."
  (let ((start (match-beginning 0))
        (end   (match-end 0)))
    (put-text-property start end 'font-lock-multiline t)
    nil))  ;; return nil so font-lock still applies faces

(defvar zdb-font-lock-keywords
  `(
    ;; Comments
    ("^\\(#\\)\\(.*\\)$"
     (1 font-lock-comment-delimiter-face)
     (2 font-lock-comment-face))
    ;; Field names + multi-line values
    ("^\\([_a-zA-Z%][_a-zA-Z0-9]*\\)\\(\\(\\(?:[ \t].*\\)?\n\\)+\\)"
     ;; Field name face
     (1 (if (eq (aref (match-string 1) 0) ?%)
            font-lock-keyword-face         ; starts with '%'
          font-lock-function-name-face))   ; starts with other char
     ;; Entire multi-line field value
     (2 font-lock-string-face)
     ;; Mark whole block as multiline
     (0 (zdb--mark-multiline)))
    ;; Syntax errors
    ("^.*$" . 'font-lock-warning-face)
    ))

;;;###autoload
(define-derived-mode zdb-mode fundamental-mode "ZDB"
  "Major mode for editing ZDB database files."
  (setq-local font-lock-defaults '(zdb-font-lock-keywords))
  (modify-syntax-entry ?# "<")                 ; comment start char '#'
  (modify-syntax-entry ?\n ">")                ; comment end '\n'
  (modify-syntax-entry ?\" ".")                ; double quotes are non-special
  (setq-local comment-start "#")
  (setq-local comment-start-skip "#+\\s-*"))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.zdb\\'" . zdb-mode))

(provide 'zdb-mode)
;;[eof]
