(require 'ert)
(require 'org-toodledo)

(defun org-toodledo-test-setup-buffer (name)
  (let ((buf (get-buffer-create name)))
    (set-buffer buf)
    (erase-buffer)
    (when (not (eq major-mode 'org-mode))
      (org-mode))
    (insert "* TASKS
** TODO [#D] Test1            :@work:
    DEADLINE: <2015-02-07 土 +1m>
    :PROPERTIES:
    :ToodledoID: 393655887
    :Hash:     ad0d9f84a6a204e051925805181ed137
    :Parent-id:
    :LAST_REPEAT: [2015-01-14 水 16:52]
    :END:
** WAITING [#D] Test2  :@work:
     :PROPERTIES:
     :ToodledoID: 393773069
     :Hash:     3da632c2b88319569f648c35506cf0ba
     :Parent-id:
     :END:")))

(defun org-toodledo-parse-test ()
  "Parse the org task at point and extract all toodledo related fields.  Return
an alist of the task fields."
   (save-excursion
    (org-back-to-heading t)
    (when (and (looking-at org-complex-heading-regexp)
               (match-string 2)) ;; the TODO keyword
      (org-toodledo-debug "org-toodledo-parse-current-task: %s"
                          (match-string 0))
      (let* (info
             (status (match-string-no-properties 2))
             (priority (match-string-no-properties 3))
             (title (match-string-no-properties 4))
             (tags-context (org-get-tags))
             (id (org-entry-get (point) "ToodledoID"))
             (deadline (org-entry-get nil "DEADLINE"))
             (scheduled (org-entry-get nil "SCHEDULED"))
             (closed (org-entry-get nil "CLOSED"))
             (context "0")
             tags)
             status))))

(ert-deftest org-toodledo-initialize-test ()
  (setq expected '(("duetime" . "0")
                   ("duedate" . "0")
                   ("starttime" . "0")
                   ("startdate" . "0")
                   ("repeatfrom" . "0")
                   ("repeat" . "")
                   ("goal" . "0")
                   ("folder" . "0")
                   ("id" . "393773069")
                   ("title" . "Test2")
                   ("length" . "0")
                   ("context" . "1200627")
                   ("tag" . "")
                   ("completed" . "0")
                   ("status" . "5")
                   ("priority" . "0")
                   ("note" . "")))
    (org-toodledo-test-setup-buffer "*test*")
    (setq actual (org-toodledo-parse-current-task)
    (should (equal expected (org-toodledo-parse-test)))))
