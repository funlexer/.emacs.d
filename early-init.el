(setq package-enable-at-startup nil)
(setq x-gtk-file-dialog-enabled-p nil)
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (setq native-comp-async-report-warnings-errors nil
        comp-deferred-compilation t)

  (if (boundp 'native-comp-deferred-compilation-deny-list)
      (setq native-comp-deferred-compilation-deny-list '("my.el" "conf.el"))
    (setq comp-deferred-compilation-deny-list '("my.el" "conf.el")))

  (when (boundp 'package-native-compile)
    (setq package-native-compile t))

  (let ((eln-dir (expand-file-name "eln-cache" user-emacs-directory)))
    (when (file-directory-p eln-dir)
      (add-to-list 'native-comp-eln-load-path eln-dir))))
