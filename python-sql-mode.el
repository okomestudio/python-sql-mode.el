;;; python-sql-mode.el --- python-sql-mode  -*- lexical-binding: t -*-
;;; Commentary:
;;
;; Python-SQL polymode.
;;
;;; Code:

(require 'polymode)
(require 'python)
(require 'sql)

(define-hostmode python-sql-hostmode
  :mode 'python-mode)

(define-hostmode python-sql-ts-hostmode
  :mode 'python-ts-mode)

(define-innermode python-sql-innermode
  :mode 'sql-mode
  :head-matcher "\\(sql[[:alnum:]_]*[[:blank:]]?=[[:blank:]]?\"\\{3\\}\\|\"\\{3\\}--[[:blank:]]*\\(sql\\|SQL\\)\\)"
  :tail-matcher "\"\\{3\\}"
  :head-mode 'host
  :tail-mode 'host)

(defun python-sql-mode--eval-chunk (beg end msg)
  "Call out to `sql-send-region' with the polymode chunk region."
  (sql-send-region beg end))

;;;###autoload (autoload 'python-sql-mode "python-sql-mode")
(define-polymode python-sql-base-mode)

;;;###autoload (autoload 'python-sql-mode "python-sql-mode")
(define-polymode python-sql-mode python-sql-base-mode
  :hostmode 'python-sql-hostmode
  :innermodes '(python-sql-innermode)

  (setq polymode-eval-region-function #'python-sql-mode--eval-chunk)
  (define-key python-sql-mode-map
              (kbd "C-c C-c") 'polymode-eval-chunk))

;;;###autoload (autoload 'python-sql-mode "python-sql-mode")
(define-polymode python-sql-ts-mode python-sql-base-mode
  :hostmode 'python-sql-ts-hostmode
  :innermodes '(python-sql-innermode)

  (setq polymode-eval-region-function #'python-sql-mode--eval-chunk)
  (define-key python-sql-ts-mode-map
              (kbd "C-c C-c") 'polymode-eval-chunk))

(provide 'python-sql-mode)
;;; python-sql-mode.el ends here
