;;; ===========================================================
;;; line
;;; ===========================================================
(defun my-linum-mode ()
 (linum-mode)
 (setq linum-format "%4d ") ; 줄 번호 자릿수 설정 기능이다.
 (set-face-foreground 'linum "gray") ; 이 기능은 줄 번호 표시 색깔 설정이다.
)



;;; =============================================================
;;; Text Mode
;;; =============================================================
; syntax highlighting
(global-font-lock-mode t)

;; set font
;;(set-face-font 'default "-*-terminus-medium-r-normal-*-16-*-*-*-*-*-*-*")

(setq default-major-mode (quote text-mode))

(add-hook 'text-mode-hook
          (function (lambda ()
                      (setq fill-column 70)
                      (turn-on-auto-fill))))

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)
(transient-mark-mode t)

; show parenthesis matching
(show-paren-mode t)

;;; =============================================================
;;; Programming Modes
;;; =============================================================

; bsd and stroustrup is good
(setq c-default-style '((c-mode . "bsd")))
(setq c-basic-offset 4)
(setq-default indent-tabs-mode nil) ; use space instead of tab

(load-library "font-lock")
(load "cc-mode")

 
; always insert indent at ENTER-key
(define-key global-map (kbd "RET") 'newline-and-indent)

(setq auto-mode-alist
      (append
       '(("\\.C$" . c++-mode)
         ("\\.H$" . c++-mode)
         ("\\.cc$" . c++-mode)
         ("\\.cpp$" . c++-mode)
         ("\\.hh$" . c++-mode)
         ("\\.c$" . c-mode)
         ("\\.h$" . c-mode)
         ("\\.i$" . c++-mode)
         ("\\.l$" . c++-mode)
         ;; ("Makefile.$" . makefile-mode)
         ;; ("makefile.$" . makefile-mode)
         (".emacs" . lisp-mode)
         )
       auto-mode-alist))

(setq line-number-mode t) ; line number at infor bar
(add-hook 'find-file-hook (lambda () (linum-mode t))) ; line number at left margin

;; show compiler-warning on edit buffer
(global-cwarn-mode t)


;; ;;; ===================================================
;; ;;; cags
;; ;;; ==================================================
;; (setq path-to-ctags "/usr/local/bin/ctags")
;; ;;(setq path-to-ctags "/usr/local/lib")

;; (defun create-tags (dir-name)
;;      "Create tags file."
;;      (interactive "DDirectory: ")
;;      (eshell-command 
;;       (format "find %s -name \"*.cpp\" -print -or -name \"*.h\" -print | xargs etags --append" dir-name)))

;;; ===================================================
;;; etags auto refresh 
;;; ==================================================
(defadvice find-tag (around refresh-etags activate)
  "Rerun etags and reload tags if tag not found and redo find-tag.              
        If buffer is modified, ask about save before running etags."
  (let ((extension (file-name-extension (buffer-file-name))))
    (condition-case err
        ad-do-it
      (error (and (buffer-modified-p)
                  (not (ding))
                  (y-or-n-p "Buffer is modified, save it? ")
                  (save-buffer))
             (er-refresh-etags extension)
             ad-do-it))))


(defun er-refresh-etags (&optional extension)
  "Run etags on all peer files in current dir and reload them silently."
  (interactive)
  (shell-command (format "etags *.%s" (or extension "el")))
  (let ((tags-revert-without-query t))  ; don't query, revert silently          
    (visit-tags-table default-directory nil)))



;;; ===================================================
;;; Start Window
;;; ===================================================
(add-to-list 'default-frame-alist '(left . 0))
(add-to-list 'default-frame-alist '(top . 0))
;(add-to-list 'default-frame-alist '(height . 50))
;(add-to-list 'default-frame-alist '(width . 150))
(add-to-list 'default-frame-alist '(fullscreen . maximized))



;;; ===================================================
;;; TAGS
;;; ===================================================
;(setq tags-table-list
;	'("/usr/src/linux-headers-4.4.0-36" 
;	  "/usr/local/include/libusb-1.0"))

(setq tags-table-list
      '("~/linux/"
        "/usr/local/include/libusb-1.0"))



;;; ===================================================
;;; Directory
;;; ===================================================
;(setq default-directory "/media/cho/01D167823FBFAA30/Project/Linux/")
;(cd "/media/cho/01D167823FBFAA30/Project/Linux/")
;(add-hook 'find-file-hook #'(lambda () (setq default-directory (expand-file-name "/media/cho/01D167823FBFAA30/Project/Linux/"))))


;;; ===================================================
;;; key setting 
;;; ===================================================
(global-set-key [f9] 'gud-break)        ; 소스창에서 바로 브레이크포인트 설정
(global-set-key [f10] 'gud-next)        ; 현재 라인 실행하고 다음 라인으로
(global-set-key [f11] 'gud-step)        ; 현재 함수안으로 따라 들어간다
(global-set-key [(shift f11)] 'gud-finish) ; 현재 실행중인 함수 리턴후 멈춤
(global-set-key [(shift f10)] '(lambda () ; 현재 커서까지 실행하고 멈춤
                                (interactive)
                                (call-interactively 'gud-tbreak)
                                (call-interactively 'gud-cont)))
(global-set-key (kbd "C-x C-b") 'ibuffer)



;;; ===================================================
;;; MELPA 
;;; ===================================================
(require 'package)
;; (add-to-list 'package-archives
;;  	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
  	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)



;;; ===================================================
;;; Auto-complete 
;;; ===================================================
(require 'auto-complete)
(global-auto-complete-mode t)

(when (require 'auto-complete nil t)
	(global-auto-complete-mode t)
;	(set-face-background 'ac-selection-face "steelblue")
;	(set-face-background 'ac-menu-face "skyblue")
	(define-key ac-complete-mode-map "\t" 'ac-expand)
	(define-key ac-complete-mode-map "\r" 'ac-complete)
	(define-key ac-complete-mode-map "\C-\M-n" 'ac-next)
	(define-key ac-complete-mode-map "\C-\M-p" 'ac-previous)
	(setq ac-suto-start t)
	(setq ac-sources '(ac-source-yasnippet ac-source-abbrev ac-source-words-in-buffer))

	(add-to-list 'ac-modes 'eshell-mode)
	
	(add-hook 'emacs-lisp-mode-hook
		(lambda ()
			(make-local-variable 'ac-sources)
			(setq ac-sources '(ac-sources '(ac-sources-yasnippet ac-source-abbrev ac-source-files-in-current-dir ac-source-words-in buffer))))))
	
(defconst c++-keywords
	(sort
		(list "and" "bool" "compl" "do" "export" "goto" "namespace" "or_eq" "return" "struct" "try" "using" " try" " xor" "break" "const" "double" "extern" "if" "new" "private" "short" "switch" "typedef" "virtual" "xor_eq" "asm" "case" "const_cast" "dynamic_cast" "false" "inline" "not" "protected" "signed" "template" "typeid" "void" "auto" "catch" "continue" "else" "float" "int" "not_eq" "public" "sizeof" "this" "typename" "volatile" "bitand" "char" "default" "enum" "for" "long" "operator" "register" "static" "throw" "union" "wchar_t" "bitor" "class" "delete" "explicit" "unsigned" "while" ) #'(lambda (a b) (> (length a) (length b)))))

(defvar ac-source-c++
	'((candidates
		. (lambda ()
			(all-completions ac-target c++-keywords))))
	"Source for c++ keywords.")
(add-hook 'c++-mode-hook
	(lambda ()
		(make-local-variable 'ac-sources)
		(setq ac-sources '(ac-source-c++))))


;;; ====================================================
;;; Run Firefox
;;; ====================================================
;;;(call-process "firefox")


;;; ===========================================================
;;; Refactoring
;;; ===========================================================
(require 'srefactor)
(require 'srefactor-lisp)

(semantic-mode 1)

(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(global-set-key (kbd "M-RET o") 'srefactor-lisp-one-line)
(global-set-key (kbd "M-RET m") 'srefactor-lisp-format-sexp)
(global-set-key (kbd "M-RET d") 'srefactor-lisp-format-defun)
(global-set-key (kbd "M-RET b") 'srefactor-lisp-format-buffer)


;;; ===========================================================
;;; source <-> header
;;; ===========================================================
(global-set-key (kbd "C-x C-o") 'ff-find-other-file)

(defvar my-cpp-other-file-alist '(("\\.cpp\\'" (".h")) ("\\.h\\'" (".cpp"))))
(setq-default ff-other-file-alist 'my-cpp-other-file-alist)


;;; ===========================================================
;;; ido-mode
;;; ===========================================================
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)


;;; ===========================================================
;;; ggtags
;;; ===========================================================

(add-hook 'c-mode-common-hook
    (lambda ()
      (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
  (ggtags-mode 1))))


(add-hook 'dired-mode-hook 'ggtags-mode)
