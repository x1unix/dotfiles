;; -*- no-byte-compile: t; -*-

;; Navigation
(package! avy)

;; Tree-sitter extras
(package! evil-textobj-tree-sitter)
(package! combobulate)
(package! treesit-fold)
(package! topsy)

;; Git
(package! diff-hl)

;; Formatters
(package! apheleia)

;; Debug
(package! dape)

;; AI (gated by my/ai-enabled)
(package! gptel)
(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

;; Theme
(package! vscode-dark-plus-theme)
(package! auto-dark)

;; Language extras
(package! gotest)
(package! visual-fill-column)
(package! jsonnet-mode)
