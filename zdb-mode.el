;;; zdb-mode.el --- Emacs major mode for ZDB text database files
;;; -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright 2025 zrajm, Uppsala, Sweden

;; Author: zrajm <zdb AT klingonska.org>
;; Version: 1.1
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

(defconst zdb--field-header-re
  "^\\([_a-zA-Z%][_a-zA-Z0-9]*\\)\\([ \t]+\\)"
  "Regexp matching a ZDB field header line (name + separator).")

(defun zdb-fill-paragraph (&optional justify)
  "Rewrap only the current field's value, preserving the field's separator.
Respects blank lines and stops at the next field or comment.
Handles tabs correctly and wraps the first line with the same right margin
as subsequent lines."
  (save-excursion
    (let (sep region-start region-end)
      ;; Find the header and separator for the current field, even from a continuation line.
      (beginning-of-line)
      (cond
       ;; On a header line
       ((looking-at zdb--field-header-re)
        (setq sep (match-string 2))
        (setq region-start (match-end 2)))
       ;; On a continuation line: walk up to header
       (t
        (let ((found nil))
          (while (and (not (bobp)) (not found))
            (forward-line -1)
            (beginning-of-line)
            (when (looking-at zdb--field-header-re)
              (setq sep (match-string 2))
              (setq region-start (match-end 2))
              (setq found t)))
          (unless found (setq sep nil)))))
      (when sep
        ;; Determine region end: stop at next header, comment, or EOF.
        (save-excursion
          (goto-char region-start)
          (let ((sep-re (concat "^" (regexp-quote sep)))
                (blank-re "^[ \t]*$")
                (stop nil))
            (while (and (not (eobp)) (not stop))
              (forward-line 1)
              (beginning-of-line)
              (cond
               ((or (looking-at zdb--field-header-re)
                    (looking-at "^#"))
                (setq stop t))
               ;; Continuation line starts with the exact separator
               ((looking-at sep-re))
               ;; True blank line (no content)
               ((looking-at blank-re))
               (t (setq stop t))))
            (setq region-end (point))))
        ;; Fill with tab-aware, correct first-line width:
        ;; We temporarily insert SEP at the start of the first value line,
        ;; so Emacs treats the first line with the same left margin as continuations.
        ;; After filling, we remove that inserted SEP.
        (let ((fill-prefix sep)
              (first-prefix-added nil))
          (save-restriction
            (narrow-to-region region-start region-end)
            (save-excursion
              (goto-char (point-min))
              (unless (looking-at (concat "^" (regexp-quote sep)))
                (insert sep)
                (setq first-prefix-added t)))
            ;; Let Emacs handle paragraph splitting; tabs in SEP are respected by fill-prefix.
            (fill-region (point-min) (point-max) justify)
            ;; Remove the temporarily added SEP from the first line, restoring original layout.
            (when first-prefix-added
              (save-excursion
                (goto-char (point-min))
                (delete-region (point) (+ (point) (length sep)))))
            t))))))

;;;###autoload
(define-derived-mode zdb-mode fundamental-mode "ZDB"
  "Major mode for editing ZDB database files."
  (setq-local font-lock-defaults '(zdb-font-lock-keywords))
  (modify-syntax-entry ?# "<")                 ; comment start char '#'
  (modify-syntax-entry ?\n ">")                ; comment end '\n'
  (modify-syntax-entry ?\" ".")                ; double quotes are non-special
  (setq-local comment-start "#")
  (setq-local comment-start-skip "#+\\s-*")
  ;; Use our custom paragraph filler for M-q.
  (setq-local fill-paragraph-function #'zdb-fill-paragraph))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.zdb\\'" . zdb-mode))

(provide 'zdb-mode)
;;[eof]
