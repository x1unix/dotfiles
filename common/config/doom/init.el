(doom!
 :completion
 (vertico +icons)
 (corfu +icons +orderless)

 :ui
 doom
 doom-dashboard
 (emoji +unicode)
 hl-todo
 indent-guides
 modeline
 ophints
 (popup +defaults)
 vc-gutter
 vi-tilde-fringe
 window-select
 workspaces

 :editor
 (evil +everywhere)
 file-templates
 fold
 (format +onsave)
 snippets
 word-wrap

 :emacs
 (dired +icons)
 electric
 (ibuffer +icons)
 undo
 vc

 :term
 vterm

 :checkers
 syntax
 (spell +flyspell)

 :tools
 (debugger +lsp)
 direnv
 editorconfig
 (eval +overlay)
 lookup
 (lsp +eglot)
 magit
 make
 tree-sitter

 :lang
 emacs-lisp
 (go +lsp +tree-sitter)
 (javascript +lsp +tree-sitter)
 (json +lsp +tree-sitter)
 (lua +lsp +tree-sitter)
 markdown
 (nix +lsp)
 (python +lsp +tree-sitter)
 (rust +lsp +tree-sitter)
 sh
 (web +lsp +tree-sitter)
 yaml
 (cc +lsp +tree-sitter)
 protobuf
 terraform

 :config
 (default +bindings +smartparens))
