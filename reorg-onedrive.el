;;; reorg-onedrive.el --- An emacs-remarkable integration via one-drive -*- lexical-binding: t -*-

;; Author: Daniel Rosel
;; Maintainer: Daniel Rosel
;; Version: 0.1.0
;; Package-Requires: (request)
;; Homepage: https://github.com/velocitatem/reorg
;; Keywords: org-mode emacs remarkable onedrive


;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:

;; commentary

;;; Code:


;; this will be one hell of a hack


(defun reorg-onedrive/list-files ()
  (let ((files  (shell-command-to-string "rclone ls reorg:/reorg/")) ;; get both the root and /reorg
        (files-root (shell-command-to-string "rclone ls reorg:/ --max-depth 1"))
        (file-list (list)))
    ;; not very nice, but im kinda tired
    (cl-loop for file in (split-string files-root "\n") do
             (progn
               (setq file (string-trim file)
                     words (split-string file))
               (setq words (remove (first words) words))
               (setq file-list (cons (string-join words " ") file-list))))
    (cl-loop for file in (split-string files "\n") do
             (progn
               (setq file (string-trim file)
                     words (split-string file))
               (setq words (remove (first words) words))
               (setq file-list (cons (concat "reorg/"(string-join words " ")) file-list))))
    (setq file-list (remove "reorg/" file-list))
    file-list)
  )

(reorg-onedrive/list-files)


(defun clean-file-name (file-name)
  (replace-regexp-in-string " " "\\ " file-name nil t))

(clean-file-name "Quick Sheets")

(defun rclone-sync-file (file)
  (interactive)
  (let ((destintion (read-directory-name "Enter Destination Directory: ")))
    (progn
      (shell-command (concat "rclone sync reorg:/" (clean-file-name file) " " destintion))
      (concat destintion file)) 
  ))



(defun rclone-upload-file (file)
  (interactive)
  (shell-command (concat "rclone copy " file " reorg:/reorg/"))
  )


(defun reorg-onedrive/download-file ()
  (interactive)
  (let ((choices (reorg-onedrive/list-files)))
    (let ((file-to-download (completing-read "Select File [DOWNLOAD]:" choices )))
      ;; now download
      (progn
        (message file-to-download)
        (find-file (rclone-sync-file file-to-download))
        )
      )
  ))
  

(defun reorg-onedrive/upload-file ()
  (interactive)
  (let ((file-to-upload (read-file-name "Select File [UPLOAD]: ")))
    (progn
      (rclone-upload-file file-to-upload))))




(defvar org-export-to-pdf-function 'org-latex-export-to-pdf)

(defun reorg-onedrive/org-send-buffer-to-remarkable ()
  (interactive)
  (let ((current-buffer-mode (format "%s" major-mode)))
    (if (equal current-buffer-mode "org-mode")
        (progn
          (let ((exported-pdf-file (org-latex-export-to-pdf)))
            (rclone-upload-file exported-pdf-file)))
      (progn
        (message "can only run in org-mode"))))
  
  )

(defun reorg-onedrive/org-send-file-to-remarkable ()
  (interactive)
  (let ((file-to-open (read-file-name "Select File [UPLOAD]: ")))
    (org-open-file file-to-open)
    (reorg-onedrive/org-send-buffer-to-remarkable)))


(provide 'reorg-onedrive)

;;; reorg-onedrive.el ends here
