;;; reorg.el --- reorg is a bridge between emacs(org-mode) and the remarkable cloudy -*- lexical-binding: t -*-

;; Author: Daniel Rosel
;; Maintainer: Daniel Rosel
;; Version: 0.1.0
;; Package-Requires: (emacs-request)
;; Homepage: homepage
;; Keywords: remarkable org-mode cloud emacs


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
(require 'request)


(defvar reorg-device-code nil)
(defvar reorg-bearer-token nil)
(defvar reorg-storage-api "document-storage-production-dot-remarkable-production.appspot.com")

(defun reorg/register-device ()
  (interactive)
  (browse-url-firefox "https://my.remarkable.com/#desktop") ; FIX this is not great
  (setq reorg-device-code (read-string "Enter one-time code: "))
  )

(defun reorg/connect-device ()
  (interactive)
  (setq reorg-connection-url "https://webapp-production-dot-remarkable-production.appspot.com/token/json/2/device/new"
        reorg-connection-payload-string (concat
    "{\"code\": \"" reorg-device-code "\",
    \"deviceDesc\": \"desktop-windows\",
    \"deviceID\": \"" (uuidgen-4) "\"}"))

  (request reorg-connection-url
    :type "POST"
    :data reorg-connection-payload-string
    :parser 'buffer-string
    :success (cl-function
              (lambda (&key data &allow-other-keys)
                (message "I got: %S" data)
                (setq reorg-bearer-token data)))
    )


  )



(request "https://document-storage-production-dot-remarkable-production.appspot.com/document-storage/json/2/docs"
  :type "POST"
  :data (concat "Authorization=\"Bearer " reorg-bearer-token "\"")
  :parser 'buffer-string
  :success (cl-function
            (lambda (&key data &allow-other-keys)
              (message "I got: %S" data)))

  )

(request "http://ptsv2.com/t/gww13-1656422434/post"
         :type "POST"
         ;; :data "key=value&key2=value2"  ;; this is equivalent
         :data "Some body"
         :parser 'buffer-string
         :success (cl-function
                   (lambda (&key data &allow-other-keys)
                     (message "I got: %S" data))))

(provide 'reorg)

;;; reorg.el ends here
