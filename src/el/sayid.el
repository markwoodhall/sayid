(defun sayid-query-form-at-point ()
  (interactive)
  (let ((x (read (nrepl-dict-get (nrepl-send-sync-request (list "op" "sayid-query-form-at-point"
                                                                "file" (buffer-file-name)
                                                                "line" (line-number-at-pos)))
                                 "value")))
        (orig-buf (current-buffer)))
    (pop-to-buffer "*sayid*")
    (erase-buffer)
    (insert x)
    (recenter -1)
    (ansi-color-apply-on-region (point-min) (point-max))
    (print orig-buf)
    (pop-to-buffer orig-buf)))


(defun sayid-force-get-inner-trace ()
  (interactive)
  (let ((x (read (nrepl-dict-get (nrepl-send-sync-request (list "op" "sayid-force-get-inner-trace"
                                                                "source" (buffer-string)
                                                                "file" (buffer-file-name)
                                                                "line" (line-number-at-pos)))
                                 "value")))
        (orig-buf (current-buffer)))
    (pop-to-buffer "*sayid*")
    (erase-buffer)
    (insert x)
    (recenter -1)
    (ansi-color-apply-on-region (point-min) (point-max))
    (pop-to-buffer orig-buf)))

(defun sayid-eval-last-sexp ()
  (interactive)
  (nrepl-send-sync-request (list "op" "sayid-clear-log"))
  (nrepl-send-sync-request (list "op" "sayid-trace-all-ns-in-dir"
                                 "dir"(file-name-directory (buffer-file-name))))
  (message (cider-last-sexp))
  (cider-eval-last-sexp)
  (nrepl-send-sync-request (list "op" "sayid-remove-all-traces"))
  (let ((orig-buf (current-buffer)))
    (pop-to-buffer "*sayid*")
    (erase-buffer)
    (insert (read (nrepl-dict-get (nrepl-send-sync-request (list "op" "sayid-get-workspace"))
                                  "value")))
    (recenter -1)
    (ansi-color-apply-on-region (point-min) (point-max))
    (pop-to-buffer orig-buf)))
