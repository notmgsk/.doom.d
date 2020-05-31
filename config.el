;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Mark Skilbeck"
      user-mail-address "markskilbeck@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-laserwave)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; (defun counsel-find-org ()
;;   (interactive)
;;   (let ((default-directory org-directory))
;;     (counsel-git)))
;; TODO Set up a keymap for find-file related stuff and add chords for them.

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; TODO I think there is some Doom-specific tooling for determining the current
;; OS. Use that instead.
;;
;; macOS-specific configurations. This sets the cmd key to another alt (meta)
;; key.
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (global-set-key (kbd "M-`") 'ns-next-frame)
  (global-set-key (kbd "M-h") 'ns-do-hide-emacs))

(use-package! key-chord
  :demand t
  :init
  ;; I think I stole these from dangirsch.
  (setq dk-keymap (make-sparse-keymap)
        sl-keymap (make-sparse-keymap))
  (defun add-to-keymap (keymap bindings)
    (dolist (binding bindings)
      (define-key keymap (kbd (car binding)) (cdr binding))))
  (defun add-to-dk-keymap (bindings)
    (add-to-keymap dk-keymap bindings))
  (defun add-to-sl-keymap (bindings)
    (add-to-keymap sl-keymap bindings))

  :config
  (key-chord-define-global "dk" dk-keymap)
  (key-chord-define-global "sl" sl-keymap)
  (add-to-dk-keymap
   '(("m" . execute-command-on-file-buffer)
     ("d" . dired-jump)
     ("b" . ivy-switch-buffer)
     ("r" . quickrun-region)
     ("R" . quickrun)
     ("<SPC>" . rg)
     ("s" . save-buffer)
     ("S" . howdoi-query-line-at-point-replace-by-code-snippet)
     ("t" . eshell-here)
     ("/" . find-name-dired)
     ("e" . balance-windows)))
  (setq key-chord-two-keys-delay 0.05)
  (key-chord-mode +1))

(use-package-hook! ace-window
  :pre-config
  (key-chord-define-global "jw" #'ace-window)
  t)

(use-package simple
  :config
  (key-chord-define-global "df" #'undo)
  (key-chord-define-global "jd" #'set-mark-command))

(use-package-hook! counsel
  :pre-config
  (key-chord-define-global "lw" #'counsel-M-x)
  t)

(use-package-hook! ivy-posframe
  :pre-config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center))
        ivy-posframe-height-alist '((t . 40))
        ivy-posframe-width 130
        ivy-posframe-min-width 130
        ivy-posframe-height 40
        ivy-posframe-min-height 40
        ivy-posframe-parameters nil
        ivy-posframe-border-width 10)
  ;; NOTE This NIL is important: it overrides doom's config.
  nil)

(use-package-hook! ivy-rich
  :post-config
  (plist-put! ivy-rich-display-transformers-list
              'counsel-describe-variable
              '(:columns
                ((counsel-describe-variable-transformer (:width 30))
                 (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face :width 50))))
              'counsel-M-x
              '(:columns
                ((counsel-M-x-transformer (:width 40))
                 (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
              ;; Apply switch buffer transformers to `counsel-projectile-switch-to-buffer' as well
              'counsel-projectile-switch-to-buffer
              (plist-get ivy-rich-display-transformers-list 'ivy-switch-buffer)
              'counsel-bookmark
              '(:columns
                ((ivy-rich-candidate (:width 0.5))
                 (ivy-rich-bookmark-filename (:width 60)))))
  ;; FIXME There is probably a cleaner way to do this. Redefining the above and
  ;; then doing (ivy-rich-mode +1) doesn't seem to pick up the config. Gotta
  ;; toggle it off first.
  (ivy-rich-mode -1)
  (ivy-rich-mode +1)
  t)

(use-package-hook! multiple-cursors
  :post-config
  (global-set-key (kbd "C->") #'mc/mark-next-like-this)
  (global-set-key (kbd"C-<") #'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C->") #'mc/mark-all-like-this)
  (global-set-key (kbd "C-c (") #'mc/mark-all-in-region)
  t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
