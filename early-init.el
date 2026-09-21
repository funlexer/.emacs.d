;;; early-init.el --- Early init -*- lexical-binding: t; -*-
(setq package-enable-at-startup nil)

;; 파일 선택 대화상자 대신 미니버퍼 사용
(setq use-file-dialog nil
      use-dialog-box nil)

(setq x-gtk-use-native-input nil)

;; 프레임을 처음부터 UI 없이 생성
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq frame-inhibit-implied-resize t)

(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (setq native-comp-async-report-warnings-errors 'silent)

  (setq native-comp-jit-compilation t
        native-comp-jit-compilation-deny-list '("my\\.el\\'" "conf\\.el\\'"))

  (when (boundp 'package-native-compile)
    (setq package-native-compile t)))
