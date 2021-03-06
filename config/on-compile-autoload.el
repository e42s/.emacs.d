;;;; -*- lexical-binding:t -*-
;;;;
;; More reasonable Emacs on MacOS, Windows and Linux
;; https://github.com/junjiemars/.emacs.d
;;;;
;; on-compile-autoload.el
;;;;


(platform-supported-when windows-nt
  ;; There are no builtin `grep' in Windows, GNU's `grep' may be use
	;; the POSIX path in Windows which cannot be recognized by Emacs.
	;; When such case occurred, we try to translate POSIX path to Windows path.
	(defadvice compilation-find-file (before compilation-find-file-before compile)
		(ad-set-arg
		 1 ;; filename argument
		 (let ((filename (ad-get-arg 1)))
			 (if (string-match "^/\\([a-zA-Z]\\)/" filename)
					 (replace-match
						(concat (match-string 1 filename) ":/") t t filename)
				 (ad-get-arg 1))))))


(with-eval-after-load 'compile
	
	(platform-supported-when windows-nt
		;; compile and activate `compilation-find-file' advice on Windows
		(ad-activate #'compilation-find-file t))
	
	(add-hook 'compilation-filter-hook #'colorize-compilation-buffer!)
	(define-key* compilation-mode-map (kbd "g") #'recompile compile)
	(define-key* compilation-mode-map (kbd "q") #'quit-window compile)
	(setq% compilation-scroll-output t compile))

