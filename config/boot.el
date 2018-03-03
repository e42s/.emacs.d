;;;; -*- lexical-binding:t -*-
;;;;
;; boot
;;;;



;; Disable menu bar
(safe-call menu-bar-mode -1)

;; Disable tool bar
(graphic-supported-p (safe-call tool-bar-mode -1))

;; Disable scroll bar
(safe-call scroll-bar-mode -1)

;; Go straight to scratch buffer on startup
(version-supported-when
    <= 24
  (setq inhibit-splash-screen t))





;; Theme and Font

(defmacro theme-supported-p (&rest body)
  (declare (indent 1))
  `(graphic-supported-p
     (version-supported-when
         < 23
       ,@body)))


(defmacro font-supported-p (&rest body)
  (declare (indent 1))
  `(graphic-supported-p
     ,@body))


(font-supported-p
    
    (defmacro font-exists-p (font)
      "Return t if FONT exists."
      `(when (find-font (font-spec :name ,font))
         t)))

(font-supported-p
    
    (defmacro self-default-font! (font)
      "Set default FONT in graphic mode."
      `(when (font-exists-p ,font)
         (add-to-list 'default-frame-alist (cons 'font ,font))
         (set-face-attribute 'default t :font ,font)
         (set-face-attribute 'default nil :font ,font)
         (version-supported-if <= 24.0
                               (set-frame-font ,font nil t)
           (set-frame-font ,font)))))

(font-supported-p
    
    ;; Load default font
    (self-safe-call
     "env-spec"
     (when (self-spec->* :font :allowed)
       (self-default-font! (self-spec->* :font :name)))))

(font-supported-p

    (defmacro self-cjk-font! (name size)
      "Set CJK font's NAME and SIZE in graphic mode."
      `(when (font-exists-p ,name)
         (safe-fn-when set-fontset-font
           (dolist (c '(han kana cjk-misc))
             (set-fontset-font (frame-parameter nil 'font)
                               c (font-spec :family ,name
                                            :size ,size)))))))

(font-supported-p
    
    ;; Load cjk font
    (self-safe-call
     "env-spec"
     (when (self-spec->* :cjk-font :allowed)
       (self-cjk-font! (self-spec->* :cjk-font :name)
                       (self-spec->* :cjk-font :size)))))

;; End of font-supported-p

(theme-supported-p
    
    (defmacro self-load-theme! (name &optional dir)
      "Load theme from theme DIR by theme NAME.

If theme DIR is nil then load the named built-in theme, 
else if theme NAME non-existing then load default `theme/tomorrow-night-eighties'."
      `(progn
         (when (and ,dir (file-exists-p ,dir))
           (add-to-list 'custom-theme-load-path ,dir)
           (add-to-list 'load-path ,dir t #'string=))
         (version-supported-if >= 24.1
                               (load-theme ,name)
           (load-theme ,name t)))))


;; Load theme
(theme-supported-p
    
    (self-safe-call
     "env-spec"
     (when (self-spec->* :theme :allowed)
       (self-load-theme! (self-spec->* :theme :name)
                         (self-spec->* :theme :path)))))


 ;; end of theme-supported-p


;; Terminal style
(terminal-supported-p
  
  ;; line number format on Terminal
  (safe-setq linum-format "%2d ")
  ;;above version 23 transient-mark-mode is enabled by default
  (version-supported-when > 23 (transient-mark-mode t))
  (set-face-background 'region "white")
  (set-face-foreground 'region "black"))


;; No cursor blinking, it's distracting
(safe-call blink-cursor-mode 0)

;; full path in title bar
(graphic-supported-p
  (safe-setq frame-title-format "%b (%f)"))

;; Ignore ring bell
(safe-setq ring-bell-function 'ignore)




