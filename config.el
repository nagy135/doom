;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Viktor Nagy"
      user-mail-address "viktor.nagy1995@gmail.com")

(setq doom-font (font-spec :family "League Mono" :size 18)
      doom-variable-pitch-font (font-spec :family "League Mono" :size 18))

(setq doom-theme 'doom-one)

;; relative number lines
(setq display-line-numbers-type 'relative)

;; dont ask if really close
(setq confirm-kill-emacs nil)

;; add missing symbols that are part of word
(modify-syntax-entry ?_ "w")

(defun delete-function-under-cursor ()
  "Deletes function name and its brackets"
  (setq character (string (char-after)))
  (let ((i 1))
    (evil-backward-word-begin)
    (kill-word 1)
    (delete-char 1)
    (while (or
            (not (zerop i))
            (equal (+ 1 (point)) (point-at-eol)))
      (setq character (string (char-after)))
      (when (equal "(" character) (setq i (+ i 1)) )
      (when (equal ")" character) (setq i (- i 1)) )
      (evil-forward-char)
      )
    (when (not (equal (+ 1 (point)) (point-at-eol)))
      (evil-backward-char)
      (delete-char 1)
      )
    )
  )

(global-set-key (kbd "C-x C-j") ( lambda () (interactive) (delete-funtion-under-cursor)))

(setq org-directory "~/org/")

(after! org
  (setq
   org-todo-keywords '((sequence "TODO(t)" "INPROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
   org-todo-keyword-faces
   '(("TODO" :foreground "#f9dc2b" :weight normal :underline t)
     ("WAITING" :foreground "#9f7efe" :weight normal :underline t)
     ("INPROGRESS" :foreground "#0098dd" :weight normal :underline t)
     ("DONE" :foreground "#50a14f" :weight normal :underline t)
     ("CANCELLED" :foreground "#ff6480" :weight normal :underline t))
   )

  ;; Sizes of levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "League Mono" :weight 'regular :height (cdr face)))
  )

(map! :desc "org agenda list" :leader "a" #'org-agenda-list)

(setq org-agenda-start-with-log-mode t)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-bullets-bullet-list '("■" "◆" "▲" "▶"))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))

(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/org/Config.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(setq which-key-idle-delay 0.3)

(require 'evil-snipe)
(evil-snipe-mode +1)
(evil-snipe-override-mode +1)

(use-package dired
  :ensure nil
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    ;; H/L directory movement
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(map! :leader
      (:prefix-map ("d" . "dired")
       :desc "home" "h" (lambda () (interactive) (find-file "~"))
       :desc "org" "o" (lambda () (interactive) (find-file "~/org"))
       :desc "downloads" "d" (lambda () (interactive) (find-file "~/Downloads"))
       :desc "tabs" "t" (lambda () (interactive) (find-file "~/Documents/Tabs"))
       :desc "clones" "c" (lambda () (interactive) (find-file "~/Clones"))))

(use-package all-the-icons-dired
  :ensure nil
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-hide-dotfiles
  :ensure nil
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "H" 'dired-hide-dotfiles-mode))

(use-package php-mode
  ;;
  :hook ((php-mode . (lambda () (set (make-local-variable 'company-backends)
                                     '(;; list of backends
                                       company-phpactor
                                       company-files
                                       ))))))

(setq lsp-clients-php-iph-server-command '("intelephense" "--stdio"))

;; (dolist (mode '(org-mode-hook
;;                 eshell-mode-hook))
;;   (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

 ;; (define-key global-map (kbd "C-c j")
 ;;    (lambda () (interactive) (org-capture nil "jj")))
