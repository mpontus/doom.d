(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
 '(safe-local-variable-values
   '((eval add-hook 'afer-save-hook 'org-babel-tangle nil 'local)
     (org-src-preserve-indentation . t)
     (eval add-hook 'after-save-hook #'doom/reload 0 'local)
     (eval add-to-list 'separedit-block-regexp-plists
           '(:header "@example" :body "  " :footer ".*\\'" :keep-footer t)
           'local)
     (eval add-hook 'after-save-hook 'org-babel-tangle nil 'local)
     (eval add-hook 'after-save-hook 'recompile nil 'local)
     (eval add-hook 'after-save-hook 'doom/reload 0 'local)))
 '(warning-suppress-types '((after-save-hook)) t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-goggles-default-face ((t (:inherit nil)))))
(put 'narrow-to-region 'disabled nil)
(put 'customize-variable 'disabled nil)
(put 'projectile-ag 'disabled nil)
(put 'customize-face 'disabled nil)
