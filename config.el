;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

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
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

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

;; Nix

(define-minor-mode nix-format-mode
  "Minor mode to format nix files on save."
  nil nil nil
  (if nix-format-mode
      (add-hook! 'before-save-hook :local #'nix-format-before-save)
    (remove-hook! 'before-save-hook :local #'nix-format-before-save)))

(use-package! nix-mode
  :config
  (add-hook! 'nix-mode-hook #'nix-format-mode))

(defadvice! nix-format-buffer--capture-error (f &rest rs)
  "Display actual error when nixfmt fails."
  :around 'nix-format-buffer
  (condition-case err (apply f rs)
    (t (if-let ((nixfmt-buffer (get-buffer "*nixfmt*")))
           (error (with-current-buffer nixfmt-buffer
                    (buffer-substring-no-properties (point-min) (point-max))))
         (signal (car err) (cdr err))))
    (t (debug e))))


;; Org mode

(use-package! org
  :config
  (map! "C-c C-M-\\"
        (defun +org-indent-dwim ()
          (interactive)
          (if (region-active-p)
              (org-indent-region (region-beginning) (region-end))
            (org-indent-block)))))

;; VTerm

;; (use-package! vterm-toggle
;;   :config
;;   ;; you can cd to the directory where your previous buffer file exists
;;   ;; after you have toggle to the vterm buffer with `vterm-toggle'.
;;   (map! [f2] 'vterm-toggle
;;         [M-f2] 'vterm-toggle-cd
;;         :map vterm-mode-map
;;         [(control return)] #'vterm-toggle-insert-cd
;;         "M-n" #'vterm-toggle-forward
;;         "M-p"   'vterm-toggle-backward))

;; Repeat

(defun +repeat (command)
  (with-eval-after-load 'easy-repeat
    (add-to-list 'easy-repeat-command-list command)
    command))

(use-package! easy-repeat
  :config
  (easy-repeat-mode t)
  (+repeat #'evil-window-next)
  (+repeat #'macrostep-expand)
  (+repeat #'enlarge-window-horizontally)
  (+repeat #'shrink-window-horizontally))

;; Info

(use-package! info
  :config
  (map! :map Info-mode-map [remap better-jumper-jump-backward] #'Info-history-back)
  (map! :map Info-mode-map [remap better-jumper-jump-forward] #'Info-history-forward))

;; Rotate

(use-package! rotate
  :config
  (map! :leader "we" (+repeat #'rotate-layout)))

;; Which key

(use-package which-key
  :config
  (setq! which-key-idle-delay 300))


;; Magit

;; (defun +magit-status-without-sudo (f &optional directory cache)
;;    (interactive)
;;    (or (and (tramp-tramp-file-p directory)
;;             (with-parsed-tramp-file-name directory file
;;               (and (equal "sudo" (tramp-file-name-method file))
;;                    (funcall f (tramp-file-name-localname file)))))
;;        (call-interactively f)))

;; (advice-add 'magit-status :around #'+magit-status-without-sudo
;;             '((name '+magit-status-without-sudo)))


;; Symex

;; (use-package! symex
;;   :config
;;   ;; (add-hook 'emacs-lisp-mode-hook #'symex-mode)
;;   (setq! symex-modal-backend 'evil)
;;   (map! :map emacs-lisp-mode-map
;;         :leader "SPC" #'symex-mode-interface)
;;   (symex-initialize))

;; Consult

(use-package consult
  :config
  (map! :leader "," #'consult-buffer
        :leader "." #'consult-locate))

(use-package hydra
  :config
  (load-file (expand-file-name "hydra/org-mode.el" doom-user-dir)))

(defhydra hydra-evil-mc (:color pink
                         :hint nil
                         :pre (evil-mc-pause-cursors))
  "
^Match^            ^Line-wise^           ^Manual^
^^^^^^----------------------------------------------------
_Z_: match all     _J_: make & go down   _z_: toggle here
_m_: make & next   _K_: make & go up     _r_: remove last
_M_: make & prev   ^ ^                   _R_: remove all
_n_: skip & next   ^ ^                   _p_: pause/resume
_N_: skip & prev

Current pattern: %`evil-mc-pattern

"
  ("Z" #'evil-mc-make-all-cursors)
  ("m" #'evil-mc-make-and-goto-next-match)
  ("M" #'evil-mc-make-and-goto-prev-match)
  ("n" #'evil-mc-skip-and-goto-next-match)
  ("N" #'evil-mc-skip-and-goto-prev-match)
  ("J" #'evil-mc-make-cursor-move-next-line)
  ("K" #'evil-mc-make-cursor-move-prev-line)
  ("z" #'+multiple-cursors/evil-mc-toggle-cursor-here)
  ("r" #'+multiple-cursors/evil-mc-undo-cursor)
  ("R" #'evil-mc-undo-all-cursors)
  ("p" #'+multiple-cursors/evil-mc-toggle-cursors)
  ("q" #'evil-mc-resume-cursors "quit" :color blue)
  ("<escape>" #'evil-mc-resume-cursors "quit" :color blue))

(use-package evil-mc
  :config
  (map! :v "gz" #'hydra-evil-mc/body))

;; BEGIN Centered cursor

(define-minor-mode centered-cursor-mode
  "Pin cursor to the center of the screen" nil nil nil
  (if centered-cursor-mode
      (add-hook 'post-command-hook #'recenter)
    (remove-hook 'post-command-hook #'recenter)))

(define-global-minor-mode global-centered-cursor-mode
    centered-cursor-mode centered-cursor-mode)

(function-put 'evil-scroll-up 'scroll-command t)
(function-put 'evil-scroll-down 'scroll-command t)
(function-put 'evil-scroll-page-up 'scroll-command t)
(function-put 'evil-scroll-page-down 'scroll-command t)

;; (defadvice! recenter-after-scroll-command (&optional arg)
;;   "Adjust cursor position after scrolling."
;;   :before-until #'recenter
;;   (when (function-get real-this-command 'scroll-command)
;;     ;; Scroll command move visible part of the buffer instead of the cursor.
;;     ;; Therefore we need to recenter the cursor after chaning window position.
;;     (when (and (> (window-start) 1) (< (window-end) (point-max)))
;;       (move-to-window-line (ceiling (/ (window-screen-lines) 2))))))

;; (defadvice! scroll-back-after-recenter ()
;;   "Scroll back to hide dead space after the end of the buffer."
;;   :after #'recenter
;;   (let* ((shown-height (cdr (window-text-pixel-size (selected-window)
;;                                                       (window-start)
;;                                                       (window-end))))
;;            (dead-height (- (window-pixel-height) shown-height))
;;            (shown-lines (count-lines (window-start) (window-end) t))
;;            (line-height (if (zerop shown-height) 0
;;                           (/ shown-height shown-lines)))
;;            (window-lines (if (zerop line-height) (window-height)
;;                            (/ (window-pixel-height) line-height)))
;;            (dead-lines (- window-lines shown-lines)))
;;       ;; (message "dead-lines: %s, window-lines: %s, line-height: %s"
;;       ;;          dead-lines window-lines line-height)
;;       (scroll-down (if (zerop shown-height) 0
;;                      (max 0 (- dead-lines 3))))))

;; Tree sitter

;; (use-package! tree-sitter
;;   :config
;;   (require 'tree-sitter-langs)
;;   (global-tree-sitter-mode)
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

;; Configure password cache

(use-package! password-cache
  :config (setq! password-cache-expiry 1800))

;; Cool theme

(use-package leuven-theme
  :config (setq! doom-theme 'leuven-dark))


;; Havent got around to it yet

(use-package! exwm-config
  ;; :config
  ;; (exwm-config-default)
  )

;; Same

(use-package! persp-mode
  :config
  (map! "M-]" #'persp-next "M-[" #'persp-prev))

;; Multiple Cursors

(use-package! evil-multiedit
  :config
  (evil-multiedit-default-keybinds))

(use-package dired-x
  :config
  (dired-x-bind-find-file))

;; Back to mappings

(map! :leader "cb"
      (defun display-compilation-buffer ()
        (interactive)
        (display-buffer (compilation-find-buffer))))

(use-package! help+
  :config (require 'help-mode+))


;; Disable electric-indent-mode by default
(electric-indent-mode -1)

;; Save clipboard contents to kill ring instead of discarding them
(setq! save-interprogram-paste-before-kill t
       ;; Make buffer names more readable
       uniquify-buffer-name-style 'forward
       ;; Load from the source if its more fresh than the compiled code.
       load-prefer-newer t
       save-interprogram-paste-before-kill t
       read-file-name-completion-ignore-case t
       history-length 8000)

;; Backspace key is relatively difficult to access. For backward deletion I use <kbd>C-h</kbd> instead.
;; In every situation where I want to use <backspace> I want to be able to use <C-h> instead.
(map! "C-h" 'backward-delete-char "M-h" 'backward-kill-word "C-M-h" 'backward-kill-sexp)

;; Enable file-local compile-on-save configuratoin
(add-to-list 'safe-local-eval-forms '(add-hook 'after-save-hook 'recompile nil t))
(add-to-list 'safe-local-eval-forms '(add-hook 'after-save-hook 'org-babel-tangle nil t))
(add-to-list 'safe-local-eval-forms '(add-hook 'after-save-hook 'doom/reload nil t))

(setq! evil-want-Y-yank-to-eol nil)
(map! :n "q" #'quit-window
      [C-tab] #'+vertico/switch-workspace-buffer
      [C-S-iso-lefttab] #'+vertico/switch-workspace-buffer
      :map vertico-map
      [C-tab] #'vertico-next
      [C-S-iso-lefttab] 'vertico-previous)

;; (map! :map vertico-map
;;       "<C-tab>" nil
;;       "<C-S-iso-lefttab>" nil)(
(defun +popup/toggle-or-raise (&optional arg)
  (interactive)
  (if (+popup-windows)
      (if (+popup-window-p (selected-window))
          (+popup/raise (selected-window) arg)
        (select-window (car (+popup-windows))))
    (+popup/toggle)))

(map! "C-\\" '+popup/toggle-or-raise
      "C-c C-\\" (+repeat #'+popup/toggle))

(setq! auth-sources '("~/.authinfo.gpg") enable-remote-dir-locals t recentf-auto-cleanup 'never)

(define-minor-mode recompile-on-save-mode
  "Run `compile-command' when the buffer is saved."
  :lighter " Rec"
  (if (not recompile-on-save-mode)
      (remove-hook 'after-save-hook #'recompile  'local)
    (add-hook 'after-save-hook #'recompile nil 'local)
    (unless (buffer-modified-p) (recompile))))

(use-package! compile
  :config
  (map! :leader "ca" #'recompile-on-save-mode))

(defadvice! +recompile--ignore-compilation-directory (fn &rest args)
  "Unset `compilation-directory' when calling `recompile'."
  :around #'recompile (let (compilation-directory) (apply fn args)))

(defadvice! recompile-on-save-set-compile-command (fn &rest args)
  "Change compile command when recompile-on-save-mode is called with prefix argument."
  :before #'recompile-on-save-mode (and current-prefix-arg (recompile t)))

(define-key! :keymaps +default-minibuffer-maps
        ;; Un-doom minibuffer keymaps
  "C-j" nil)

(after! evil-snipe
  (evil-snipe-mode -1))

(dolist (map +default-minibuffer-maps)
  (set map (default-value map)))


;; Diff binary files with hexl-mode

(defvar ediff-do-hexl-diff nil
  "variable used to store trigger for doing diff in hexl-mode")
(defadvice ediff-files-internal (around ediff-files-internal-for-binary-files activate)
  "catch the condition when the binary files differ

the reason for catching the error out here (when re-thrown from the inner advice)
is to let the stack continue to unwind before we start the new diff
otherwise some code in the middle of the stack expects some output that
isn't there and triggers an error"
  (let ((file-A (ad-get-arg 0))
        (file-B (ad-get-arg 1))
        ediff-do-hexl-diff)
    (condition-case err
        (progn
          ad-do-it)
      (error
       (if ediff-do-hexl-diff
           (let ((buf-A (find-file-noselect file-A))
                 (buf-B (find-file-noselect file-B)))
             (with-current-buffer buf-A
               (hexl-mode 1))
             (with-current-buffer buf-B
               (hexl-mode 1))
             (ediff-buffers buf-A buf-B))
         (error (error-message-string err)))))))

(defadvice ediff-setup-diff-regions (around ediff-setup-diff-regions-for-binary-files activate)
  "when binary files differ, set the variable "
  (condition-case err
      (progn
        ad-do-it)
    (error
     (setq ediff-do-hexl-diff
           (and (string-match-p "^Errors in diff output.  Diff output is in.*"
                                (error-message-string err))
                (string-match-p "^\\(Binary \\)?[fF]iles .* and .* differ"
                                (buffer-substring-no-properties
                                 (line-beginning-position)
                                 (line-end-position)))
                (y-or-n-p "The binary files differ, look at the differences in hexl-mode? ")))
     (error (error-message-string err)))))

(use-package! separedit
  :config
  (add-to-list 'separedit-block-regexp-plists
               '(:header "@example" :body "  " :footer ".*\\'" :keep-footer t)))
(use-package! typescript-mode
  :config
  (define-key typescript-mode-map (kbd "C-c '") #'separedit))

(use-package org-persist)


(use-package! grip-mode
  :config
  (setenv "WEBKIT_FORCE_SANDBOX" "0")
  (let ((credential (auth-source-user-and-password "api.github.com")))
    (setq grip-github-user (car credential)
          grip-github-password (cadr credential))))

(use-package dotenv
  :after (projectile)
  :config
  (defun dotenv-projectile-hook ()
   "Projectile hook."
   (dotenv-update-project-env (projectile-project-root)))

  (add-to-list 'projectile-after-switch-project-hook #'dotenv-projectile-hook) )

(use-package! chatgpt
  :defer t
  :config
  (unless (boundp 'python-interpreter)
    (defvaralias 'python-interpreter 'python-shell-interpreter))
  (setq chatgpt-repo-path (expand-file-name "straight/repos/ChatGPT.el/" doom-local-dir))
  (set-popup-rule! (regexp-quote "*ChatGPT*")
    :side 'bottom :size .5 :ttl nil :quit t :modeline nil)
  :bind ("C-c q" . chatgpt-query))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/RoamNotes")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n r" . org-roam-refile)
         ("C-c n a" . org-roam-alias-add)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode)
  (setq org-roam-preview-function
        (defun my/org-roam-preview-function ()
          (let* ((elem (org-element-context))
           (parent (org-element-property :parent elem)))
      ;; TODO: alt handling for non-paragraph elements
      (string-trim-right (buffer-substring-no-properties
                          (org-element-property :begin parent)
                          (org-element-property :end parent)))))))

(use-package! websocket
    :after org-roam)

(use-package! org-roam
  :config
  (add-to-list 'display-buffer-alist
               '("^\\*org-roam"
                 (display-buffer-in-atom-window)
                 (actions)
                 (side . bottom)
                 ;; (size . 0.8)
                 ;; (window-width . 40)
                 ;; (window-height . 0.16)
                 ;; (slot . 20)
                 ;; (vslot)
                 ;; (window-parameters
                 ;;  (ttl . 0)
                 ;;  (quit)
                 ;;  (select . t)
                 ;;  (modeline)
                 ;;  (autosave))
                 )))
