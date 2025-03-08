(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((org-src-preserve-indentation . t)
     (eval add-hook 'after-save-hook #'doom/reload 0 'local)
     (eval progn
           (pp-buffer)
           (indent-buffer))
     (eval add-hook 'after-save-hook 'org-babel-tangle nil 'local))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
(put 'customize-variable 'disabled nil)
(put 'projectile-ag 'disabled nil)
(put 'customize-face 'disabled nil)
