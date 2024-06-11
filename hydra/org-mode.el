(defhydra hydra-org-mode (:color blue)
  "
  _l_: Links
  _t_: TODO Items
  _T_: Tables
  _d_: Dates/Times
  _c_: Capture/Attachments
  "
  ("l" hydra-org-link/body)
  ("t" hydra-org-todo/body)
  ("T" hydra-org-table/body)
  ("d" hydra-org-dates/body)
  ("c" hydra-org-capture/body))

(defhydra hydra-org-link (:color blue)
  "
  ^Links^
  ---------------------------------
  _o_: Open Link
  _i_: Insert Link
  _e_: Edit Link
  "
  ("o" org-open-at-point)
  ("i" org-insert-link)
  ("e" org-edit-headline))

(defhydra hydra-org-todo (:color blue)
  "
  ^TODO Items^
  ---------------------------------
  _t_: Toggle TODO
  _d_: Deadline
  _n_: Next TODO
  "
  ("t" org-todo)
  ("d" org-deadline)
  ("n" org-next-item))

(defhydra hydra-org-table (:color blue)
  "
  ^Tables^
  ---------------------------------
  _i_: Insert Table
  _a_: Align Table
  _e_: Edit Table
  "
  ("i" org-table-insert-table)
  ("a" org-table-align)
  ("e" org-table-edit-field))

(defhydra hydra-org-dates (:color blue)
   "
   ^Dates/Times^
   ---------------------------------
   _s_: Schedule
   _d_: Insert Date
   _t_: Show All TODOs
   "
   ("s" org-schedule)
   ("d" org-date-from-calendar)
   ("t" org-show-todo-tree))

(defhydra hydra-org-capture (:color blue)
   "
   ^Capture/Attachments^
   ---------------------------------
   _c_: Capture
   _a_: Attach File
   _z_: Screenshot
   "
   ("c" org-capture)
   ("a" org-attach-attach)
   ("z" org-download-screenshot))

(global-set-key (kbd "C-c o") 'hydra-org-mode/body)
