;; FNI Org agenda dashboard

(defun fni-org-agenda-dashboard ()
  "Dashboard GTD centré sur FNI-task-list.org"
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (eq major-mode 'org-agenda-mode)
        (kill-buffer buf))))
  (let ((org-agenda-files '("~/org/FNI-task-list.org"
                            "~/org/51-People-Calendar.org")))
    (org-agenda nil "F")))

(with-eval-after-load 'org
  (add-to-list
   'org-agenda-custom-commands
   '("F" "Fabrice GTD Dashboard"
     ((tags-todo "+urgent|PRIORITY=\"A\"|DEADLINE<=\"<+3d>\"-SCHEDULED>=\"<tomorrow>\""
                 ((org-agenda-overriding-header "‼ À faire MAINTENANT")
                  (org-agenda-sorting-strategy '(deadline-up priority-down effort-up category-keep))))

      (tags-todo "TODO=\"NEXT\"-SCHEDULED>=\"<tomorrow>\""
                 ((org-agenda-overriding-header "➜ Prochaines actions")
                  (org-agenda-sorting-strategy '(priority-down deadline-up effort-up category-keep))))

      (tags-todo "TODO=\"STRT\""
                 ((org-agenda-overriding-header "▶ En cours")
                  (org-agenda-sorting-strategy '(priority-down deadline-up effort-up category-keep))))

      (tags-todo "TODO=\"WAIT\""
                 ((org-agenda-overriding-header "Ⅱ En attente")
                  (org-agenda-sorting-strategy '(deadline-up priority-down category-keep))))

      (agenda ""
              ((org-agenda-span 'week)
               (org-agenda-start-day "+0d")               ; "+0d" si tu veux inclure aujourd'hui
               (org-agenda-overriding-header "▦ 7 prochains jours")
               (org-deadline-warning-days 7)
               (org-agenda-sorting-strategy '(time-up deadline-up priority-down category-keep))
               (org-agenda-entry-types '(:scheduled :deadline :sexp))))

      (tags-todo "TODO=\"TODO\"|TODO=\"MAYB\"-PRIORITY=\"A\"-urgent-SCHEDULED>=\"<tomorrow>\""
                 ((org-agenda-overriding-header "⋯ À clarifier / planifier")
                  (org-agenda-sorting-strategy '(priority-down category-keep effort-up)))))

     ;; options globales pour ce custom agenda
     ((org-agenda-prefix-format
       '((agenda  . " %-12:c%?-12t %e ")
         (todo    . " %-12:c ")
         (tags    . " %-12:c ")
         (search  . " %-12:c ")))
      (org-agenda-todo-ignore-scheduled 'future)
      (org-agenda-todo-ignore-deadlines 'near)   ; ou nil si tu veux tout voir
      (org-agenda-tags-todo-honor-ignore-options t)
      (org-agenda-dim-blocked-tasks nil)))))
