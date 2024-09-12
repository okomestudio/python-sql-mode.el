;;; python-sql-mode.el --- python-sql-mode  -*- lexical-binding: t -*-
;;
;; Copyright (C) 2024 Taro Sato
;;
;; Author: Taro Sato <okomestudio@gmail.com>
;; URL: https://github.com/okomestudio/python-sql-mode.el
;; Version: 0.2
;; Keywords:
;; Package-Requires: ((emacs "29.1"))
;;
;;; License:
;;
;; This program is free software; you can redistribute it and/or modify
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
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; Python-SQL polymode.
;;
;; This mode interprets in-line code in string as SQL when it is (1)
;; triple quoted (""") and (2) either the variable starts with the
;; prefix "sql" or the string starts with the SQL comment "-- sql".
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
