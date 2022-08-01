;; -*- no-byte-compile: t; eval: (add-hook 'after-save-hook #'doom/reload 0 'local) -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
(package! nix-mode)
(package! tree-edit)
(package! exwm)
;; (package! centered-cursor)
(package! symex)
(package! prettier)
(package! macrostep)

(package! typescript-mode)
(package! bookmark+
   :recipe (:host github :repo "emacsmirror/bookmark-plus"))

(package! skeletor)
(package! telega)
(package! rotate)
(package! leuven-theme)
; (package! vterm-toggle)
(package! easy-repeat)

(package! help-macro+
  :recipe (:host github :repo "emacsmirror/help-macro-plus"))
(package! help+
  :recipe (:host github :repo "emacsmirror/help-plus"))
(package! help-fns+
  :recipe (:host github :repo "emacsmirror/help-fns-plus"))
(package! help-mode+
  :recipe (:host github :repo "emacsmirror/help-mode-plus"))

(package! web-server)
(package! markdown-preview-mode)
(package! haskell-mode)
(package! emr)
(package! docker-tramp)
(package! separedit)
(package! ob-http)
(package! copilot
  :recipe (:host github :repo "mpontus/copilot.el" :files ("*.el" "dist")))

;; (package! centered-cursor
;;   :recipe (:host github :repo "mpontus/centered-cursor.el"))

