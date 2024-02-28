;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! ess
  (add-hook! 'prog-mode-hook #'rainbow-delimiters-mode)
  (add-hook! 'prog-mode-hook #'display-fill-column-indicator-mode)
  ;; We don’t want R evaluation to hang the editor
  (setq ess-eval-visibly 'nowait)
  (setq ess-set-style 'RStudio-)
  ;; Hoobly Classifieds, Pittsburgh, PA
  ;; (setq ess--CRAN-mirror "https://cran.mirrors.hoobly.com/")
  ;; National Institute for Computational Sciences, Oak Ridge, TN
  (setq ess--CRAN-mirror "https://mirrors.nics.utk.edu/cran/")
  ;; Statlib, Carnegie Mellon University, Pittsburgh, PA
  ;; (setq ess--CRAN-mirror "http://lib.stat.cmu.edu/R/CRAN/")
  ;; enable syntax highlighing in R
  (setq ess-R-font-lock-keywords
        '((ess-R-fl-keyword:keywords . t)
          (ess-R-fl-keyword:constants . t)
          (ess-R-fl-keyword:modifiers . t)
          (ess-R-fl-keyword:fun-defs . t)
          (ess-R-fl-keyword:assign-ops . t)
          (ess-R-fl-keyword:%op% . t)
          (ess-fl-keyword:fun-calls . t)
          (ess-fl-keyword:numbers . t)
          (ess-fl-keyword:operators . t)
          (ess-fl-keyword:= . t)
          (ess-R-fl-keyword:F&T . t)))

  (setq comint-move-point-for-output t)
  (add-hook! 'inferior-ess-mode-hook
    (setq ansi-color-for-comint-mode 'filter))
  (add-hook 'inferior-ess-mode-hook #'doom-mark-buffer-as-real-h))

(set-popup-rules!
  '(("*R$" :side left :height 1 :width .5)
    ("^R:" :side right :height 1 :width .5)
    ("*help" :side bottom :height .5 :width .5)

    )
  )

(map! :after ess
      :map ess-mode-map
      :n [C-return] #'ess-eval-region-or-line-and-step
      :n [C-c C-c] #'ess-eval-region-or-line-and-step)

(setq ess-use-flymake nil) ;; disable Flymake

(add-to-list 'auto-mode-alist
             '("\\.[rR]md\\'" . poly-gfm+r-mode))
(setq markdown-code-block-braces t)

(use-package! lsp-bridge
  :config
  (setq lsp-bridge-enable-log nil)
  ;; (global-lsp-bridge-mode)
)
(setq lsp-bridge-completion-obey-trigger-characters-p nil)
;; (setq lsp-bridge-enable-completion-in-string 1)
;; (setq acm-backend-search-file-words-max-number 100)

;; jupyter also have completion, so this disable jupyter completion
(add-hook 'python-mode-hook (lambda() (lsp-bridge-mode 1)))

 (add-hook 'python-mode-hook (lambda() (company-mode 0)))

 (add-hook 'python-mode-hook (lambda ()
                               (setq python-indent 4)))

(add-hook 'python-mode-hook (lambda () (flymake-mode -1)))
(add-hook 'python-mode-hook (lambda () (flycheck-mode -1)))
(map! :after python
      :map python-mode-map
      :n [C-c C-c] #'python-shell-send-region
      :n [C-c C-c] #'python-shell-send-statement
      :n [C-return] #'python-shell-send-region
      :n [C-return] #'python-shell-send-statement)

(setq jupyter-repl-echo-eval-p t)
(setq native-comp-jit-compilation-deny-list '("jupyter.*.el"))

