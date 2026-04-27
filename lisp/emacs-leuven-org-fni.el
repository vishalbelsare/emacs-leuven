;;; FNI Org agenda dashboard

(with-eval-after-load 'org-agenda

  (defun fni-org-agenda-kill-agenda-buffers ()
    "Kill all Org Agenda buffers."
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (eq major-mode 'org-agenda-mode)
          (kill-buffer buf)))))

  (defun fni-org-agenda-dashboard ()
    "GTD dashboard focused on FNI agenda files."
    (interactive)
    (fni-org-agenda-kill-agenda-buffers)
    (let ((org-agenda-files '("~/org/FNI-task-list.org"
                              "~/org/51-People-Calendar.org")))
      (org-agenda nil "F")))

  (defun fni-org-agenda-skip-priority-a ()
    "Skip agenda entries whose priority is A."
    (let ((priority (org-get-priority (thing-at-point 'line t))))
      (when (= priority org-priority-highest)
        (or (outline-next-heading) (point-max)))))

  (add-to-list
   'org-agenda-custom-commands
   '("F" "Fabrice GTD Dashboard"
     ((tags-todo "+urgent|PRIORITY=\"A\"|DEADLINE<=\"<+3d>\"-SCHEDULED>=\"<tomorrow>\""
                 ((org-agenda-overriding-header "‼ Do IMMEDIATELY")
                  (org-agenda-sorting-strategy
                   '(deadline-up priority-down effort-up category-keep))))

      (agenda ""
              ((org-agenda-span 7)
               (org-agenda-start-day "+0d") ; "+0d" to include today.
               (org-agenda-overriding-header "▦ Next 7 Days")
               (org-deadline-warning-days 7)
               (org-agenda-sorting-strategy
                '(time-up deadline-up priority-down category-keep))
               (org-agenda-entry-types '(:scheduled :deadline :sexp))
               (org-agenda-skip-function #'fni-org-agenda-skip-priority-a)))

      (tags-todo "TODO=\"STRT\"-PRIORITY=\"A\""
                 ((org-agenda-overriding-header "▶ In Progress")
                  (org-agenda-sorting-strategy
                   '(priority-down deadline-up effort-up category-keep))))

      (tags-todo "TODO=\"NEXT\"-PRIORITY=\"A\"-urgent-SCHEDULED>=\"<tomorrow>\""
                 ((org-agenda-overriding-header "➜ Next Actions")
                  (org-agenda-sorting-strategy
                   '(priority-down deadline-up effort-up category-keep))))

      (tags-todo "TODO=\"WAIT\"-PRIORITY=\"A\""
                 ((org-agenda-overriding-header "Ⅱ Waiting For")
                  (org-agenda-sorting-strategy
                   '(deadline-up priority-down category-keep))))

      (tags-todo "TODO=\"TODO\"|TODO=\"MAYB\"-PRIORITY=\"A\"-urgent-SCHEDULED>=\"<tomorrow>\""
                 ((org-agenda-overriding-header "⋯ To Clarify/Plan")
                  (org-agenda-sorting-strategy
                   '(priority-down category-keep effort-up)))))

     ;; Global options for this custom agenda.
     ((org-agenda-prefix-format
       '((agenda  . " %-12:c%?-12t %e ")
         (todo    . " %-12:c ")
         (tags    . " %-12:c ")
         (search  . " %-12:c ")))
      (org-agenda-todo-ignore-scheduled 'future)
      (org-agenda-todo-ignore-deadlines 'near)   ; ou nil si tu veux tout voir
      (org-agenda-tags-todo-honor-ignore-options t)
      (org-agenda-dim-blocked-tasks nil))))

  (defun fni-org-agenda-dashboard-current-buffer ()
    "GTD dashboard based on the current buffer's file."
    (interactive)
    (unless buffer-file-name
      (user-error "The current buffer is not associated with a file"))
    (fni-org-agenda-kill-agenda-buffers)
    (let ((org-agenda-files (list buffer-file-name)))
      (org-agenda nil "F"))))
