;; Based on https://github.com/rexim/dotfiles/blob/master/.emacs
(tool-bar-mode 0)
(menu-bar-mode 0)
(column-number-mode 1)
(display-line-numbers-mode 1)
(global-display-line-numbers-mode 1)

;; Font
(defun rc/get-default-font ()
  (cond
    ((eq system-type 'darwin) "ZedMono Nerd Font Mono-16")
    ((eq system-type 'gnu/linux) "ZedMono Nerd Font Mono-16")
  )
)

(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))

