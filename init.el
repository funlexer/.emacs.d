;;; init.el --- My Emacs configuration -*- lexical-binding: t; -*-
(set-language-environment "UTF-8")
(setq gc-cons-percentage 0.6
      gc-cons-threshold (* 50 1000 1000) ;; 50MB
      read-process-output-max (* 1024 1024))

(setq straight-repository-branch "develop")

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	      (url-retrieve-synchronously
	       "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	       'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-check-for-modifications nil)
(setq straight-use-package-by-default t)
(straight-use-package 'use-package)

(use-package org :straight (:type built-in))

(let ((default-directory user-emacs-directory)
      (file-name-handler-alist nil)) ;; 로딩 속도 개선
  (let* ((org-file "my.org")
         (el-file  "my.el")
         (mtime (file-attribute-modification-time (file-attributes org-file))))
    (require 'org-compat)
    (require 'org-macs)
    (unless (org-file-newer-than-p el-file mtime)
      (require 'ob-tangle)
      (org-babel-tangle-file org-file el-file "emacs-lisp"))
    (load (expand-file-name el-file user-emacs-directory)))

  (let ((pers-file (expand-file-name "conf.el" user-emacs-directory)))
    (when (file-exists-p pers-file)
      (load-file pers-file)))

  (setq default-directory (expand-file-name "~")))
