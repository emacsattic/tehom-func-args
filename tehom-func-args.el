;;; tehom-func-args.el --- Expand almost any known elisp function to a template.

;; Copyright (C) 1999 by Free Software Foundation, Inc.

;; Author: Tom Breton <Tehom@localhost>
;; Keywords: extensions

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; 

;;; Known bugs: Because of the way it works, it can fail on functions
;;; where "documentation" returns something that doesn't end at or
;;; near a function template.

;;; Code:

(require 'local-vars)

;;This function is mostly borrowed from help.el.
( defun tehom-get-any-func ()
  "Get the name of a known elisp function."

  (let 
    ((fn (function-called-at-point))
      (enable-recursive-minibuffers t)	     
      val)
    (setq val 
      (completing-read 
	(if fn
	  (format "Describe function (default %s): " fn)
	  "Describe function: ")
	obarray 'fboundp t))
    ( if (equal val "")
      fn (intern val))))

;;;###autoload
(defun tehom-insert-func ( func)
  "Expand a function into a template."
  (interactive (list (tehom-get-any-func)))
  
  (using-local-vars

    (local-var my-string (documentation func)) ;;'ad-Orig-documentation

    (local-var buf (generate-new-buffer " *Function description buffer*" ) )

    (local-var func-name-string nil)
    (local-var end-pos nil)

    (save-excursion
      (set-buffer buf)
      (insert my-string)
      (goto-char (point-max))
      (search-backward ")" )
      (forward-char 1)
      (setq end-pos (point))
      (backward-list 1)

      (setq func-name-string 
	(buffer-substring (point) end-pos)))
    
    ;;Kill the temp buffer.
    (kill-buffer buf)

    (insert func-name-string)))

(provide 'tehom-func-args)

;;; tehom-func-args.el ends here