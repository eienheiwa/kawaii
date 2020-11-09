
;;; Commentary:

;; My init.el.

;;; Code:

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/init.el

(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; configuration here

(leaf doom-themes
  :ensure t
  :config (load-theme 'doom-miramare t))


;;(leaf solarized-theme
;;  :ensure t
;;  :config (load-theme 'solarized-dark t))

(set-face-font 'default "JetBrains Mono-10")

;;add keybind
(define-key global-map (kbd "C-t") 'other-window)
(define-key global-map (kbd "C-x f") 'find-file)
(define-key global-map (kbd "C-<up>") 'scroll-down-line)
(define-key global-map (kbd "C-<down>") 'scroll-up-line)
(define-key global-map (kbd "C-c k") 'kill-buffer-and-window)

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))

  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((user-full-name . "eienheiwa")
            (user-mail-address . "chimakity@gmail.com")
            (user-login-name . "kakoi")
            (create-lockfiles . nil)
            (debug-on-error . t)
            (init-file-debug . t)
            (frame-resize-pixelwise . t)
            (enable-recursive-minibuffers . t)
            (history-length . 1000)
            (history-delete-duplicates . t)
            (scroll-preserve-screen-position . t)
            (scroll-conservatively . 100)
            (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
            (ring-bell-function . 'ignore)
            (text-quoting-style . 'straight)
            (truncate-lines . t)
             (use-dialog-box . nil)
             (use-file-dialog . nil)
             (menu-bar-mode . t)
             (tool-bar-mode . nil)
            (scroll-bar-mode . nil)
            (indent-tabs-mode . nil))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (keyboard-translate ?\C-h ?\C-?))

(eval-and-compile
  (leaf bytecomp
    :doc "compilation of Lisp code into byte code"
    :tag "builtin" "lisp"
    :custom (byte-compile-warnings . '(cl-functions))))

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 0.3)
           (auto-revert-check-vc-info . t))
  :global-minor-mode global-auto-revert-mode)

(leaf *lsp-basic-settings
  :url "https://github.com/emacs-lsp/lsp-mode#supported-languages"
  :url "https://github.com/MaskRay/ccls/wiki/lsp-mode#find-definitionsreferences"
  :doc "lsp is language server protocol"
  :when (version<= "25.1" emacs-version)
  :ensure flycheck
  :config

 (leaf lsp-mode
    :ensure t
    :commands lsp
    :custom
    ((lsp-enable-snippet . t)
     (lsp-enable-indentation . nil)
     (lsp-prefer-flymake . nil)
     (lsp-document-sync-method . 'incremental)
     (lsp-inhibit-message . t)
     (lsp-message-project-root-warning . t)
     (create-lockfiles . nil)
     (lsp-file-watch-threshold .nil))
    :preface (global-unset-key (kbd "C-l"))
    :bind
    (("C-l C-l"  . lsp)
     ("C-l h"    . lsp-describe-session)
     ("C-l t"    . lsp-goto-type-definition)
     ("C-l r"    . lsp-rename)
     ("C-l <f5>" . lsp-restart-workspace)
     ("C-l l"    . lsp-lens-mode))
    :hook
    (prog-major-mode-hook . lsp-prog-major-mode-enable)
    (add-hook 'haskell-mode-hook #'lsp)
    (add-hook 'haskell-literate-mode-hook #'lsp))

(load (expand-file-name "~/.roswell/helper.el"))
 (setq inferior-lisp-program "sbcl")

 
 (leaf lsp-ui
    :ensure t
    :commands lsp-ui-mode
    :after lsp-mode
    :custom
    ;; lsp-ui-doc
    (lsp-ui-doc-enable . t)
    (lsp-ui-doc-header . t)
    (lsp-ui-doc-include-signature . t)
    (lsp-ui-doc-position . 'top)
    (lsp-ui-doc-max-width . 60)
    (lsp-ui-doc-max-height . 20)
    (lsp-ui-doc-use-childframe . t)
    (lsp-ui-doc-use-webkit . nil)
    ;; lsp-ui-flycheck
    (lsp-ui-flycheck-enable . t)
    ;; lsp-ui-sideline
    (lsp-ui-sideline-enable . nil)
    (lsp-ui-sideline-ignore-duplicate . t)
    (lsp-ui-sideline-show-symbol . nil)
    (lsp-ui-sideline-show-hover . nil)
    (lsp-ui-sideline-show-diagnostics . nil)
    (lsp-ui-sideline-show-code-actions . nil)
    ;; lsp-ui-imenu
    (lsp-ui-imenu-enable . nil)
    (lsp-ui-imenu-kind-position . 'top)
    ;; lsp-ui-peek
    (lsp-ui-peek-enable . t)
    (lsp-ui-peek-always-show . t)
    (lsp-ui-peek-peek-height . 30)
    (lsp-ui-peek-list-width . 30)
    (lsp-ui-peek-fontify . 'always)
    :hook
    (lsp-mode-hook . lsp-ui-mode)
    :bind
    (("C-l s"   . lsp-ui-sideline-mode)
     ("C-l C-d" . lsp-ui-peek-find-definitions)
     ("C-l C-r" . lsp-ui-peek-find-references)))

  (leaf company-lsp
    :ensure t
    :commands company-lsp company
    :custom
    (company-lsp-cache-candidates . nil)
    (company-lsp-async . t)
    (company-lsp-enable-recompletion . t)
    (company-lsp-enable-snippet . t)
    :after
    (:all lsp-mode lsp-ui company yasnippet)
    ;; lsp-treema
    ;; treemacs
    (leaf lsp-treemacs :ensure t)  
    )
  )

(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map
         ("C-c c" . compile))
  :mode-hook
  (c-mode-hook . ((c-set-style "bsd")
                  (setq c-basic-offset 4)))
  (c++-mode-hook . ((c-set-style "bsd")
                    (setq c-basic-offset 4))))

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :global-minor-mode delete-selection-mode)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)


(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :custom ((kill-ring-max . 100)
           (kill-read-only-ok . t)
           (kill-whole-line . t)
           (eval-expression-print-length . nil)
           (eval-expression-print-level . nil)))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 15)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
            (version-control . t)
            (delete-old-versions . t)))

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

(leaf ivy
  :doc "Incremental Vertical completYon"
  :req "emacs-24.5"
  :tag "matching" "emacs>=24.5"
  :url "https://github.com/abo-abo/swiper"
  :emacs>= 24.5
  :ensure t
  :blackout t
  :leaf-defer nil
  :custom ((ivy-initial-inputs-alist . nil)
           (ivy-re-builders-alist . '((t . ivy--regex-fuzzy)
                                      (swiper . ivy--regex-plus)))
           (ivy-use-selectable-prompt . t))
  :global-minor-mode t
  :config
  
  (leaf swiper
    :doc "Isearch with an overview. Oh, man!"
    :req "emacs-24.5" "ivy-0.13.0"
    :tag "matching" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :bind (("C-s" . swiper)))

  (leaf counsel
    :doc "Various completion functions using Ivy"
    :req "emacs-24.5" "swiper-0.13.0"
    :tag "tools" "matching" "convenience" "emacs>=24.5"
    :url "https://github.com/abo-abo/swiper"
    :emacs>= 24.5
    :ensure t
    :blackout t
    :bind (("C-S-s" . counsel-imenu)
           ("C-x C-r" . counsel-recentf))
    :custom `((counsel-yank-pop-separator . "\n----------\n")
              (counsel-find-file-ignore-regexp . ,(rx-to-string '(or "./" "../") 'no-group)))
    :global-minor-mode t))

(leaf ivy-rich
  :doc "More friendly display transformer for ivy."
  :req "emacs-24.5" "ivy-0.8.0"
  :tag "ivy" "emacs>=24.5"
  :emacs>= 24.5
  :ensure t
  :after ivy
  :global-minor-mode t)

(leaf prescient
  :doc "Better sorting and filtering"
  :req "emacs-25.1"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :commands (prescient-persist-mode)
  :custom `((prescient-aggressive-file-save . t)
            (prescient-save-file . ,(locate-user-emacs-file "prescient")))
  :global-minor-mode prescient-persist-mode)

(leaf ivy-prescient
  :doc "prescient.el + Ivy"
  :req "emacs-25.1" "prescient-4.0" "ivy-0.11.0"
  :tag "extensions" "emacs>=25.1"
  :url "https://github.com/raxod502/prescient.el"
  :emacs>= 25.1
  :ensure t
  :after prescient ivy
  :custom ((ivy-prescient-retain-classic-highlighting . t))
  :global-minor-mode t)

(leaf magit
  :ensure t
  :bind ("C-x g" . magit-status)
  )

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "let-alist-1.0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode" "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error))
  :global-minor-mode global-flycheck-mode)

(leaf company
  :doc "Modular text completion framework"
  :req "emacs-24.3"
  :tag "matching" "convenience" "abbrev" "emacs>=24.3"
  :url "http://company-mode.github.io/"
  :emacs>= 24.3
  :ensure t
  :blackout t
  :leaf-defer nil
  :bind ((company-active-map
          ("M-n" . nil)
          ("M-p" . nil)
          ("C-s" . company-filter-candidates)
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)
          ("<tab>" . company-complete-selection))
         (company-search-map
          ("C-n" . company-select-next)
          ("C-p" . company-select-previous)))
  :custom ((company-idle-delay . 0)
           (company-minimum-prefix-length . 1)
           (company-transformers . '(company-sort-by-occurrence)))
  :global-minor-mode global-company-mode)

(leaf company-c-headers
  :doc "Company mode backend for C/C++ header files"
  :req "emacs-24.1" "company-0.8"
  :tag "company" "development" "emacs>=24.1"
  :added "2020-03-25"
  :emacs>= 24.1
  :ensure t
  :after company
  :defvar company-backends
  :config
  (add-to-list 'company-backends 'company-c-headers))

(leaf highlight-indent-guides
  :ensure t
  :require t
  :custom
  (highlight-indent-guides-method . 'character)
  (highlight-indent-guides-auto-character-face-perc . 20)
  (highlight-indent-guides-character . ?\|)
  :hook
  (prog-mode-hook . highlight-indent-guides-mode))

(leaf neotree
  :ensure t
  :bind ("H-t" . neotree-toggle))

(leaf uniquify
  :custom
  ((uniquify-buffer-name-style . 'post-forward-angle-brackets)
   (uniquify-min-dir-content   . 1))
  )

(leaf linum
  :doc "display line numbers in the left margin"
  :tag "builtin"
  :added "2020-08-27"
  :init (global-linum-mode 1))

(leaf hl-line
  :hook
  (emacs-startup-hook . global-hl-line-mode))

(leaf electric
  :doc "window maker and Command loop for `electric' modes"
  :tag "builtin"
  :added "2020-08-27"
  :init (electric-pair-mode 1))

(leaf all-the-icons
  :ensure t
  :init (leaf memoize :ensure t)
  :custom
  ((all-the-icons-scale-factor   . 0.9)
   (all-the-icons-default-adjust . 0.0))
  :config
  (leaf all-the-icons-ivy
    :ensure t
    :hook (after-init-hook . all-the-icons-ivy-setup)))

(leaf smart-mode-line
  :ensure t
  :custom ((sml/no-confirm-load-theme . t)
           (sml/theme . 'dark)
           (sml/shorten-directory . -1))
  :config
  (sml/setup))

(leaf-keys (("C-h"     . backward-delete-char)
            ("C-;"     . comment-region)
            ("C-S-;"   . uncomment-region)
            ("C-/"     . undo)
            ("<home>"  . beginning-of-buffer)
            ("<end>"   . end-of-buffer)))

(leaf rainbow-mode
  :ensure t
  :blackout `((rainbow-mode . ,(format " %s" "\x1F308")))
  )

(leaf rainbow-delimiters
  :ensure t
  :blackout t
  :hook (prog-mode-hook . rainbow-delimiters-mode)
  )

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
