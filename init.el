;;; init.el --- My Emacs configuration -*- lexical-binding: t; -*-
(set-language-environment "UTF-8")

;; 시작 동안만 GC 를 늦춘다
(setq gc-cons-percentage 0.6
      gc-cons-threshold most-positive-fixnum
      read-process-output-max (* 4 1024 1024))

;; 시작이 끝나면 정상 범위로 되돌린다.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-percentage 0.1
                  gc-cons-threshold (* 32 1024 1024))))

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

(defvar u/straight-prefer-external '()
  "번들보다 straight 것을 써야 하는 패키지.")
(setq straight-built-in-pseudo-packages
      (append straight-built-in-pseudo-packages
              (seq-difference (mapcar #'car package--builtin-versions)
                              u/straight-prefer-external)))


;; 갱신은 straight-pull-package + straight-rebuild-package 로 명시적으로 수행.
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
      (load-file pers-file))))

(setq default-directory (expand-file-name "~"))
