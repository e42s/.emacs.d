;;;;
;; sbcl
;;;;

;; sbcl path
(platform-supported-p
 windows-nt
 (let* ((home (getenv "SBCL_HOME"))
        (path (windows-nt-path
               (file-name-directory
                (if home home (bin-path "sbcl"))))))
   (add-to-list 'exec-path path)
   (safe-setq-inferior-lisp-program "sbcl" t)))


(platform-supported-unless
 windows-nt
 (safe-setq-inferior-lisp-program (bin-path "sbcl") t))


;; setup sbcl, it's slow process so be adviced
(defadvice slime (before slime-before compile)
  (add-hook
   'slime-repl-mode-hook
   (lambda ()
     (safe-do slime-close-all-parens-in-sexp
              (local-set-key (kbd "C-c C-]")
                             'slime-close-all-parens-in-sexp))
     (safe-do slime-selector 
              (global-set-key (kbd "C-c s")
                              'slime-selector))))
  (slime-setup '(slime-fancy slime-asdf)))









