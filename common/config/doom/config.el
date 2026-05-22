;; -*- lexical-binding: t; -*-

;;; Fonts

(setq doom-font (font-spec :family "Iosevka NFM" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka NFM" :size 14)
      doom-symbol-font (font-spec :family "Iosevka NFM"))

;;; Editor defaults

(setq-default
 tab-width 2
 indent-tabs-mode nil
 scroll-margin 5
 hscroll-margin 5
 display-line-numbers-type 'relative)

(setq make-backup-files nil
      create-lockfiles nil
      auto-save-default nil
      x-select-enable-clipboard t
      split-window-right t
      split-window-below t)

(global-hl-line-mode 1)
(global-display-line-numbers-mode 1)

;;; Theme

(setq doom-theme 'vscode-dark-plus)

(use-package! auto-dark
  :config
  (setq auto-dark-light-theme 'doom-one-light
        auto-dark-dark-theme 'vscode-dark-plus)
  (auto-dark-mode 1))

;;; AI (opt-in)

(defvar my/ai-enabled nil)

(when my/ai-enabled
  (use-package! gptel)
  (use-package! copilot
    :hook (prog-mode . copilot-mode)
    :config
    (map! :i "<tab>" #'copilot-accept-completion-or-indent)))

;;; Search

(after! consult
  (setq consult-async-min-input 1))

;;; Formatters

(after! apheleia
  (setf (alist-get 'go-ts-mode apheleia-mode-alist) '(gofumpt goimports))
  (setf (alist-get 'sh-mode apheleia-mode-alist) 'shfmt)
  (setf (alist-get 'python-ts-mode apheleia-mode-alist) '(isort black))
  (setf (alist-get 'protobuf-mode apheleia-mode-alist) 'buf-fmt))
(apheleia-global-mode 1)

;;; Debug (dape)

(after! dape
  (map! :map dape-mode-map
        "<f5>" #'dape
        "<f8>" #'dape-next
        "<f7>" #'dape-step-in
        "<f9>" #'dape-step-out
        :leader
        (:prefix ("d" . "debug")
         "d" #'dape
         "R" #'dape-restart
         "q" #'dape-quit
         "b" #'dape-breakpoint-toggle
         "B" #'dape-breakpoint-expression
         "l b" #'dape-breakpoint-log
         "e" #'dape-repl
         "h" #'dape-info-hover)))

;;; Test runner (per major-mode)

(defun my/test-current ()
  (interactive)
  (pcase major-mode
    ('go-ts-mode (go-test-current-test))
    ('rustic-mode (rustic-cargo-test))
    (_ (compile "npm test"))))

(defun my/test-file ()
  (interactive)
  (pcase major-mode
    ('go-ts-mode (go-test-current-file))
    ('rustic-mode (rustic-cargo-test))
    (_ (compile "npm test"))))

(map! :leader
      (:prefix ("t" . "test")
       "t" #'my/test-current
       "f" #'my/test-file))

;;; Worktree session persistence

(after! magit
  (advice-add 'magit-worktree-checkout :before
              (lambda (&rest _) (persp-save-state-to-file)))
  (advice-add 'magit-worktree-checkout :after
              (lambda (&rest _) (persp-load-state-from-file))))

;;; Keybindings

(map! :leader
      "f e" #'dired-jump
      "g w s" #'magit-worktree-status
      "g w a" #'magit-worktree-add
      "g w d" #'magit-worktree-delete)

;;; Tree-sitter extras

(after! treesit
  (setq treesit-language-source-alist
        '((jsonnet "https://github.com/sourcegraph/tree-sitter-jsonnet")
          (alloy   "https://github.com/mattsre/tree-sitter-alloy"))))

;;; Filetype detection

(add-to-list 'auto-mode-alist '("\\.gno\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("buf\\.\\(gen\\|work\\)\\.ya?ml\\'" . yaml-ts-mode))
