;;; flymake-coffee.el --- A flymake handler for coffee script
;;
;;; Author: Steve Purcell <steve@sanityinc.com>
;;; Homepage: https://github.com/purcell/flymake-coffee
;;; Version: DEV
;;; Package-Requires: ((flymake-easy "0.1"))
;;
;;; Commentary:
;;
;; Based in part on http://d.hatena.ne.jp/antipop/20110508/1304838383
;;
;; Usage:
;;   (require 'flymake-coffee)
;;   (add-hook 'coffee-mode-hook 'flymake-coffee-load)
;;
;; Executes "coffeelint" if available, otherwise "coffee".
;;
;; Uses flymake-easy, from https://github.com/purcell/flymake-easy

;;; Code:

(require 'flymake-easy)
;; Doesn't strictly require coffee-mode, but will use 'coffee-command if set

(defcustom flymake-coffee-coffeelint-configuration-file nil
  "File that contains custom coffeelint configuration"
  :type 'string
  :group 'flymake-coffee)

(defconst flymake-coffee-err-line-patterns
  '(;; coffee
    ("^SyntaxError: In \\([^,]+\\), \\(.+\\) on line \\([0-9]+\\)" 1 3 nil 2)
    ;; coffeelint
    ("SyntaxError: \\(.*\\) on line \\([0-9]+\\)" nil 2 nil 1)
    ("\\(.+\\),\\([0-9]+\\),\\(\\(warn\\|error\\),.+\\)" 1 2 nil 3)))

(defun flymake-coffee-command (filename)
  "Construct a command that flymake can use to check coffeescript source."
  (if (executable-find "coffeelint")
      (if flymake-coffee-coffeelint-configuration-file
          (list "coffeelint" "-f" flymake-coffee-coffeelint-configuration-file "--csv" filename)
        (list "coffeelint" "--csv" filename))
    (list (if (boundp 'coffee-command) coffee-command "coffee")
          filename)))

;;;###autoload
(defun flymake-coffee-load ()
  "Configure flymake mode to check the current buffer's coffeescript syntax."
  (interactive)
  (flymake-easy-load 'flymake-coffee-command
                     flymake-coffee-err-line-patterns
                     'tempdir
                     "coffee"))


(provide 'flymake-coffee)
;;; flymake-coffee.el ends here
