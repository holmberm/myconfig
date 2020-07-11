(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(org-agenda-files
   (quote
    ("~/Dropbox/org/todo.org" "~/Dropbox/org/hobbits.org" "/Users/mattias/Dropbox/org/inbox.org" "/Users/mattias/Dropbox/org/Coaching-round-two.org" "/Users/mattias/Dropbox/org/ForrestYoga.org" "/Users/mattias/Dropbox/org/Jambo.org" "/Users/mattias/Dropbox/org/breathingandstuff.org" "/Users/mattias/Dropbox/org/parenting-book.org")))
 '(org-insert-mode-line-in-empty-file t)
 '(org-journal-dir "~/Dropbox/org/journal/")
 '(org-journal-file-type (quote weekly))
 '(org-journal-find-file (quote find-file))
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-tag-alist
   (quote
    (("ios")
     ("@work")
     ("@home")
     ("future_house")
     ("emacs"))))
 '(package-selected-packages
   (quote
    (org-pomodoro org-journal multiple-cursors haskell-mode idomenu w3m cdlatex auctex zenburn-theme color-theme-solarized color-theme magit autopair))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line-inactive ((t (:background "#383838" :foreground "#5F7F5F" :inverse-video nil :box (:line-width 1 :color "black")))))
 '(org-checkbox ((t (:background "#5F5F5F" :foreground "#FFFFEF" :box 1)))))
;; END OF CUSTOM

;; -----------------------------------------------------------------------------
;; Determine what system we are on
;; -----------------------------------------------------------------------------

(setq st_freebsd nil st_linux nil st_windows nil)

(cond
 ((string-equal system-type "berkeley-unix")
  (setq st_freebsd 1))
 ((string-equal system-type "gnu/linux")
  (setq st_linux 1))
 )

;; overkill to define a variable for this.
;; (if (display-graphic-p)
;;     (setq sys_has_x 1)
;;   (setq sys_has_x nil))


;; --------------------------------------------------------------------------------
;; interface tinkering and general setup
;; --------------------------------------------------------------------------------

(tool-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(menu-bar-mode 0)
(show-paren-mode 1)
(global-visual-line-mode 1)
;; fix backspace in terminals. Unstable?
(if (display-graphic-p)
    (normal-erase-is-backspace-mode 1)
  (normal-erase-is-backspace-mode 0))
 
;; use 'y' or 'n' instead of "yes" or "no"
(fset 'yes-or-no-p 'y-or-n-p)

;; backup settings. TODO rotation
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))

(setq
   backup-by-copying t      ; don't clobber symlinks
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)

(setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))

;; prevent tab indenting
(setq-default indent-tabs-mode nil)

;; let *grep* mess with this buffer, not others
(add-to-list 'same-window-buffer-names "*grep*")

(set-face-attribute 'default nil :height 110)
;; (set-face-attribute 'default nil :height 100)

(prefer-coding-system 'utf-8) ;TODO verify that this works in linux too...

;; Load custom function definitions
(load "~/.emacs.d/custom-functions.el")

(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg) (set-face-foreground 'mode-line fg))
                               orig-fg))))

;; --------------------------------------------------------------------------------
;; General Packages
;; if package not found -> package-refresh-contents
;; --------------------------------------------------------------------------------
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

;; Install missing packages
;; For some reason it seems package-install needs to be invoked manually once before this works.
(dolist (package '(autopair
                   ;; Themes
                   color-theme
                   zenburn-theme
                   ;; TeX
                   auctex
                   cdlatex
                   magit
                   multiple-cursors
                   org-journal
                   undo-tree
                   ;; w3m
                   idomenu
                   haskell-mode))
  (if (not (package-installed-p package))
      (package-install package)))

;; Looks
(require 'color-theme)
(color-theme-initialize)

(if (display-graphic-p)
    ;; (load-theme 'solarized-dark t)
    ;; (load-theme 'solarized-light t)
    (load-theme 'zenburn t)
  )

;; Mode line
(set-face-attribute 'mode-line nil :inverse-video t :box nil)

;; ErgoEmacs
;; (setq ergoemacs-theme nil)
;; (setq ergoemacs-keyboard-layout "dv")
;; (require 'ergoemacs-mode)
;; (ergoemacs-mode 1)

;; (set-default-font "Terminus-12")


;; (add-to-list 'load-path "/home/mattias/.emacs.d")
;; (require 'sticky-windows)
;; (global-set-key [(control x) (?0)] 'sticky-window-delete-window)
;; (global-set-key [(control x) (?1)] 'sticky-window-delete-other-windows)
;; (global-set-key [(control x) (?9)] 'sticky-window-keep-window-visible)

(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(require 'undo-tree)
(global-undo-tree-mode)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

;; Windmove - move between windows with <super - arrow>
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings 'super)
  (setq windmove-wrap-around t))


;; --------------------------------------------------------------------------------
;; eshell
;; --------------------------------------------------------------------------------

;; buffer management
(defalias 'ffo 'find-file-other-window)
(defalias 'ff 'find-file)
;; (defalias 'did 'dired .
;; package management
(defalias 'packrc 'package-refresh-contents)
(defalias 'packi 'package-install)
;; minor-modes
(defalias 'vlm 'visual-line-mode)
;; verision control
(defalias 'mast 'magit-status)
;; programming
;; (defalias 'm 'idomenu)

;; --------------------------------------------------------------------------------
;; org mode
;; --------------------------------------------------------------------------------
;; (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(setq org-startup-indented t)
;; (add-to-list 'load-path "/home/mattias/.emacs.d/elpa/cdlatex-4.0")
;; (add-to-list 'load-path "/home/mattias/.emacs.d/elpa")
(require 'org-journal)

;; --------------------------------------------------------------------------------
;; programming
;; --------------------------------------------------------------------------------

(autoload 'idomenu "idomenu" nil t)

;; According to info page, these function calls should need lambda. Works though
(require 'autopair)
(add-hook 'prog-mode-hook
          (autopair-global-mode 1)
          (setq autopair-autowrap t))

(add-hook 'prog-mode-hook
          'hl-line-mode
          )

;; 
;; C
;; 
(setq c-default-style "linux"
      c-basic-offset 4)

;;
;;haskell-mode, install with M-x package-install haskell-mode
;;
(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hic?$"     . haskell-mode)
                ("\\.hsc$"     . haskell-mode)
                ("\\.chs$"    . haskell-mode)
                ("\\.l[hg]s$" . literate-haskell-mode))))
(autoload 'haskell-mode "haskell-mode"
   "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
   "Major mode for editing literate Haskell scripts." t)

;adding the following lines according to which modules you want to use:
;; (require 'inf-haskell)

(add-hook 'haskell-mode-hook 'turn-on-font-lock)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;; (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;; (add-hook 'haskell-mode-hook 'turn-on-hi2)
;; (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
;; (add-hook 'haskell-mode-hook 
;;    (function
;;     (lambda ()
;;       (setq haskell-program-name "ghci"))))

;; (setq haskell-process-suggest-remove-import-lines t)
;; (setq haskell-process-auto-import-loaded-modules t)
;; (setq haskell-process-log t)
;; (eval-after-load 'haskell-mode '(progn
;;   (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
;;   (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
;;   (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
;;   (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
;;   (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
;;   (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)
;;   (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))
;; (eval-after-load 'haskell-cabal '(progn
;;   (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
;;   (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
;;   (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
;;   (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

;; Keys for the simpler haskell-compile
;; (eval-after-load 'haskell-mode
;;   '(define-key haskell-mode-map (kbd "C-c C-o") 'haskell-compile))
;; (eval-after-load 'haskell-cabal
;;   '(define-key haskell-cabal-mode-map (kbd "C-c C-o") 'haskell-compile))

;; GHC mode
;; (autoload 'ghc-init "ghc" nil t)
;; (autoload 'ghc-debug "ghc" nil t)
;; (add-hook 'haskell-mode-hook (lambda () (ghc-init)))

;; Ensure projects stay sandboxed
;; (custom-set-variables '(haskell-process-type 'cabal-repl))

;; (let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
;;   (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
;;   (add-to-list 'exec-path my-cabal-path))

;; Haskell alignment
(eval-after-load "align"
  '(add-to-list 'align-rules-list
                '(haskell-types
                   (regexp . "\\(\\s-+\\)\\(::\\|∷\\)\\s-+")
                   (modes quote (haskell-mode literate-haskell-mode)))))
(eval-after-load "align"
  '(add-to-list 'align-rules-list
                '(haskell-assignment
                  (regexp . "\\(\\s-+\\)=\\s-+")
                  (modes quote (haskell-mode literate-haskell-mode)))))
(eval-after-load "align"
  '(add-to-list 'align-rules-list
                '(haskell-arrows
                  (regexp . "\\(\\s-+\\)\\(->\\|→\\)\\s-+")
                  (modes quote (haskell-mode literate-haskell-mode)))))
(eval-after-load "align"
  '(add-to-list 'align-rules-list
                '(haskell-left-arrows
                  (regexp . "\\(\\s-+\\)\\(<-\\|←\\)\\s-+")
                  (modes quote (haskell-mode literate-haskell-mode)))))


;; 
;; Python
;; 

;; 
;; RePy
;; 
(add-to-list 'auto-mode-alist '("\\.repy$" . python-mode))

;; ;; 
;; ;; multi-web-mode
;; ;; 
;; (require 'multi-web-mode)
;; (setq mweb-default-major-mode 'html-mode)
;; (setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
;;                   (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
;;                   (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
;; (setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;; (multi-web-global-mode 1)

;; ;; 
;; ;; matlab-mode
;; ;; 
;; (add-to-list 'load-path "/home/mattias/src/matlab-emacs/matlab-emacs")
;; (load-library "matlab-load")

;; (autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
;; (add-to-list
;;  'auto-mode-alist
;;  '("\\.m$" . matlab-mode))
;; (setq matlab-indent-function t)
;; (setq matlab-shell-command "matlab")


;; --------------------------------------------------------------------------------
;; key bindings
;; 
;; This set of keys, `C-c' followed by a single character,
;; is strictly reserved for individuals' own use.
;; --------------------------------------------------------------------------------

;; Contol keys
(global-set-key (kbd "C-o") 'find-file)
;; (global-set-key (kbd "C-f") 'isearch-forward)
;; (define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
(global-set-key (kbd "s-s") 'save-buffer)
;; (global-set-key (kbd "C-7") 'ergoemacs-select-current-line) ;would like to have
                                        ;on fn too...
;; (global-set-key (kbd "C-b") 'ido-switch-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c i") 'idomenu) ;jump to function definition, ido style

;; C-t key chords (trying out...)
(define-prefix-command 't-map)
(global-set-key (kbd "C-t") 't-map)
;; files
(define-key t-map (kbd "f f") 'find-file)
(define-key t-map (kbd "f o") 'find-file-other-window)
;; kill stuff
(define-key t-map (kbd "k b") 'kill-buffer)
;; org mode
(define-key t-map (kbd "o p") 'org-pomodoro)
;; programming
(define-key t-map (kbd "p m") 'idomenu)
(define-key t-map (kbd "p c") 'compile)
(define-key t-map (kbd "p l") 'hl-line-mode)
(define-key t-map (kbd "p a") 'align)
;; indenting
(define-key t-map (kbd "i r") 'indent-region)
;; searching
(define-key t-map (kbd "s r") 'query-replace)
;; swedish characters on mac
(define-key t-map (kbd "a") (kbd "å"))
(define-key t-map (kbd "o") (kbd "ä"))
(define-key t-map (kbd "s") (kbd "ä"))
(define-key t-map (kbd "e") (kbd "ö"))
(define-key t-map (kbd "d") (kbd "ö"))

;;
;; T end of the t-map
;;

;; Meta keys (while Meta almost never works on the ipad, ESC key chords do)
;; Window management
(global-set-key (kbd "M-2") 'delete-window)
(global-set-key (kbd "M-3") 'delete-other-windows)
(global-set-key (kbd "M-4") 'split-window-right)
(global-set-key (kbd "M-$") 'split-window-below)
(global-set-key (kbd "M-<") 'beginning-of-buffer)
(global-set-key (kbd "M->") 'end-of-buffer)
(global-set-key (kbd "M-u") 'undo-tree-undo)
(global-set-key (kbd "M-r") 'undo-tree-redo)
;; Mystery follows:
(global-set-key (kbd "ESC <up>") 'scroll-down-command)
(global-set-key (kbd "ESC <down>") 'scroll-up-command)

;; fn keys
(global-set-key (kbd "<f2>") 'comment-indent-new-line)
(global-set-key (kbd "<f3>") 'execute-extended-command)
(global-set-key (kbd "<f4>") 'ergoemacs-select-current-line)
(global-set-key (kbd "<f5>") 'other-window)
(global-set-key (kbd "S-<f5>") 'mat-previous-window)
(global-set-key (kbd "<f6>") 'kill-line)
(global-set-key (kbd "S-<f6>") 'mat-kill-line-backward)
(global-set-key (kbd "<f7>") 'backward-kill-word)
(global-set-key (kbd "<f8>") 'kill-word)
(global-set-key (kbd "<f9>") 'comment-dwim)
(global-set-key (kbd "<f11>") 'backward-word)
(global-set-key (kbd "<f12>") 'forward-word)
(global-set-key (kbd "S-<up>") 'scroll-down-command)
(global-set-key (kbd "S-<down>") 'scroll-up-command)
;; shift left and right, see ergoemacs-forward-open-bracket and friends.
;; It is no use, ipad does not recognize shifted keys anyway. Maybe do something with meta?

;; (global-set-key (kbd "C-}") 'enlarge-window-horizontally)
;; (global-set-key (kbd "C-{") 'shrink-window-horizontally)
;; (global-set-key (kbd "M-}") 'enlarge-window)
;; (global-set-key (kbd "M-{") 'shrink-window)
;; (global-set-key (kbd "M-N") 'scroll-up-line)
;; (global-set-key (kbd "M-P") 'scroll-down-line)

(global-set-key "\C-xar" 'align-regexp)
;; todo write function that aligns equal signs!

;; org mode keys
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(global-set-key "\C-cr" '(doc-view-revert-buffer nil t))
;;(global-set-key "\C-cr" 'revert-noconfirm)

;; (defun revert-noconfirm
;;   "revert dv buffer without confirmation"
;;   (doc-view-revert-buffer nil t))

;; w3m keys
;; (global-set-key [C-tab] 'w3m-next-buffer)
;; (global-set-key [C-iso-lefttab] 'w3m-previous-buffer)

(put 'narrow-to-region 'disabled nil)

;; (require 'w3m-load)
;;(setq browse-url-browser-function 'w3m-browse-url)
;;(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

;; --------------------------------------------------------------------------------
;; latex and text
;; --------------------------------------------------------------------------------

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
;; (add-hook 'latex-mode-hook 'visual-line-mode)

(setq cdlatex-env-alist
     '(("axiom" "\\begin{axiom}\nAUTOLABEL\n?\n\\end{axiom}\n" nil)
       ("lstlisting" "\\begin{lstlisting}[style=syn?]\n\n\\end{lstlisting}\n" nil)))
(setq cdlatex-command-alist
 '(("axm" "Insert axiom env"   "" cdlatex-environment ("axiom") t nil)
   ("ist" "Insert lstlisting env"   "" cdlatex-environment ("lstlisting") t nil)
   ("sus"       "Insert a \\subsubsection{} statement"
        "\\subsubsection{?}" cdlatex-position-cursor nil t nil)))

(require 'reftex)
;; (require 'cdlatex) ; needed?|
(add-hook 'LaTeX-mode-hook
	  '(lambda ()
	    (turn-on-reftex)
	    (turn-on-cdlatex)))

;; pdflatex?
(setq TeX-PDF-mode t)

(setq TeX-electric-escape nil)
(setq TeX-default-macro "todo")

;; Ispell in windows

(if st_windows
    (progn
      ;; (add-to-list 'exec-path "C:/Program Files (x86)/GnuWin32/Aspell/bin")
      ;; (setq ispell-program-name "aspell")
      (require 'rw-language-and-country-codes)
      (require 'rw-ispell)
      (require 'rw-hunspell)
      ;; (setq ispell-dictionary "en_US_hunspell")
      (setq ispell-program-name "hunspell")
      (require 'ispell)))


;;text-mode
;; (add-hook 'TeX-mode-hook 'turn-off-auto-fill)
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-to-list 'load-path "/usr/share/emacs/site-lisp/tex-utils")
;;(require 'xdvi-search)

;; ispell in swedish
;;(setq ispell-program-name "hunspell")

;;(add-hook 'text-mode-hook '(lambda () (ispell-change-dictionary "svenska" nil)))
;;(add-hook 'text-mode-hook '(lambda () (flyspell-mode nil)))
;
; fix flyspell problem
;;(setq flyspell-issue-welcome-flag nil) 


;; --------------------------------------------------------------------------------
;; Dired
;; --------------------------------------------------------------------------------

(put 'dired-find-alternate-file 'disabled nil)

;; dired use gnuls instead of ls.
(if st_freebsd
    (progn
      (setq ls-lisp-use-insert-directory-program t)      ;; use external ls
      (setq insert-directory-program "/usr/local/bin/gnuls") ;; ls program name
      )
  )

;; ------------------------------------------------------------------------------
;; w3m
;; ------------------------------------------------------------------------------
(setq w3m-use-cookies 1)                ;needed for gmail and such

;; (require 'w3m-session)

(add-hook 'w3m-mode-hook 
          (lambda () 
            ;; (define-key w3m-mode-map (kbd "C-x b") nil)
            (define-key w3m-mode-map (kbd "<up>") nil)
            (define-key w3m-mode-map (kbd "<down>") nil)
            (define-key w3m-mode-map (kbd "<left>") nil)
            (define-key w3m-mode-map (kbd "<right>") nil)
            (define-key w3m-mode-map (kbd "C-c C-f") 'w3m-lnum-follow)
            (define-key w3m-mode-map (kbd "f") 'w3m-lnum-follow)
            ))

;; ------------------------------------------------------------------------------
;; gnus
;; ------------------------------------------------------------------------------

(setq gnus-select-method 
      '(nnmaildir "GMail" 
                  (directory "~/Maildir/Gmail")
                  (directory-files nnheader-directory-files-safe) 
                  (get-new-mail nil)))

(defun my-gnus-group-list-subscribed-groups ()
  "List all subscribed groups with or without un-read messages"
  (interactive)
  (gnus-group-list-all-groups 5)
  )
(add-hook 'gnus-group-mode-hook
          ;; list all the subscribed groups even they contain zero un-read messages
          (lambda () (local-set-key "o" 'my-gnus-group-list-subscribed-groups ))
          )

;; (setq gnus-select-method
;;       '(nntp "localhost")) ; I also read news in gnus; it is copied to my local machine via **leafnode**

;; (setq gnus-secondary-select-methods
;;       '((nnmaildir "GMail" (directory "~/Maildir/Gmail")) ; grab mail from here
;;     (nnfolder "archive"
;;       (nnfolder-directory   "~/Documents/gnus/Mail/archive") ; where I archive sent email
;;       (nnfolder-active-file "~/Documents/gnus/Mail/archive/active")
;;       (nnfolder-get-new-mail nil)
;;       (nnfolder-inhibit-expiry t))))

;; --------------------------------------------------------------------------------
;; trashcan
;; --------------------------------------------------------------------------------
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
