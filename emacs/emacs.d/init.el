;; -*- coding: utf-8; lexical-binding: t -*-

;;; ***********************************************************************************************************************************
;;; Emacs generic configurations
;;; -----------------------------------------------------------------------------------------------------------------------------------
;;; Author: gmu113r@duck.com
;;; ***********************************************************************************************************************************

;;; Many of Emacs’s defaults are ill-suite, but the first one that needs fixing is the shockingly low garbage-collection threshold, which defaults to a paltry 8kb. Setting it to 100mb seems to strike a nice balance between GC pauses and performance. We also need to bump the number of bindings/unwind-protects (max-specpdl-size).
(setq gc-cons-threshold 100000000)
(setq max-specpdl-size 5000)

;;; It’s good that Emacs supports the wide variety of file encodings it does, but UTF-8 should always, always be the default.
(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)

;;; Emacs is super fond of littering filesystems with backups and autosaves, since it was built with the assumption that multiple users could be using the same Emacs instance on the same filesystem. This was valid in 1980. It is no longer the case.
(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

;;; By default, Emacs stores any configuration you make through its UI by writing custom-set-variables invocations to your init file, or to the file specified by custom-file. Though this is convenient, it’s also an excellent way to cause aggravation when the variable you keep trying to modify is being set in some custom-set-variables invocation. We can disable this by mapping it to a temporary file. (I used to map this to /dev/null, but this started causing a bunch of inane save dialogues.)
(setq custom-file (make-temp-name "/tmp/"))

;;; ELPA is a package system (Emacs Lisp Package Archive). It lets you install and manage emacs packages. MELPA is elisp package repository, maintained by others.
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;; The use-package macro allows you to set up package customization in your init file in a declarative way. It takes care of many things for you that would otherwise require a lot of repetitive boilerplate code. It can help with common customization, such as binding keys, setting up hooks, customizing user options and faces, autoloading, and more. It also helps you keep Emacs startup fast, even when you use maony (even hundreds) of packages. (https://www.gnu.org/software/emacs/manual/html_node/use-package/index.html)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
;;; Fixing some default values
(setq
 ;; No need to see GNU agitprop.
 inhibit-startup-screen t
 ;; No need to remind me what a scratch buffer is.
 initial-scratch-message nil
 ;; Double-spaces after periods is morally wrong.
 sentence-end-double-space nil
 ;; Never ding at me, ever.
 ring-bell-function 'ignore
 ;; Prompts should go in the minibuffer, not in a GUI.
 use-dialog-box nil
 ;; accept 'y' or 'n' instead of yes/no
 ;; the documentation advises against setting this variable
 ;; the documentation can get bent imo
 use-short-answers t
 ;; highlight error messages more aggressively
 next-error-message-highlight t
 ;; don't let the minibuffer muck up my window tiling
 read-minibuffer-restore-windows t
;; when I say to quit, I mean quit
 confirm-kill-processes nil)

;;; Every Emacs window should, by default occupy all the screen space it can.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;; Window chrome both wastes space and looks unappealing. (This is actually pasted into the first lines of my Emacs configuration so I never have to see the UI chrome, but it is reproduced here for the sake of people who might be taking this configuration for a spin themselves.)
(when (window-system)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (pixel-scroll-mode))
(when (eq system-type 'darwin)
  (setq ns-auto-hide-menu-bar t))

;;; IDO Mode
(ido-mode t)
(ido-everywhere t)
(setq ido-use-virtual-buffers t)

;;; Visual-Line-Mode
(visual-line-mode t)
(delete-selection-mode t)

;;; line numbers
(setq display-line-numbers-type 'relative) 
(global-display-line-numbers-mode)

;;; Gruber Darker Theme
;;; https://github.com/rexim/gruber-darker-theme
(load-theme 'gruber-darker t)
(set-frame-font "Iosevka 13" nil t)

;;; ***********************************************************************************************************************************
;;; Magit: https://systemcrafters.net/mastering-git-with-magit/introduction/
;;; -----------------------------------------------------------------------------------------------------------------------------------
(use-package magit
  :ensure t)

;;; ***********************************************************************************************************************************
;;; Evil is an extensible vi layer for Emacs. It provides Vim features like Visual selection and text objects.(https://www.emacswiki.org/emacs/Evil)
;;; -----------------------------------------------------------------------------------------------------------------------------------
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode t))

(use-package evil-collection
  :ensure t
  :after evil
  :init
  (evil-collection-init))

;;; ***********************************************************************************************************************************
;;; ORG Mode
;;; -----------------------------------------------------------------------------------------------------------------------------------
(use-package org
  :bind (("C-c o c" . org-capture)
         ("C-c o a" . org-agenda)
         :map org-mode-map
         ("M-<left>" . nil)
         ("M-<right>" . nil)
         ("C-c c" . #'org-mode-insert-code)
         ("C-c a f" . #'org-shifttab)
         ("C-c a S" . #'zero-width))
  :custom
  (org-adapt-indentation nil)
  (org-directory "~/Documents")
  (org-special-ctrl-a/e t)

  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-return-follows-link t)
  (org-src-ask-before-returning-to-edit-buffer nil "org-src is kinda needy out of the box")
  (org-src-window-setup 'current-window)
  (org-agenda-files (list (concat org-directory "/todo.org")))
  (org-pretty-entities t)
  :config)
