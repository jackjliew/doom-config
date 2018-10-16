;;;  -*- lexical-binding: t; -*-

(defvar blog-admin-dir ""
  "blog-admin files location")

(add-hook! 'text-mode-hook (setq-local truncate-lines nil))

;; /////////////////////////// ORG /////////////////////////////////
(setq org-ellipsis "  "
      org-agenda-files '("~/Dropbox/Org-Notes")
      blog-admin-dir "~/Developer/Github/hexo_blog")

(setq org-capture-templates
      '(
        ("d" "Diary" entry
         (file+olp+datetree "diary.org")
         "* %?" :kill-buffer t)
        ("n" "Notes" entry
         (file+headline +org-default-notes-file "Inbox")
         "* %u %?\n%i" :prepend t :kill-buffer t)
        ("t" "Todo" entry
         (file+headline +org-default-todo-file "Inbox")
         "* [ ] %?\n%i" :prepend t :kill-buffer t)
        ))

;; ///////////////////////////// MARKDOWN /////////////////////////////
(after! markdown-mode
  ;; memo: install grip > ‘pip3 install grip‘
  (defvar +my/markdown-process nil)
  (defun +my/markdown-preview (&rest _)
    "Preview markdown file by using grip."
    (when (process-live-p +my/markdown-process)
      (kill-process +my/markdown-process))
    (setq +my/markdown-process
          (start-process-shell-command "grip markdown-preview"
                                       markdown-output-buffer-name
                                       (format "grip --browser '%s'" (buffer-file-name)))))

  ;; Use advice to use preview at both markdown-mode and gfm-mode.
  (when (executable-find "grip")
    (advice-add 'markdown-preview :override '+my/markdown-preview))
  )