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


(tramp-rclone-send-command "reorg" "ls")



(defun my-pick-one ()
  "Prompt user to pick a choice from a list."
  (interactive)
  )


(defun reorg-onedrive/list-files ()
  (let ((files (shell-command-to-string "rclone ls reorg:/reorg/"))
        (file-list (list)))
    (cl-loop for file in (split-string files "\n") do
             (progn
               (setq file (string-trim file)
                     words (split-string file))
               (setq words (remove (first words) words))
               (setq file-list (cons (string-join words " ") file-list))))
    file-list)
  )


(defun reorg-onedrive/download-file ()
  (interactive)
  
  (let ((choices (reorg-onedrive/list-files)))
  (message "%s" (completing-read "Select File:" choices ))
  ))
  

(provide 'reorg-onedrive)

;;; reorg-onedrive.el ends here
