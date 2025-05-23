;;; emacs-leuven.el --- Emacs configuration file with more pleasant defaults

;; Copyright (C) 1999-2025 Fabrice Niessen. All rights reserved.

;; Author: Fabrice Niessen <(concat "fniessen" at-sign "pirilampo.org")>
;; URL: https://github.com/fniessen/emacs-leuven
;; Version: <20250311.0951>
;; Keywords: emacs, dotfile, config

;;
;;    ___ _ __ ___   __ _  ___ ___
;;   / _ \ '_ ` _ \ / _` |/ __/ __|
;;  |  __/ | | | | | (_| | (__\__ \
;; (_)___|_| |_| |_|\__,_|\___|___/
;;

;; This file is NOT part of GNU Emacs.

;; This file is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Emacs-Leuven enhances GNU Emacs with pleasant defaults and many packages.
;; Features include improved navigation, editing, and package management.
;; Works on Windows, Linux, and macOS.
;;
;; Minimal setup:
;;
;;     (add-to-list 'load-path "/path/to/emacs-leuven/")
;;     (require 'emacs-leuven)
;;
;; Optional:
;;   (setq lvn-verbose-loading t)                  ; Show loading progress
;;   (setq package-selected-packages nil)          ; Skip package installs
;;
;; See https://github.com/fniessen/emacs-leuven for details.
;;
;; For help on the Emacs Editor, see (info "(emacs)")  <== `C-x C-e' here!

;;; Code:

;; This file is only provided as an example.  Customize it to your own taste!

;; Define the version as the current timestamp of the last change.
(defconst lvn--emacs-version "<20250311.0951>"
  "Emacs-Leuven version, represented as the date and time of the last change.")

;; Announce the start of the loading process.
(message "* --[ Loading Emacs-Leuven %s ]--" lvn--emacs-version)

;; Record the start time for measuring load duration.
(defconst emacs-leuven--load-start-time (current-time)
  "Timestamp before loading Emacs-Leuven, used to calculate startup duration.")

;; Suppress GC messages for a cleaner startup log.
(setq garbage-collection-messages nil)

;; Disable garbage collection during startup for performance.
(setq gc-cons-threshold most-positive-fixnum)

(defun lvn--restore-gc-settings-and-clean ()
  "Restore default GC settings and perform an initial garbage collection."
  (setq gc-cons-threshold 800000)       ; Restore default threshold (0.76 MB).
  (setq gc-cons-percentage 0.1)         ; Restore default percentage.
  (garbage-collect)                     ; Perform cleanup.
  (message "[GC optimization complete: Settings restored, memory cleaned]"))

;; Restore GC settings (and trigger GC) after full startup.
(add-hook 'emacs-startup-hook #'lvn--restore-gc-settings-and-clean t)

(defmacro measure-time (message &rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((start (current-time)))
     ,@body
     (message "[__%s (in %.02f s)___________________________]"
              ,message (float-time (time-since start)))))

;;; User Customizable Internal Variables

(defgroup leuven nil
  "Emacs-Leuven customizations."
  :group 'convenience)

(defcustom lvn-verbose-loading nil
  "If non-nil, display loading progress messages for Emacs-Leuven."
  :group 'leuven
  :type 'boolean)

(when lvn-verbose-loading
  (defun lvn--add-timestamp-to-message (old-fun &rest args)
    "Add timestamps to `message' output."
    (when (car args)
      (apply old-fun
             (cons (format "[%s.%03d] %s"
                          (format-time-string "%Y-%m-%d %T")
                          (string-to-number (substring (format-time-string "%N") 0 3))
                          (car args))
                   (cdr args)))))

  (advice-add 'message :around #'lvn--add-timestamp-to-message))

;; Allow quick include/exclude of setup parts -- DO NOT EDIT the DEFVAR!
(defvar leuven-load-chapter-0-environment t) ; required
(defvar leuven-load-chapter-0-loading-libraries t) ; required
(defvar leuven-load-chapter-0-debugging t)
(defvar leuven-load-chapter-48-packages t)
(defvar leuven-load-chapter-1-screen t)
(defvar leuven-load-chapter-6-exiting t)
(defvar leuven-load-chapter-7-basic t)
(defvar leuven-load-chapter-8-minibuffer t)
(defvar leuven-load-chapter-10-help t)
(defvar leuven-load-chapter-11-mark t)
(defvar leuven-load-chapter-12-killing t)
(defvar leuven-load-chapter-13-registers t)
(defvar leuven-load-chapter-14-display t)
(defvar leuven-load-chapter-15-search t)
(defvar leuven-load-chapter-16-fixit t)
(defvar leuven-load-chapter-17-keyboard-macros t)
(defvar leuven-load-chapter-18-files t)
(defvar leuven-load-chapter-19-buffers t)
(defvar leuven-load-chapter-20-windows t)
(defvar leuven-load-chapter-21-frames t)
(defvar leuven-load-chapter-22-international t)
(defvar leuven-load-chapter-23-major-and-minor-modes t)
(defvar leuven-load-chapter-24-indentation t)
(defvar leuven-load-chapter-25-text t)
(defvar leuven-load-chapter-25.11-tex-mode t)
(defvar leuven-load-chapter-26-programs t)
(defvar leuven-load-chapter-27-building t)
(defvar leuven-load-chapter-28-maintaining t)
(defvar leuven-load-chapter-29-abbrevs t)
(defvar leuven-load-chapter-30-dired t)
(defvar leuven-load-chapter-31-calendar-diary t)
(defvar leuven-load-chapter-32-sending-mail t)
(defvar leuven-load-chapter-34-gnus t)
(defvar leuven-load-chapter-36-document-view t)
(defvar leuven-load-chapter-38-shell t)
(defvar leuven-load-chapter-39-emacs-server t)
(defvar leuven-load-chapter-40-printing t)
(defvar leuven-load-chapter-41-sorting t)
(defvar leuven-load-chapter-44-saving-emacs-sessions t)
(defvar leuven-load-chapter-46-hyperlinking t)
(defvar leuven-load-chapter-47-amusements t)
(defvar leuven-load-chapter-49-customization t)
(defvar leuven-load-chapter-AppG-ms-dos t)
(defvar leuven-load-chapter-XX-emacs-display t)
(defvar leuven-load-chapter-99-debugging t)

(defvar leuven--load-times-list nil
  "List of chapters and time to load them.")

(defmacro leuven--chapter (chapterid chaptername &rest body)
  "Evaluate BODY as CHAPTERNAME when CHAPTERID is non-nil.
Records execution time in `leuven--load-times-list'."
  `(when ,chapterid
     (let ((before-time (float-time))
           (section-start-time (float-time))
           chapter-duration)
       ;; Display chapter start message if verbose mode is enabled.
       (when lvn-verbose-loading
         (message "[** %s]" ,chaptername))

       ;; Initialize section timing.
       (setq leuven--before-section-time section-start-time)

       ;; Execute the chapter body.
       ,@body

       ;; Mark chapter end with a fake section.
       (leuven--section (concat "[" ,chaptername " ends here]") 'end-of-chapter)

       ;; Calculate and store duration.
       (setq chapter-duration (format "%.2f" (- (float-time) before-time)))
       (add-to-list 'leuven--load-times-list
                    (concat "| " ,chaptername " "
                            "| " chapter-duration " |")))))

(defvar leuven--before-section-time (float-time)
  "Value of `float-time' before loading some section.")

(defun leuven--section (sectionname &optional end-of-chapter)
  "Report under SECTIONNAME the time taken since it was last saved.
Last time is saved in global variable `leuven--before-section-time'."
  (let ((this-section-time (- (float-time)
                              leuven--before-section-time)))
    (when lvn-verbose-loading
      (when (not (equal this-section-time 0.00))
        (message "[    Section time: %.2f s]" this-section-time))
      (unless end-of-chapter (message "[*** %s]" sectionname)))
    ;; For next one.
    (setq leuven--before-section-time (float-time))))

;;* Loading Libraries of Lisp Code for Emacs

(leuven--chapter leuven-load-chapter-0-loading-libraries "0 Loading Libraries"

  ;; Load-path enhancement.
  (defun lvn--add-to-load-path (dir)
    "Add DIR to `load-path' if it exists and is searchable.
  Warn if DIR does not exist."
    (let ((abs-dir (expand-file-name dir)))
      (if (file-directory-p abs-dir)
          (unless (file-exists-p (expand-file-name ".nosearch" abs-dir))
            (add-to-list 'load-path abs-dir)
            (when lvn-verbose-loading
              (message "[Added '%s' to load-path]" abs-dir)))
        (warn "Directory '%s' does not exist" abs-dir))))

  ;; Remember this directory.
  (defconst lvn--directory
    (file-name-directory (or load-file-name (buffer-file-name)))
    "Directory path of Emacs-Leuven installation.")

  (lvn--add-to-load-path lvn--directory)
  (lvn--add-to-load-path (concat lvn--directory "../site-lisp"))

  ;; (lvn--add-to-load-path "~/lisp")
  ;; (lvn--add-to-load-path "~/site-lisp")

  (defcustom leuven-user-lisp-directory (concat user-emacs-directory "lisp/")
    "Directory containing personal additional Emacs Lisp packages."
    :group 'leuven
    :type 'directory)

  ;; (lvn--add-to-load-path leuven-user-lisp-directory)

  ;; Require a feature/library if available; if not, fail silently.
  (unless (fboundp 'try-require)
    (defun try-require (feature)
      "Attempt to load FEATURE, returning t on success or nil on failure.
  FEATURE should be a symbol representing an Emacs library or feature.
  On failure, issue a warning with the error details."
      (condition-case err
          (progn
            (require feature)
            t)                          ; Return t for success in conditionals.
        (error
         (warn "Failed to load feature `%s': %s" feature (error-message-string err))
         nil))))

  (unless (fboundp 'with-eval-after-load)
    (defmacro with-eval-after-load (feature &rest body)
      "Execute forms in BODY after the specified FEATURE is loaded.
This macro is a wrapper around `eval-after-load' (introduced in Emacs 24.4).
FEATURE is the feature symbol or library name to wait for before executing BODY.
BODY contains the forms to be executed after FEATURE is loaded.
The forms in BODY are enclosed within a `progn' to ensure proper evaluation.

Example usage:
  (with-eval-after-load 'magit
    (setq magit-auto-revert-mode nil))"
      `(eval-after-load ,feature
         '(progn ,@body))))

  (defun lvn--switch-or-start (fn buffer)
    "If BUFFER is the current buffer, bury it. If a buffer with the name BUFFER
exists, switch to it; otherwise, invoke FN."
    (if (equal (buffer-name (current-buffer)) buffer)
        (bury-buffer)
      (if (get-buffer buffer)
          (switch-to-buffer buffer)
        (funcall fn))))

)                                       ; Chapter 0-loading-libraries ends here.

;;* Environment

(leuven--chapter leuven-load-chapter-0-environment "0 Environment"

;;** Type of OS

  (leuven--section "Type of OS")

  (defconst lvn--linux-p (eq system-type 'gnu/linux)
    "Non-nil if running Emacs on native Linux or WSL.")

  (defconst lvn--wsl-p
    (let ((kernel-release (string-trim (shell-command-to-string "uname -r"))))
      (or (string-match "WSL" kernel-release)
          (string-match "microsoft-standard-WSL2" kernel-release)))
    ;; (and (eq system-type 'gnu/linux)
    ;;      (string-match-p "Microsoft" (shell-command-to-string "uname -r")))
    "Non-nil if running Emacs on WSL or WSL2.")

  (defconst lvn--mac-p (eq system-type 'darwin)
    "Non-nil if running Emacs on macOS.")

  (defconst lvn--win32-p (eq system-type 'windows-nt)
    "Non-nil if running Emacs natively on Microsoft Windows.")

  (defconst lvn--cygwin-p (eq system-type 'cygwin)
    "Non-nil if running Emacs on Cygwin.")

;;** MS Windows

  ;; Set the default Windows Program Files directory depending on the operating
  ;; system Emacs is running on.
  (defconst leuven--windows-program-files-dir
    (cond (lvn--win32-p
           (file-name-as-directory (getenv "ProgramFiles(x86)")))
          (lvn--cygwin-p
           "/cygdrive/c/Program Files (x86)/")
          (t
           "/usr/local/bin/"))
    "Default Windows Program Files folder.")

;;** Window system

  (leuven--section "Window system")

  (defconst leuven--console-p
    (not window-system)
    "Non-nil if running a text-only terminal.")

  (defconst leuven--x-window-p
    (eq window-system 'x)
    "Non-nil if running an X Window system.")

;;** Testing file accessibility

  (defun lvn--validate-file-executable-p (file)
    "Ensure FILE exists and is executable.
Returns FILE if it is both existent and executable, otherwise returns nil.
Shows a warning message if the file does not exist or is not executable."
    (when (not file)
      (error "Missing argument to `lvn--validate-file-executable-p'"))

    (cond
     ((not (file-exists-p file))
      (warn "File `%s' does not exist." file)
      (sit-for 1.5)
      nil)

     ((not (file-executable-p file))
      (warn "File `%s' is not executable." file)
      (sit-for 1.5)
      nil)

     ;; Return the file if it exists and is executable.
     (t file)))

;;** Init

  (leuven--section "Init")

  ;; ;; Ensure that the echo area is always visible during the early stage of
  ;; ;; startup (useful in case of error).
  ;; (modify-all-frames-parameters
  ;;  '((height . 32)))

)                                       ; Chapter 0 ends here.

;;* Debugging

(leuven--chapter leuven-load-chapter-0-debugging "0 Debugging"

  ;; Get the backtrace when uncaught errors occur.
  (setq debug-on-error t)               ; Will be unset at the end.

  ;; Hit `C-g' while it's frozen to get an Emacs Lisp backtrace.
  (setq debug-on-quit t)                ; Will be unset at the end.

)                                       ; Chapter 0 ends here.

;;* 48 Emacs Lisp (info "(emacs)Packages")

(leuven--chapter leuven-load-chapter-48-packages "48 Emacs Lisp Packages"

;;** 48.2 Package Installation

  (leuven--section "48.2 Package Installation")

  ;; Simple package system for GNU Emacs.
  (use-package package
    :ensure nil ;; Built-in, no need to install.
    :config
    ;; Archives from which to fetch.
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") :append))

  (try-require 'package)
  (with-eval-after-load 'package


    (defcustom leuven-default-packages
      '(ag
        ant
        anzu
        ;; auctex
        ;; auto-complete
        auto-highlight-symbol
        auto-package-update
        avy
        back-button
        bbdb
        boxquote
        ;; calfw
        circe
        color-identifiers-mode
        company
        company-quickhelp
        ;; csv-mode
        dashboard
        ;; delight                     ; Instead of diminish.
        diff-hl
        diminish
        docker-compose-mode
        dumb-jump
        ;; emacs-eclim
        emr
        expand-region
        fancy-narrow
        flycheck
        flycheck-color-mode-line
        fuzzy
        ;; git-commit-insert-issue
        git-messenger
        ;; git-timemachine
        google-translate
        goto-chg
        graphviz-dot-mode
        helm
        helm-ag
        helm-descbinds
        helm-ls-git
        helm-org
        helm-projectile ; Obsolete package?
        helm-swoop
        hide-lines
        highlight-numbers
        hl-anything                 ; Better than `highlight-symbol'.
        hl-todo
        htmlize
        indent-guide
        ;; jabber
        jquery-doc
        js2-mode
        ;; js2-refactor
        json-mode
        key-chord
        litable
        idle-require
        interaction-log
        leuven-theme
        magit
        markdown-mode
        ;; multi-term
        multiple-cursors
        pager
        ;; paredit
        ;; pdf-tools
        powerline
        rainbow-delimiters
        ;; rainbow-mode
        ;; redshank
        skewer-mode
        smart-comment
        smartparens
        ;; sql-indent
        sqlup-mode
        symbol-overlay
        tern
        toc-org
        ;; undo-tree
        use-package
        volatile-highlights
        web-mode
        wgrep
        which-key
        ws-butler
        yasnippet
        ztree)
      "Default packages to install with Emacs-Leuven."
      :group 'leuven
      :type '(repeat symbol))
    (setq package-selected-packages leuven-default-packages)

    ;; (when (fboundp 'package-install-selected-packages) ; Emacs-v25
    ;;   (package-install-selected-packages))

    (defcustom leuven-excluded-packages nil
      "List of packages to exclude from installation."
      :group 'leuven
      :type '(repeat string))

    ;; Define a function to check if there are any missing ELPA packages.
    (defun lvn--missing-elpa-packages ()
      "Return a list of missing ELPA packages for Emacs-Leuven.
    Packages are considered missing if they are in `package-selected-packages'
    but not installed, not available as a library, and not in `leuven-excluded-packages'."
      (let (missing-packages)
        (dolist (pkg package-selected-packages)
          (unless (or (package-installed-p pkg)
                      (locate-library (symbol-name pkg))
                      (member pkg leuven-excluded-packages))
            (push pkg missing-packages)))))

    (defun lvn--internet-available-p (&optional url timeout)
      "Check internet connectivity by attempting to reach a specified URL.
    URL defaults to 'http://www.google.com/' if not provided.
    TIMEOUT specifies the maximum wait time in seconds (defaults to 5).
    Returns t if successful, nil if an error occurs or the request times out."
      (let ((url (or url "http://www.google.com/"))
            (timeout (or timeout 5)))
        (condition-case err
            (with-timeout (timeout nil)
              (url-retrieve-synchronously url t t)
              t)
          (error
           (message "[Internet check failed: %s]" (error-message-string err))
           nil))))

    (defun lvn--install-package (package)
      "Install PACKAGE silently and handle any errors.
    Displays success or failure message accordingly."
      (condition-case err
          (progn
            (package-install package)
            (message "[Installed package `%s']" package))
        (error
         (message "[Failed to install package `%s': %s]"
                  package
                  (error-message-string err)))))

    (defun lvn--install-missing-elpa-packages ()
      "Install missing ELPA packages with error handling."
      (condition-case err
          (let ((missing-packages (lvn--missing-elpa-packages)))
            (when missing-packages
              (if (lvn--internet-available-p)
                  (progn
                    (package-refresh-contents)
                    (dolist (pkg missing-packages)
                      (lvn--install-package pkg)))
                  (error "No internet connection"))))
        (error (message "[Failed to install packages: %s]" err))))

    ;; Start the installation process.
    (add-hook 'after-init-hook #'lvn--install-missing-elpa-packages)

    )

  ;; Configuration for automatic Emacs package updates.
  (with-eval-after-load 'auto-package-update-autoloads
    ;; Delete old versions when updating.
    (setq auto-package-update-delete-old-versions t)

    ;; Define a function for the update message.
    (defun lvn--display-update-message ()
      "Display a message before updating packages."
      (message "[Updating (M)ELPA packages now...]"))

    ;; Add the message function to the update hook.
    (add-hook 'auto-package-update-before-hook #'lvn--display-update-message)

    ;; Uncomment the following line to enable automatic updates.
    ;; (auto-package-update-maybe)
    ;; ("It looks like there's a problem with your network connection.")
  )

)                                       ; Chapter 48 ends here.

  ;; Load elisp libraries while Emacs is idle.
  (try-require 'idle-require)

  ;; Fail-safe for `idle-require`.
  (if (not (featurep 'idle-require))
      (defun idle-require (feature &optional file noerror)
        (try-require feature)))

  (with-eval-after-load 'idle-require

    ;; Idle time in seconds after which autoload functions will be loaded.
    (setq idle-require-idle-delay 2.0)

    ;; Time in seconds between automatically loaded functions.
    (setq idle-require-load-break 0.5)

    ;; Start loading after full startup.
    (add-hook 'emacs-startup-hook #'idle-require-mode))

  (setq use-package-idle-delay 2.0)

;;* 1 The Organization of the (info "(emacs)Screen")

(leuven--chapter leuven-load-chapter-1-screen "1 The Organization of the Screen"

;;** 1.2 The (info "(emacs)Echo Area")

  (leuven--section "1.2 (emacs) The Echo Area")

  ;; Don't truncate the message log buffer when it becomes large.
  (setq message-log-max t)

)                                       ; Chapter 1 ends here.

;;* 6 (info "(emacs)Exiting") Emacs

(leuven--chapter leuven-load-chapter-6-exiting "6 Exiting Emacs"

  ;; Unbind "minimize".
  (global-unset-key (kbd "C-z"))

  ;; Quit with Alt + F4.
  (global-set-key (kbd "<M-f4>") #'save-buffers-kill-terminal)

)                                       ; Chapter 6 ends here.

;;* 7 (info "(emacs)Basic") Editing Commands

(leuven--chapter leuven-load-chapter-7-basic "7 Basic Editing Commands"

;;** 7.1 (info "(emacs)Inserting Text")

  (leuven--section "7.1 (emacs)Inserting Text")

  ;; Enter characters by their code in octal (for `C-q NNN RET').
  (setq read-quoted-char-radix 8)       ; 16 for hexadecimal (for Unicode char)

;;** 7.2 (info "(emacs)Moving Point") Location

  (leuven--section "7.2 (emacs)Moving Point Location")

  ;; Don't add newlines to end of buffer when scrolling.
  (setq next-line-add-newlines nil)

  ;; Print the current buffer line number.
  (global-set-key (kbd "M-G") #'what-line)

  (defun lvn-goto-line-with-line-numbers-feedback ()
    "Go to a specific line while temporarily enabling line numbers.

This function prompts the user to enter a line number to navigate to. It temporarily
enables line numbers, moves the point to the specified line, and then restores the
original state of line numbers after navigation."
    (interactive)
    (let ((line-numbers-enabled (display-line-numbers-mode)))
      (unwind-protect
          (progn
            (display-line-numbers-mode 1)
            (goto-char (point-min))
            (forward-line (1- (read-number "Goto line: "))))
        (display-line-numbers-mode line-numbers-enabled))))

  (global-set-key [remap goto-line] #'lvn-goto-line-with-line-numbers-feedback)

;;** 7.4 (info "(emacs)Basic Undo")ing Changes

  (leuven--section "7.4 (emacs)Basic Undoing Changes")

  ;; Bind F11 to the undo command.
  (global-set-key (kbd "<f11>") #'undo)

  ;; Configuration for undo-tree.
  (with-eval-after-load 'undo-tree-autoloads
    ;; Enable Global-Undo-Tree mode.
    (global-undo-tree-mode 1))

  (with-eval-after-load 'undo-tree
    ;; Diminish undo-tree-mode from modeline.
    (with-eval-after-load 'diminish-autoloads
      (diminish 'undo-tree-mode))

    ;; Visualizer settings - Display relative timestamps.
    (setq undo-tree-visualizer-relative-timestamps t)

    ;; Visualizer settings - Show timestamps by default.
    (setq undo-tree-visualizer-timestamps t)
                                        ; Toggle time-stamps display using `t'.

    ;; Visualizer settings - Show diff by default.
    (setq undo-tree-visualizer-diff t)  ; Toggle the diff display using `d'.

    ;; Keybindings for redo.
    (global-set-key (kbd "C-S-z")   #'undo-tree-redo)
    (global-set-key (kbd "<S-f11>") #'undo-tree-redo))

  (with-eval-after-load 'volatile-highlights-autoloads
    (idle-require 'volatile-highlights))

  (with-eval-after-load 'volatile-highlights
    (volatile-highlights-mode 1))

)                                       ; Chapter 7 ends here.

;;* 8 The (info "(emacs)Minibuffer")

(leuven--chapter leuven-load-chapter-8-minibuffer "8 The Minibuffer"

  ;; How long to display an echo-area message when the minibuffer is active.
  (setq minibuffer-message-timeout 0.5)

;;** 8.3 (info "(emacs)Minibuffer Edit")ing

  (leuven--section "8.3 (emacs)Minibuffer Editing")

  ;; Minibuffer and echo area windows resize vertically as necessary to fit
  ;; the text displayed in them.
  (setq resize-mini-windows t)

;;** 8.4 (info "(emacs)Completion")

  (leuven--section "8.4 (emacs)Completion")

  ;; Ignore case differences when completing file names.
  (setq read-file-name-completion-ignore-case t)

  ;; Don't consider case significant in completion.
  (setq completion-ignore-case t)

  ;; Ignore case when reading a file name.
  (setq read-file-name-completion-ignore-case t) ; [Default: t on Windows]

  ;; Ignore case when reading a buffer name.
  (setq read-buffer-completion-ignore-case t) ; [Default: nil].

  ;; Provide the same facility of `ls --color' inside Emacs.
  (when (locate-library "dircolors")
    (autoload 'dircolors "dircolors" nil t)
    (add-hook 'completion-list-mode-hook #'dircolors))

  ;; Delete duplicates in history.
  (setq history-delete-duplicates t)

)                                       ; Chapter 8 ends here.

;;* 10 (info "(emacs)Help")

(leuven--chapter leuven-load-chapter-10-help "10 Help"

;;** 10.1 (info "(emacs)Help Summary")

  (leuven--section "10.1 (emacs)Help Summary")

  ;; Avoid the description of all minor modes.
  (defun leuven-describe-major-mode ()
    "Describe only `major-mode'."
    (interactive)
    (describe-function major-mode))

  ;; Look up subject in (the indices of the) Emacs Lisp manual.
  (global-set-key (kbd "C-h E") #'elisp-index-search)

;;** 10.4 (info "(emacs)Apropos")

  (leuven--section "10.4 (emacs)Apropos")

  (with-eval-after-load 'apropos

    ;; Apropos commands will search more extensively, checking all variables and
    ;; non-interactive functions as well.
    (setq apropos-do-all t))

  ;; (defun apropos-user-option (string)
  ;;   "Like apropos, but lists only symbols that are names of user
  ;; modifiable variables.  Argument REGEXP is a regular expression.
  ;;    Returns a list of symbols, and documentation found"
  ;;   (interactive "sVariable apropos (regexp): ")
  ;;   (let ((message
  ;;          (let ((standard-output (get-buffer-create "*Help*")))
  ;;            (print-help-return-message 'identity))))
  ;;     (if (apropos string  'user-variable-p)
  ;;         (and message (message message)))))

  ;; Show all variables whose name matches the pattern.
  (define-key help-map (kbd "A") #'apropos-user-option)

;;** 10.8 (info "(emacs)Misc Help")

  (leuven--section "10.8 (emacs)Misc Help")

  ;; Enter Info documentation browser.
  (global-set-key (kbd "<f1>") #'info)

  (defun leuven-describe-elisp-symbol-at-point ()
    "Get help for the symbol at point."
    (interactive)
    (let ((sym (intern-soft (current-word))))
      (unless
          (cond ((null sym))
                ((not (eq t (help-function-arglist sym)))
                 (describe-function sym))
                ((boundp sym)
                 (describe-variable sym)))
        (message "[nothing]"))))

  (global-set-key (kbd "<f1>") #'leuven-describe-elisp-symbol-at-point)

  ;; Display symbol definitions, as found in the relevant manual
  ;; (for AWK, C, Emacs Lisp, LaTeX, M4, Makefile, Sh and other languages that
  ;; have documentation in Info).
  ;; (global-set-key (kbd "<C-f1>") #'info-lookup-symbol)

  (with-eval-after-load 'info
    ;; List of directories to search for Info documentation files (in the order
    ;; they are listed).
    (when lvn--win32-p
      ;; (info-initialize)
      (let ((org-info-dir (expand-file-name
                           (concat (file-name-directory (locate-library "org")) "../doc/"))))
        (when (file-directory-p org-info-dir)
          (add-to-list 'Info-directory-list org-info-dir :append)))
      (let ((cygwin-info-dir "c:/cygwin/usr/share/info/"))
        (when (file-directory-p cygwin-info-dir)
          (add-to-list 'Info-directory-list cygwin-info-dir :append))))

  (with-eval-after-load 'info+-autoloads-XXX
    (idle-require 'info+)
    (with-eval-after-load 'info+
      ;; Show breadcrumbs in the header line.
      (setq Info-breadcrumbs-in-header-flag t)

      ;; Don't show breadcrumbs in the mode line.
      (setq Info-breadcrumbs-in-mode-line-mode nil)))

    )

  ;; Get a Unix manual page of the item under point.
  ;; (global-set-key (kbd "<S-f1>") #'man-follow)

  (with-eval-after-load 'man
    ;; Make the manpage the current buffer in the current window.
    (setq Man-notify-method 'pushy))

  ;; Alias man to woman globally.
  (defalias 'man 'woman)

  ;; Decode and browse Unix man-pages "W.o. (without) Man".
  (with-eval-after-load 'woman
    ;; WoMan adds a Contents menu to the menubar.
    (setq woman-imenu t))

  ;; Load which-key dynamically when idle.
  (use-package which-key
    :ensure t
    :defer t
    ;; Enable which-key mode globally.
    :hook (after-init . which-key-mode)
    :custom
    ;; Set the delay (in seconds) before the which-key popup appears.
    (which-key-idle-delay 0.4)
    ;; Sort keybindings by local bindings first, then by key order.
    (which-key-sort-order 'which-key-local-then-key-order)
    ;; Limit the maximum length of key descriptions to 33 characters.
    (which-key-max-description-length 33)
    :config
    ;; Use a side window, preferring the right side when space is available,
    ;; falling back to the bottom otherwise.
    (which-key-setup-side-window-right-bottom))

)                                       ; Chapter 10 ends here.

;;* 11 The (info "(emacs)Mark") and the Region

(leuven--chapter leuven-load-chapter-11-mark "11 The Mark and the Region"

  ;; Go to Last (buffer-local) Edit Location.
  (with-eval-after-load 'goto-chg-autoloads
    (global-set-key (kbd "<C-S-backspace>") #'goto-last-change))

  (with-eval-after-load 'back-button-autoloads-XXX
    (idle-require 'back-button)

    (with-eval-after-load 'back-button
      (back-button-mode 1)

      ;; Navigate backward.
      (global-set-key (kbd "<C-M-left>")  #'back-button-global-backward) ; IntelliJ IDEA.

      ;; Navigate forward.
      (global-set-key (kbd "<C-M-right>") #'back-button-global-forward))) ; IntelliJ IDEA.

  ;; Increase selected region by semantic units.
  (with-eval-after-load 'expand-region-autoloads

    ;; ;; Key to use after an initial expand/contract to undo.
    ;; (setq expand-region-reset-fast-key "<escape> <escape>")

    (global-set-key (kbd "C-M-w") #'er/expand-region)    ; See key-chord `hh'.
    (global-set-key (kbd "C-S-w") #'er/contract-region)) ; See key-chord `HH'.

  ;; Inserting text while the mark is active causes the text in the region to be
  ;; deleted first.
  (delete-selection-mode 1)             ; Overwrite region.

  ;; Multiple cursors for Emacs.
  (with-eval-after-load 'multiple-cursors-autoloads

    ;; Add a cursor to each (continuous) line in the current region.
    (global-set-key (kbd "C-S-c C-S-c") #'mc/edit-lines) ;!

    ;; Add a cursor and region at the next/previous part of the buffer that
    ;; matches the current region.
    (global-set-key (kbd "C->") #'mc/mark-next-like-this) ;!
    (global-set-key (kbd "C-<") #'mc/mark-previous-like-this) ;!

    ;; Add Selection for Next Occurrence.
    (global-set-key (kbd "M-j") #'mc/mark-next-like-this) ; IntelliJ.

    ;; Unselect Occurrence. XXX
    ;; (global-set-key (kbd "M-J") #'mc/unmark-next-like-this) ; IntelliJ.

    ;; Skip the current one and select the next/previous part of the buffer that
    ;; matches the current region.
    (global-set-key (kbd "C-M->") #'mc/skip-to-next-like-this)
    (global-set-key (kbd "C-M-<") #'mc/skip-to-previous-like-this)

    ;; Add or remove caret.
    (global-set-key (kbd "<C-S-mouse-1>") #'mc/add-cursor-on-click)
    (global-set-key (kbd "<M-mouse-1>")   #'mc/add-cursor-on-click) ; XXX DOES NOT WORK.

    ;; Select All Occurrences.
    (global-set-key (kbd "C-M-S-j") #'mc/mark-all-like-this-dwim) ;! IntelliJ.

    ;; Tries to guess what you want to mark all of.
    (global-set-key (kbd "C-;")     #'mc/mark-all-like-this-dwim) ;! Like Iedit.
    ;; (global-set-key (kbd "C-c C-w") #'mc/mark-all-like-this-dwim)
    ;; (global-set-key (kbd "C-x C-;") #'mc/mark-all-like-this-dwim)

    ;; Mark all parts of the buffer that matches the current region.
    (global-set-key (kbd "C-c C-<") #'mc/mark-all-like-this) ;!

    (global-set-key (kbd "C-!") #'mc/mark-next-symbol-like-this)

    ;; (global-set-key (kbd "<C-RET>") #'mc/mark-more-like-this-extended) ; useful for completion

    ;; Insert increasing numbers for each cursor.
    (global-set-key (kbd "C-M-=") #'mc/insert-numbers)
  )

  ;; Multiple cursors for Emacs.
  (with-eval-after-load 'multiple-cursors-core

    ;; Commands to run for all cursors in multiple-cursors-mode.
    (setq mc/cmds-to-run-for-all        ; See .mc-lists.el.
          '(c-electric-slash
            cycle-spacing
            emr-show-refactor-menu
            isearch-abort
            isearch-printing-char
            js2-mode-show-node
            just-one-space
            kill-region
            lvn-toggle-paragraph-fill
            leuven-smart-punctuation-quotation-mark
            org-beginning-of-line
            org-end-of-line
            org-kill-line
            org-self-insert-command
            org-shiftdown
            org-shiftleft
            org-shiftright
            org-shiftup
            org-yank
            orgtbl-self-insert-command
            yas-expand))

    ;; Commands to run only once in multiple-cursors-mode.
    (setq mc/cmds-to-run-once
          '()))

)                                       ; Chapter 11 ends here.

;;* 12 (info "(emacs)Killing") and Moving Text

(leuven--chapter leuven-load-chapter-12-killing "12 Killing and Moving Text"

;;** 12.1 (info "(emacs)Deletion and Killing")

  (leuven--section "12.1 (emacs)Deletion and Killing")

  ;; Manipulate whitespace around point in a smart way.
  (global-set-key (kbd "M-SPC") #'cycle-spacing) ; vs `just-one-space'.

  ;; Function to perform slick cut for the kill-region command.
  (defun lvn-slick-cut-region (orig-fn beg end &rest args)
    "Cut the selected region or the current line if no region is active and
called interactively."
    (interactive (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list (line-beginning-position) (line-beginning-position 2))))
    (if (called-interactively-p 'any)
        (let ((region-active (and (mark t) (use-region-p))))
          (if region-active
              ;; Region is active and mark is set, use the region bounds.
              (apply orig-fn (region-beginning) (region-end) args)
            ;; No active region or mark not set, cut the current line.
            (progn
              (message "[Cut the current line]")
              (apply orig-fn (line-beginning-position) (line-beginning-position 2) args))))
      ;; If not called interactively, pass the original arguments unchanged.
      (apply orig-fn beg end args)))

  (advice-add 'kill-region :around #'lvn-slick-cut-region)

  ;; Function to perform slick copy for the kill-ring-save command.
  (defun lvn-slick-copy-region (orig-fn beg end &rest args)
    "Copy the selected region or the current line if no region is active and
called interactively."
    (interactive (if (use-region-p)
                     (list (region-beginning) (region-end))
                   (list (line-beginning-position) (line-beginning-position 2))))
    (if (called-interactively-p 'any)
        (let ((region-active (and (mark t) (use-region-p))))
          (if region-active
              ;; Region is active and mark is set, use the region bounds.
              (apply orig-fn (region-beginning) (region-end) args)
            ;; No active region or mark not set, copy the current line.
            (progn
              (message "[Copied the current line]")
              (apply orig-fn (line-beginning-position) (line-beginning-position 2) args))))
      ;; If not called interactively, pass the original arguments unchanged.
      (apply orig-fn beg end args)))

  (advice-add 'kill-ring-save :around #'lvn-slick-copy-region)

  (defun lvn-duplicate-line-or-region ()
    "Duplicate the current line or region."
    (interactive)
    (save-mark-and-excursion
      (if (use-region-p)
          (progn
            (kill-ring-save (region-beginning) (region-end))
            (goto-char (region-end))
            (yank))
        (progn
          (kill-ring-save (line-beginning-position) (line-end-position))
          (end-of-line)
          (newline)
          (yank)))))

  (global-set-key (kbd "C-S-d") #'lvn-duplicate-line-or-region)

;;** 12.2 (info "(emacs)Yanking")

  (leuven--section "12.2 (emacs)Yanking")

  ;; Auto-indentation of pasted code in the programming modes
  ;; (fall back to default, non-indented, yanking by preceding the yanking
  ;; command `C-y' with `C-u').
  (dolist (command '(yank yank-pop))
    (advice-add command :after
                (lambda (&rest _)
                  "Indent yanked text in programming mode (unless prefix arg)."
                  (when (and (not current-prefix-arg)
                             (derived-mode-p 'prog-mode))
                    (let ((mark-even-if-inactive t))
                      (indent-region (region-beginning) (region-end) nil))))))

  ;; Save clipboard strings into kill ring before replacing them.
  (setq save-interprogram-paste-before-kill t)

  ;; ;; Rotating the kill ring changes the window system selection.
  ;; (setq yank-pop-change-selection t)

;;** 12.3 (info "(emacs)Cut and Paste")

  (leuven--section "12.3 (emacs)Cut and Paste on Graphical Displays")

  ;; Make cut, copy and paste (keys and menu bar items) use the clipboard.
  (menu-bar-enable-clipboard)

  (setq interprogram-paste-function
        (if (equal interprogram-paste-function 'x-cut-buffer-or-selection-value)
            #'x-selection-value
          interprogram-paste-function))

  ;; ;; Define the copy command for WSL.
  ;; (defun lvn-wsl-slick-copy-region (beg end &optional region)
  ;;   "Copy the selected region or the current line to the Windows clipboard in WSL.
  ;; BEG and END specify the region to copy if a region is selected."
  ;;   (interactive
  ;;    (if (use-region-p)
  ;;        (list (region-beginning) (region-end))
  ;;      (list (line-beginning-position) (line-beginning-position 2))))
  ;;   (let ((region-text (buffer-substring-no-properties beg end)))
  ;;     (kill-new region-text)
  ;;     (shell-command-on-region beg end "clip.exe")
  ;;     (deactivate-mark)
  ;;     (message "[Copied to Windows clipboard and kill-ring]")))

  ;; ;; Override the kill-ring-save command when in WSL config.
  ;; (when lvn--wsl-p
  ;;   (advice-add 'kill-region :before #'lvn-wsl-slick-copy-region))


  ;; (when lvn--wsl-p
  ;;   (defun lvn-wsl-slick-copy-region (beg end &rest args)
  ;;     "Copy region to Windows clipboard in WSL."
  ;;     (interactive "r")
  ;;     (shell-command-on-region beg end "clip.exe")
  ;;     (message "[Copied to Windows clipboard]"))
  ;;   (advice-add 'kill-ring-save :before #'lvn-wsl-slick-copy-region))


  ;; ;; Define the paste command for WSL.
  ;; (defun lvn-wsl-paste-region ()
  ;;   "Paste the contents of the Windows clipboard in WSL."
  ;;   (interactive)
  ;;   (let ((clipboard
  ;;          (shell-command-to-string "powershell.exe -command 'Get-Clipboard' 2> /dev/null")))
  ;;     (setq clipboard (replace-regexp-in-string "\r" "" clipboard)) ; Remove Windows ^M characters.
  ;;     (setq clipboard (substring clipboard 0 -1)) ; Remove newline added by Powershell.
  ;;
  ;;     ;; Delete the selected region before inserting clipboard content.
  ;;     (when (region-active-p)
  ;;       (delete-region (region-beginning) (region-end)))
  ;;
  ;;     (insert clipboard))
  ;;   (message "[Pasted from Windows clipboard]"))

  ;; ;; Override the yank command when in WSL config.
  ;; (when lvn--wsl-p
  ;;   (global-set-key (kbd "C-y") 'lvn-wsl-paste-region))

)                                       ; Chapter 12 ends here.

;;* 13 (info "(emacs)Registers")

(leuven--chapter leuven-load-chapter-13-registers "13 Registers"

;;** 13.1 (info "(emacs)Position Registers")

  (leuven--section "13.1 (emacs)Position Registers")

;;** 13.7 (info "(emacs)Bookmarks")

  (leuven--section "13.7 (emacs)Bookmarks")

  (with-eval-after-load 'bookmark

    ;; Where to save the bookmarks.
    (setq bookmark-default-file (concat user-emacs-directory "bookmarks.bmk"))
                                        ;! A `.txt' extension would load Org at
                                        ;! the time `bookmark' is required!

    ;; Each command that sets a bookmark will also save your bookmarks.
    (setq bookmark-save-flag 1)

    )

    (with-eval-after-load 'helm-autoloads
      ;; Helm for bookmarks (filtered by category).
      (global-set-key (kbd "C-x r l") #'helm-filtered-bookmarks))

  (with-eval-after-load 'avy-autoloads

    ;; ;; Quickly jump to a position in the current view. XXX Conflict with Org mode (in tables).
    ;; (global-set-key (kbd "C-c SPC") #'avy-goto-word-or-subword-1)

    ;; Jump back to previous position.
    (global-set-key (kbd "C-c C-SPC") #'avy-pop-mark)

    ;; Jump during Isearch to one of the current candidates.
    (define-key isearch-mode-map (kbd "C-'") #'avy-isearch)
    ;; (define-key isearch-mode-map (kbd "@")   #'avy-isearch)
  )

  ;; Jump to things.
  (with-eval-after-load 'avy

    ;; Default keys for jumping.
    (setq avy-keys (number-sequence ?a ?z))

    ;; Determine the list of windows to consider in search of candidates.
    (setq avy-all-windows 'all-frames)

    ;; Highlight the first decision char with `avy-lead-face-0'.
    (setq avy-highlight-first t))

)                                       ; Chapter 13 ends here.

;;* 14 Controlling the (info "(emacs)Display")

(leuven--chapter leuven-load-chapter-14-display "14 Controlling the Display"

;;** 14.1 (info "(emacs)Scrolling")

  (leuven--section "14.1 (emacs)Scrolling")

  ;; When scrolling, point preserves the cursor position in the buffer if the
  ;; original position is still visible.
  (setq scroll-preserve-screen-position t)

  ;; Better scrolling in Emacs (doing a <PageDown> followed by a <PageUp> will
  ;; place the point at the same place).
  (with-eval-after-load 'pager-autoloads

    (autoload 'pager-page-up "pager"
      "Like scroll-down, but moves a fixed amount of lines." t)
                                        ; These autoloads aren't defined in
                                        ; `pager-autoloads'!
    (autoload 'pager-page-down "pager"
      "Like scroll-up, but moves a fixed amount of lines." t)

    (global-set-key (kbd "<prior>") #'pager-page-up)
    (global-set-key (kbd "<next>")  #'pager-page-down))

;;** 14.3 (info "(emacs)Auto Scrolling")

  (leuven--section "14.3 (emacs)Auto Scrolling")

  ;; Scroll only one line at a time (redisplay will never recenter point).
  (setq scroll-conservatively 10000)    ; Or `most-positive-fixnum'.

  ;; Number of lines of margin at the top and bottom of a window.
  (setq scroll-margin 4)                ; Also for `isearch-forward'.

  ;; Scrolling down looks much better.
  (setq auto-window-vscroll nil)

;;** 14.5 (info "(emacs)Narrowing")

  (leuven--section "14.5 (emacs)Narrowing")

  ;; Enable the use of the command `narrow-to-region' without confirmation.
  (put 'narrow-to-region 'disabled nil)

  ;; (with-eval-after-load 'fancy-narrow-autoloads
  ;;   (fancy-narrow-mode)) ; perf problems when calling `helm-for-files' from a big file?

;;** 14.12 (info "(emacs)Font Lock")

  (leuven--section "14.12 (emacs)Font Lock")

;; Load hl-todo only if it's available.
(when (try-require 'hl-todo)

  ;; Enable hl-todo globally.
  (global-hl-todo-mode 1)

  ;; Customize the keywords to highlight.
  ;; Customize the keywords to highlight.
  (setq hl-todo-keyword-faces
        '(;; Priority and issues first.
          ("URGENT"     . "#FF3B30")    ; Vivid red - High priority, urgent tasks.
          ("BUG"        . "#D50000")    ; Strong red - Known bugs.
          ("FIXME"      . "#FF4500")    ; Orange red - Issues to fix.
          ("XXX"        . "#8B0000")    ; Dark red - Critical issues.

          ;; Active development.
          ("TODO"       . (:weight bold :box (:line-width 1 :color "#D8ABA7") :foreground "#D8ABA7" :background "#FFE6E4"))
                                        ; Light red with a box - Tasks to do (matches org-todo).
          ("WIP"        . "#FFA500")    ; Orange - Work in progress.
          ("HACK"       . "#FFD700")    ; Gold - Temporary solutions.
          ("REFACTOR"   . "#1E90FF")    ; Dodger blue - Code cleanup,
                                        ; improvement tasks.

          ;; Verification and collaboration.
          ("TEST"       . "#0066CC")    ; Medium blue - For test cases.
          ("REVIEW"     . "#1E90FF")    ; Dodger blue - For review.
          ("QUESTION"   . "#008B8B")    ; Dark cyan - Clarifications needed.

          ;; Documentation and closure.
          ("NOTE"       . "#1E90FF")    ; Dodger blue - Informational notes.
          ("DEPRECATED" . "#B22222")    ; Fire brick - Deprecated code.

          ;; Completion status.
          ("DONE"       . (:weight bold :box "#89C58F" :foreground "#89C58F" :background "#E2FEDE"))
                                        ; Soft green with a box - Completed tasks (matches org-done).
  ))

  ;; Highlight TODOs followed by colon.
  (setq hl-todo-highlight-punctuation ":")
  ;; (setq hl-todo-highlight-punctuation ".,;:!?")
                                        ; Optional: Highlight with these.

  ;; Show all TODOs in an occur buffer.
  (global-set-key (kbd "C-c t") 'hl-todo-occur)
  ;; See also `org-agenda-custom-command' '1'.
)

  ;; Just-in-time (JIT) fontification.
  (use-package jit-lock
    ;; 'jit-lock' is built into Emacs, so no installation is needed.
    :ensure nil

    ;; Load lazily, since JIT fontification isn't needed immediately.
    :defer t

    ;; Configuration to apply after the package is loaded.
    :config
    ;; Enable status messages during stealth fontification for better feedback.
    (setq jit-lock-stealth-verbose t)

    ;; ;; Define idle time (in seconds) before deferred fontification occurs.
    ;; (setq jit-lock-defer-time 0.01)     ; Improve scrolling speed in large files.
  )

;;** 14.13 (info "(emacs)Highlight Interactively") by Matching

  (leuven--section "14.13 (emacs)Highlight Interactively by Matching")

  ;; Highlight-Changes mode.
  (with-eval-after-load 'hilit-chg
    (defvar lvn-highlight-fringe-mark 'filled-rectangle
      "The fringe bitmap name used for marking changed lines.
Should be selected from `fringe-bitmaps'.")

    (defun lvn-hilit-chg-add-fringe-marker ()
      "Add a fringe marker to overlays with the 'hilit-chg property."
      (dolist (ov (overlays-at (ad-get-arg 1)))
        (when (overlay-get ov 'hilit-chg)
          (let ((fringe-anchor (make-string 1 ?x)))
            (put-text-property 0 1 'display
                               (list 'left-fringe lvn-highlight-fringe-mark)
                               fringe-anchor)
            (overlay-put ov 'before-string fringe-anchor)))))

    (advice-add 'hilit-chg-make-ov :after #'lvn-hilit-chg-add-fringe-marker))

  ;; ;; Enable Global-Highlight-Changes mode.
  ;; (global-highlight-changes-mode 1)

  ;; ;; Changes are initially NOT visible in Highlight Changes mode.
  ;; (setq highlight-changes-visibility-initial-state nil)

  ;; Do not prompt for the face to use. Instead, cycle through them.
  (setq hi-lock-auto-select-face t)

  ;; ;; Enable Hi Lock mode for all buffers.
  ;; (global-hi-lock-mode 1)

  ;; Automatic highlighting occurrences of the current symbol under cursor.
  (with-eval-after-load 'auto-highlight-symbol-autoloads
    (idle-require 'auto-highlight-symbol)

    (with-eval-after-load 'auto-highlight-symbol
      ;; Define a list of modes to enable Auto-Highlight-Symbol mode.
      (setq lvn--extra-ahs-modes '(js2-mode
                                   ess-mode)) ; R.

      ;; Add the modes to ahs-modes list.
      (dolist (mode lvn--extra-ahs-modes)
        (add-to-list 'ahs-modes mode :append))

      ;; Number of seconds to wait before highlighting the current symbol.
      (setq ahs-idle-interval 0.2) ; 0.35.

      ;; Unset AHS key bindings that override Org key bindings.
      (dolist (key '("<M-left>"
                     "<M-right>"
                     "<M-S-left>"
                     "<M-S-right>"))
        (define-key auto-highlight-symbol-mode-map (kbd key) nil))

      ;; ;; Toggle Auto-Highlight-Symbol mode in all buffers.
      ;; (global-auto-highlight-symbol-mode t)

      ;; Enable Auto-Highlight-Symbol mode in programming mode and LaTeX mode
      ;; buffers.
      (dolist (hook '(prog-mode-hook
                      latex-mode-hook))
        (add-hook hook 'auto-highlight-symbol-mode))))

;; XXX Impact on Org's HTML export?
  ;; (with-eval-after-load 'color-identifiers-mode-autoloads
  ;;   ;; Enable global-color-identifiers-mode after Emacs has fully initialized.
  ;;   (add-hook 'emacs-startup-hook #'global-color-identifiers-mode))

  (with-eval-after-load 'diff-hl-autoloads
    (idle-require 'diff-hl))

  ;; Indicate changes in the fringe.
  (with-eval-after-load 'diff-hl

    (global-diff-hl-mode 1)

    ;; Move to Next Change (also on `C-x v ]').
    (define-key diff-hl-mode-map (kbd "C-x v >")      #'diff-hl-next-hunk)
    (define-key diff-hl-mode-map (kbd "M-g <down>")   #'diff-hl-next-hunk)
    (define-key diff-hl-mode-map (kbd "<C-M-S-down>") #'diff-hl-next-hunk) ;; IntelliJ IDEA.

    ;; Move to Previous Change (also on `C-x v [').
    (define-key diff-hl-mode-map (kbd "C-x v <")      #'diff-hl-previous-hunk)
    (define-key diff-hl-mode-map (kbd "M-g <up>")     #'diff-hl-previous-hunk)
    (define-key diff-hl-mode-map (kbd "<C-M-S-up>")   #'diff-hl-previous-hunk) ;; IntelliJ IDEA.

    ;; Popup current diff.
    (define-key diff-hl-mode-map (kbd "C-x v =") #'diff-hl-diff-goto-hunk)

    ;; Revert current hunk (also on `C-x v n').
    (define-key diff-hl-mode-map (kbd "C-x v u") #'diff-hl-revert-hunk))

;;** 14.15 (info "(emacs)Displaying Boundaries")

  (leuven--section "14.15 (emacs)Displaying Boundaries")

  ;; Set vertical indicator at column 80.
  (setq-default display-fill-column-indicator-column 80)

  ;; Enable column indicator display for all modes.
  (global-display-fill-column-indicator-mode 1)

  ;; Visually indicate buffer boundaries and scrolling in the fringe.
  (setq-default indicate-buffer-boundaries '((top . left) (t . right)))

;;** 14.16 (info "(emacs)Useless Whitespace")

  (leuven--section "14.16 (emacs)Useless Whitespace")

  ;; ;; Highlight trailing whitespaces in all modes.
  ;; (setq-default show-trailing-whitespace t)

  ;; Unobtrusively remove trailing whitespace using ws-butler.
  (with-eval-after-load 'ws-butler-autoloads
    (dolist (hook '(text-mode-hook
                    prog-mode-hook))
      (add-hook hook #'ws-butler-mode)))

  (with-eval-after-load 'ws-butler
    (diminish 'ws-butler-mode))

  ;; Visually indicate empty lines after the buffer end in the fringe.
  (setq-default indicate-empty-lines t)

  ;; Enable Whitespace mode in text and programming modes (not in *vc-dir*,
  ;; etc.).
  (dolist (hook '(text-mode-hook
                  prog-mode-hook))
    (add-hook hook #'whitespace-mode))

  (with-eval-after-load 'whitespace
    ;; Customize Whitespace mode settings.

    ;; Define whitespace styles (Which kind of blank is visualized).
    (setq whitespace-style
          '(face
            trailing
            tabs
            ;; lines-tail
            indentation::space
            space-mark
            tab-mark))

    ;; Column beyond which the line is highlighted.
    (setq whitespace-line-column 80)

    ;; Mappings for displaying characters.
    (setq whitespace-display-mappings
          '((space-mark ?\u00A0         ; No-break space.
                        [?_]            ; Spacing underscore.
                        [?_])           ; Spacing underscore.

            (space-mark ?\u202F         ; Narrow no-break space.
                        [?\u00B7]       ; Middle dot.
                        [?.])

            (tab-mark ?\t               ; Tabulation.
                      [?\u25BA ?\t]     ; Black right-pointing pointer.
                      [?\\ ?\t]))))

  ;; ;; Control highlighting of non-ASCII space and hyphen chars, using the
  ;; ;; `nobreak-space' or `escape-glyph' face respectively.
  ;; (setq nobreak-char-display t)      ; [Default]

  ;; ;; Show zero-width spaces.
  ;; (font-lock-add-keywords nil
  ;;  `((,(format "\\(%c\\)" ?\u200B) ; #\ZERO_WIDTH_SPACE
  ;;     (1 (progn (compose-region (match-beginning 1) (match-end 1)
  ;;                               ?\u2B1B ; #\BLACK_LARGE_SQUARE
  ;;                               'decompose-region)
  ;;               nil)))))

;;** 14.18 (info "(emacs)Optional Mode Line") Features

  (leuven--section "14.18 (emacs)Optional Mode Line Features")

  ;; Show the column number in each mode line.
  (column-number-mode 1)

  ;; Unclutter the mode line.
  (with-eval-after-load 'diminish-autoloads
    (with-eval-after-load 'abbrev       (diminish 'abbrev-mode " Ab"))
    (with-eval-after-load 'anzu         (diminish 'anzu-mode))
    (with-eval-after-load 'back-button  (diminish 'back-button-mode))
    (with-eval-after-load 'volatile-highlights (diminish 'volatile-highlights-mode))
    (with-eval-after-load 'checkdoc     (diminish 'checkdoc-minor-mode " Cd"))
    ;; (with-eval-after-load 'company      (diminish 'company-mode " Cp"))
                                        ; Company displays the currently used
                                        ; backend in the mode-line.
    (with-eval-after-load 'eldoc        (diminish 'eldoc-mode))
    (with-eval-after-load 'color-identifiers-mode (diminish 'color-identifiers-mode))
    (with-eval-after-load 'fancy-narrow (diminish 'fancy-narrow-mode))
    (with-eval-after-load 'flycheck     (diminish 'flycheck-mode " fC")) ; Wanna see FlyC:1/1.
    (with-eval-after-load 'flyspell     (diminish 'flyspell-mode " fS"))
    (with-eval-after-load 'hilit-chg    (diminish 'highlight-changes-mode))
    ;; (with-eval-after-load 'isearch      (diminish 'isearch-mode (string 32 ?\u279c)))
    (with-eval-after-load 'paredit      (diminish 'paredit-mode " Pe"))
    (with-eval-after-load 'projectile-mode (diminish 'projectile-mode))
    (with-eval-after-load 'rainbow-mode (diminish 'rainbow-mode))
    (with-eval-after-load 'simple       (diminish 'auto-fill-function))
    (with-eval-after-load 'whitespace   (diminish 'whitespace-mode))
    ;; (diminish-on-load hs-minor-mode-hook hs-minor-mode)
    (with-eval-after-load 'glasses      (diminish 'glasses-mode))
    ;; (with-eval-after-load 'redshank     (diminish 'redshank-mode))
    ;; (with-eval-after-load 'smartparens  (diminish 'smartparens-mode)) ;; Don't hide it, as it impacts perf on big files (must see it!)
    (with-eval-after-load 'which-key    (diminish 'which-key-mode)))
    ;; (with-eval-after-load 'whitespace   (diminish 'whitespace-mode))

  (defface powerline-modified-face
    '((t (:background "#FFA335" :foreground "black" :weight bold)))
    "Face to fontify modified files."
    :group 'powerline)

  (defface powerline-normal-face
    '((t (:background "#4F9D03" :foreground "black" :weight bold)))
    "Face to fontify unchanged files."
    :group 'powerline)

  (defface powerline-default-dictionary-active-face
    '((t (:background "#8A2BE2" :foreground "black" :weight bold)))
    "Face to fontify default dictionary in the active buffer."
    :group 'powerline)

  (defface powerline-default-dictionary-inactive-face
    '((t (:background "thistle" :foreground "black" :weight bold)))
    "Face to fontify default dictionary in inactive buffers."
    :group 'powerline)

  (defface powerline-other-dictionary-active-face
    '((t (:background "yellow" :foreground "black" :weight bold)))
    "Face to fontify another dictionary in the active buffer."
    :group 'powerline)

  (defface powerline-other-dictionary-inactive-face
    '((t (:background "LightYellow1" :foreground "black" :weight bold)))
    "Face to fontify another dictionary in inactive buffers."
    :group 'powerline)

  (defface powerline-buffer-position-face
    '((t (:background "#D2D2D2" :foreground "#282828")))
    "Face to fontify buffer position."
    :group 'powerline)

  (defface powerline-column-over-80
    '((t (:background "red" :foreground "yellow" :weight bold)))
    "Face for column number when it's over 80."
    :group 'powerline)

  (defun powerline--get-face (active face1 face2)
    "Return the appropriate face based on active status."
    (if active face1 face2))

  (defun powerline--get-vc-state-face (vc-state)
    "Return the correct face for a given vc-state."
    (if (eq vc-state 'up-to-date)
        'powerline-normal-face
      'powerline-modified-face))

  (defun powerline-simpler-vc-mode (s)
    "Simplify the display of VC mode, removing unnecessary parts."
    (if s
        (replace-regexp-in-string "\\(Git\\|SVN\\)[-:]" "" s)
      s))

  (defun powerline-leuven-theme ()
    "Setup the Leuven mode-line theme."
    (interactive)
    (setq-default mode-line-format
      '("%e"
        (:eval
         (let* ((active (powerline-selected-window-active))
                (mode-line (if active 'mode-line 'mode-line-inactive))
                (face1 (powerline--get-face active 'powerline-active1 'powerline-inactive1))
                (face2 (powerline--get-face active 'powerline-active2 'powerline-inactive2))
                (default-dictionary-face (powerline--get-face active
                                                             'powerline-default-dictionary-active-face
                                                             'powerline-default-dictionary-inactive-face))
                (other-dictionary-face (powerline--get-face active
                                                            'powerline-other-dictionary-active-face
                                                            'powerline-other-dictionary-inactive-face))
                (separator-left (intern (format "powerline-%s-%s"
                                               powerline-default-separator
                                               (car powerline-default-separator-dir))))
                (separator-right (intern (format "powerline-%s-%s"
                                                powerline-default-separator
                                                (cdr powerline-default-separator-dir))))
                (lhs (list
                      ;; VC Mode.
                      (when (and (fboundp 'vc-switches)
                                 buffer-file-name
                                 vc-mode)
                        (powerline-simpler-vc-mode (powerline-vc (powerline--get-vc-state-face (vc-state buffer-file-name)) 'r)))
                      (when (and (not (fboundp 'vc-switches))
                                 buffer-file-name
                                 vc-mode)
                        (powerline-simpler-vc-mode (powerline-vc face1 'r)))

                      (when (and buffer-file-name
                                 vc-mode)
                        (funcall separator-left (powerline--get-vc-state-face (vc-state buffer-file-name)) mode-line))

                      ;; "Modified" indicator.
                      (if (not (buffer-modified-p))
                          (powerline-raw "%*" nil 'l)
                        (powerline-raw "%*" 'mode-line-emphasis 'l))

                      (powerline-raw mode-line-mule-info nil 'l)

                      (powerline-buffer-id 'mode-line-buffer-id 'l)

                      (when (and (boundp 'which-func-mode) which-func-mode)
                        (powerline-raw which-func-format nil 'l))

                      (powerline-raw " ")
                      (funcall separator-left mode-line face1)
                      (when (boundp 'erc-modified-channels-object)
                        (powerline-raw erc-modified-channels-object face1 'l))
                      (powerline-major-mode face1 'l)
                      (powerline-process face1)
                      (powerline-raw " " face1)
                      (funcall separator-left face1 face2)
                      (powerline-minor-modes face2 'l)
                      (powerline-narrow face2 'l)
                      (powerline-raw " " face2)
                      (funcall separator-left face2 mode-line)))
                (rhs (list (powerline-raw global-mode-string mode-line 'r)
                           (funcall separator-right mode-line face1)
                           (powerline-raw "%l," face1 'l)
                           (propertize "%c" 'face
                                    (if (> (current-column) 80)
                                        'powerline-column-over-80
                                      face1))
                           (powerline-raw " " face1)
                           (funcall separator-right face1 'powerline-buffer-position-face)
                           (powerline-raw " %3p" 'powerline-buffer-position-face 'r)
                           (funcall separator-right 'powerline-buffer-position-face face2)
                           (powerline-buffer-size face2 'l)
                           (powerline-raw " " face2)

                           ;; Dictionary indicator.
                           (let ((dict (and (featurep 'ispell)
                                            (or ispell-local-dictionary
                                                ispell-dictionary))))
                             (cond (buffer-read-only
                                     (powerline-raw "%%%% " default-dictionary-face 'l))
                                    ((null dict)
                                     (powerline-raw "-- " default-dictionary-face 'l))
                                   (t
                                    (powerline-raw (concat (substring dict 0 2) " ") other-dictionary-face 'l))))

                          ;; (powerline-hud face2 face1)
                          )))
          (concat (powerline-render lhs)
                  (powerline-fill mode-line (powerline-width rhs))
                  (powerline-render rhs)))))))

  (with-eval-after-load 'powerline-autoloads
    ;; Apply theme after full startup.
    (add-hook 'emacs-startup-hook #'powerline-leuven-theme))

;;** 14.19 The (info "(emacs)")

  (leuven--section "14.19 (emacs)")

  ;; Set the default tab width of a TAB character to 4 spaces.
  (setq-default tab-width 4)

;;** 14.20 The (info "(emacs)Cursor Display")

  (leuven--section "14.20 (emacs)The Cursor Display")

  ;; Cursor customization based on buffer state.
  (defun lvn--update-cursor-appearance ()
    "Update cursor color and shape based on buffer state (read-only, overwrite, or insert)."
    (interactive)  ; Allow manual invocation if needed.
    (let* ((is-light-theme (eq (frame-parameter nil 'background-mode) 'light))
           (cursor-colors `((read-only . "purple1")
                           (overwrite . "#7F7F7F")
                           (default . ,(if is-light-theme "black" "white"))))
           (current-color (cond (buffer-read-only (alist-get 'read-only cursor-colors))
                                (overwrite-mode (alist-get 'overwrite cursor-colors))
                                (t (alist-get 'default cursor-colors))))
           (current-type (if overwrite-mode 'box 'bar)))
      (set-cursor-color current-color)
      (setq cursor-type current-type)))

  ;; Update cursor on every command.
  (add-hook 'post-command-hook #'lvn--update-cursor-appearance)

  ;; Default to bar cursor.
  (setq-default cursor-type 'bar)

  ;; Cursor blinks indefinitely.
  (setq blink-cursor-blinks 0)

  ;; Enable highlighting of the current line in all buffers.
  (global-hl-line-mode 1)

;;** 14.21 (info "(emacs)Line Truncation")

  (leuven--section "14.21 (emacs)Line Truncation")

  ;; Respect the value of `truncate-lines' in all windows less than the full
  ;; width of the frame.
  (setq truncate-partial-width-windows nil)

;;** 14.23 (info "(emacs)Display Custom")ization

  (leuven--section "14.23 (emacs)Display Customization")

  ;; Echo what I'm typing *immediately*.
  (setq echo-keystrokes 0.01)

  ;; Let emacs react faster to keystrokes.
  (setq idle-update-delay 0.35)

  ;; Exhaustive log of interactions with Emacs (display keystrokes, etc.).
  (with-eval-after-load 'interaction-log-autoloads

    (autoload 'interaction-log-mode "interaction-log"
      "Global minor mode logging keys, commands, file loads and messages." t)
                                        ; This autoload isn't defined in
                                        ; `interaction-log-autoloads'!

    ;; ;; Maximum number of lines to keep in the *Emacs Log* buffer.
    ;; (setq ilog-log-max 10)

    (defun leuven-display-interaction-log ()
      "Display the Interaction-Log buffer."
      (interactive)
      (interaction-log-mode 1)
      (display-buffer ilog-buffer-name))

    ;; Hotkey for showing the log buffer.
    (global-set-key (kbd "C-h C-l") #'leuven-display-interaction-log))

)                                       ; Chapter 14 ends here.

;;* 15 (info "(emacs)Search")ing and Replacement

(leuven--chapter leuven-load-chapter-15-search "15 Searching and Replacement"

;;** 15.1 (info "(emacs)Incremental Search")

  (leuven--section "15.1 (emacs)Incremental Search")

  ;; FIXME Error when selecting search string from kill ring (`M-p')
  ;; ;; Always exit searches at the beginning of the expression found.
  ;; (add-hook 'isearch-mode-end-hook #'isearch-goto-match-beginning)
  ;;
  ;; (defun isearch-goto-match-beginning ()
  ;;   "Use with isearch hook to end search at first char of match."
  ;;   (when isearch-forward (goto-char isearch-other-end)))

  ;; ;; Incremental search/query-replace will open the contents.
  ;; (setq search-invisible 'open)         ; XXX

  ;; Don't re-hide an invisible match right away.
  (setq isearch-hide-immediately nil)   ; XXX

  ;; Scrolling commands are allowed during incremental search (without canceling
  ;; Isearch mode).
  (setq isearch-allow-scroll t)

  ;; Fuzzy matching utilities (a must-have).
  (with-eval-after-load 'fuzzy-autoloads

    (autoload 'turn-on-fuzzy-isearch "fuzzy" nil t)
                                        ; This autoload isn't defined in
                                        ; `fuzzy-autoloads'!

    (add-hook 'isearch-mode-hook #'turn-on-fuzzy-isearch))

  ;; Show number of matches in mode-line while searching.
  (use-package anzu
    :ensure t
    ;; Enable Global-Anzu mode.
    :hook (after-init . global-anzu-mode)
    :custom
    ;; Separator of `to' string.
    (anzu-replace-to-string-separator " => ")
    :config
    ;; Function which returns mode-line string.
    (defun lvn--anzu-format-mode-line (here total)
      "Return a mode-line string based on anzu search state.
    HERE is the current position, TOTAL is the number of matches."
      (when anzu--state
        (let* ((format-string
                (cl-case anzu--state
                  (search (if (> total 1)
                              " %s of %d%s matches "
                            " %s of %d%s match "))
                  (replace-query " %d replace ")
                  (replace (if (> total 1)
                               " %d of %d matches "
                             " %d of %d match "))))
               (status-text
                (format format-string
                        (if (eq anzu--state 'search)
                            (anzu--format-here-position here total)
                          here)
                        total
                        (if (and (eq anzu--state 'search) anzu--overflow-p)
                            "+"
                          "")))
               (face (if (and (zerop total) (not (string= isearch-string "")))
                         'anzu-mode-line-no-match
                       'anzu-mode-line)))
          (propertize status-text 'face face))))
    ;; Set the update function.
    (setq anzu-mode-line-update-function #'lvn--anzu-format-mode-line))

    ;; ;; Lighter of anzu-mode.
    ;; (setq anzu-mode-lighter "")
    ;;
    ;; ;; Deactive region if you use anzu a replace command with region.
    ;; (setq anzu-deactivate-region t)
    ;;
    ;; ;; Override binding for `query-replace'.
    ;; (global-set-key (kbd "M-%")   #'anzu-query-replace)
    ;; (global-set-key (kbd "C-M-%") #'anzu-query-replace-regexp)
    ;;
    ;; ;; (define-key isearch-mode-map (kbd "M-%") #'anzu-query-replace)

(unless (fboundp 'anzu-mode)

  ;; Enable lazy counting during Isearch.
  (setq isearch-lazy-count t)

  ;; Set the format for displaying lazy count prefix.
  (setq lazy-count-prefix-format "(%s of %s) "))

    ;; Used in Visual Studio Code and IntelliJ IDEA.
    (defun lvn-find-usages ()
      "Approximate 'find usages' using occur command."
      (interactive)
      (let ((symbol (symbol-at-point)))
        (if symbol
            (progn
              (occur (format "\\_<%s\\_>" (regexp-quote (symbol-name symbol))))
              (switch-to-buffer "*Occur*"))
          (message "[No symbol at point]"))))

    (global-set-key (kbd "<C-M-f7>") 'lvn-find-usages)

;;** 15.5 (info "(emacs)Regexp Search")

  (leuven--section "15.5 (emacs)Regexp Search")

  (setq isearch-regexp-lax-whitespace t)
  (setq search-whitespace-regexp "[ \t\r\n]+")

;;** 15.9 (info "(emacs)Search Case")

  (leuven--section "15.9 (emacs)Search Case")

  ;; Searches should ignore case by default (in all buffers that do not
  ;; override this).
  (setq-default case-fold-search t)

;;** 15.11 (info "(emacs)Other Repeating Search") Commands

  (leuven--section "15.11 (emacs)Other Repeating Search Commands")

  ;; Unset keybinding to avoid conflicts. XXX???
  (global-unset-key (kbd "M-o"))

  ;; Bind "M-o" to invoke "multi-occur" during Isearch.
  (define-key isearch-mode-map (kbd "M-o") #'helm-multi-swoop-all)

  ;; Grep all same extension files from inside Isearch.
  (defun lvn-grep-search-isearch-string ()
    "Start grep using the current isearch string.

This function initiates a grep search based on the current isearch string. If
the isearch is using regular expressions, it directly uses the isearch-string.
Otherwise, it converts the isearch-string to a regular expression.

The search is performed in files with a pattern corresponding to the current
buffer's file extension, and the search is conducted in the default directory.

After initiating the grep search, the isearch is aborted."
    (interactive)
    (let* ((search-str (if isearch-regexp isearch-string (regexp-quote isearch-string)))
           (file-pattern (if (buffer-file-name)
                             (format "*.%s" (file-name-extension (buffer-file-name)))
                           "*"))
           (default-dir default-directory))
      (grep-compute-defaults)
      (lgrep search-str file-pattern default-dir)
      (isearch-abort)))

  (define-key isearch-mode-map (kbd "C-M-o") #'lvn-grep-search-isearch-string)

  (defun lvn-keep-duplicate-lines ()
    "Keep only lines that are duplicated in the current buffer."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (let ((lines '())
            (duplicated-lines '())
            line)
        (while (not (eobp))
          (setq line (buffer-substring-no-properties
                      (line-beginning-position)
                      (line-end-position)))
          (if (member line lines)
              (unless (member line duplicated-lines)
                (push line duplicated-lines))
            (push line lines))
          (forward-line 1))
        (erase-buffer)
        (dolist (l (reverse duplicated-lines))
          (insert l "\n"))
        (message "[Non-duplicated lines deleted from the buffer]"))))

)                                       ; Chapter 15 ends here.

;;* 16 Commands for (info "(emacs)Fixit") Typos

(leuven--chapter leuven-load-chapter-16-fixit "16 Commands for Fixing Typos"

;;** 16.4 Checking and Correcting (info "(emacs)Spelling")

  (leuven--section "16.4 (emacs)Checking and Correcting Spelling")

  ;; Spelling checker program.
  (setq ispell-program-name             ; Defined in ispell.el.
        (or (executable-find "aspell")
            (executable-find "hunspell")
            (executable-find "ispell")))

  (defun lvn--executable-ispell-program-name-p ()
    "Ensure that `ispell-program-name' is an executable program name."
    (and (bound-and-true-p ispell-program-name)
         (file-executable-p ispell-program-name)
         ispell-program-name))

  (when (lvn--executable-ispell-program-name-p)

    (defun lvn-ispell-region-or-buffer ()
      "Interactively check the current region or buffer for spelling errors."
      (interactive)
      (if mark-active
          (ispell-region (min (point) (mark)) (max (point) (mark)))
        (ispell-buffer)))

    ;; Key bindings (Should we use the `C-c i' prefix key binding?).
    (global-set-key (kbd "C-$") #'lvn-ispell-region-or-buffer)
    (global-set-key (kbd "C-M-$") #'ispell-change-dictionary)

    ;; ;; Default dictionary to use (if `ispell-local-dictionary' is nil, that is
    ;; ;; if there is no local dictionary to use in the buffer).
    ;; (setq ispell-dictionary "american") ; See `sentence-end-double-space'.

    ;; Set American English dictionary for text and programming modes.
    (dolist (hook '(text-mode-hook prog-mode-hook))
      (add-hook hook
                (lambda ()
                  (setq ispell-dictionary "american"))))

    ;; Enable Flyspell-Prog in programming modes (including comments and
    ;; strings, while excluding code).
    (add-hook 'prog-mode-hook #'flyspell-prog-mode)

    (with-eval-after-load 'ispell

      ;; Save the personal dictionary without confirmation.
      (setq ispell-silently-savep t)

      ;; Configure extensions and extra switches for the `ispell' program.
      (cond

       ((string-match "aspell" ispell-program-name)
        (setq ispell-extra-args '("--sug-mode=ultra" "-C"))
        (setq ispell-really-aspell t)
        (setq ispell-really-hunspell nil))

       ((string-match "ispell" ispell-program-name)
        (setq ispell-extra-args '())
        (setq ispell-really-aspell nil)
        (setq ispell-really-hunspell nil)))

      ;; (setq-default mode-line-format
      ;;               (cons
      ;;                '(:eval
      ;;                  (let ((dict (and (featurep 'ispell)
      ;;                                   (not buffer-read-only)
      ;;                                   (or ispell-local-dictionary
      ;;                                       ispell-dictionary
      ;;                                       "--" ; default dictionary
      ;;                                       ))))
      ;;                    (and dict
      ;;                         (propertize (concat " " (substring dict 0 2))
      ;;                                     'face 'mode-line-highlight))))
      ;;                (default-value 'mode-line-format)))

      )

    (with-eval-after-load 'flyspell

      ;; Remove the binding of `flyspell-auto-correct-previous-word', to be used
      ;; by Multiple Cursors.
      (define-key flyspell-mode-map (kbd "C-;") nil))

    ;; Don't use `M-TAB' to auto-correct the current word (only use `C-.').
    (setq flyspell-use-meta-tab nil)
    ;; FIXME M-TAB is still bound to `flyspell-auto-correct-word' when this
    ;; chunk of code is placed within (with-eval-after-load 'flyspell...)

    (with-eval-after-load 'flyspell

      ;; Don't consider that a word repeated twice is an error.
      (setq flyspell-mark-duplications-flag nil)

      ;; Lower (for performance reasons) the maximum distance for finding
      ;; duplicates of unrecognized words.
      (setq flyspell-duplicate-distance 12000) ; [default: 400000]

      ;; Fix the "enabling flyspell mode gave an error" bug.
      (setq flyspell-issue-welcome-flag nil)

      ;; ;; Don't print messages for every word (when checking the entire buffer) as
      ;; ;; it causes a (small) slowdown.
      ;; (setq flyspell-issue-message-flag nil)

      ;; Dash character (`-') is considered as a word delimiter.
      (setq-default flyspell-consider-dash-as-word-delimiter-flag t)

      (defun lvn-toggle-ispell-dictionary ()
        "Toggle the ispell dictionary between French and US English."
        (interactive)
        (let ((current-dict (or ispell-local-dictionary
                                ispell-dictionary))
              (new-dict))
          (setq new-dict (if (string= current-dict "francais")
                             "american"
                           "francais"))
          (ispell-change-dictionary new-dict)
          (message "[Switched to %S]" new-dict)
          (sit-for 0.5)
          (force-mode-line-update)
          (when flyspell-mode
            ;; (flyspell-delete-all-overlays)
            ;; If above is executed, the advised `org-mode-flyspell-verify'
            ;; won't work anymore.
            (flyspell-buffer))))

      ;; Key bindings.
      (global-set-key (kbd "C-$") #'flyspell-buffer)
      (global-set-key (kbd "C-M-$") #'lvn-toggle-ispell-dictionary)

      ;; Spell-check your XHTML (by adding `nxml-text-face' to the list of
      ;; faces corresponding to text in programming-mode buffers).
      (add-to-list 'flyspell-prog-text-faces 'nxml-text-face)))

)                                       ; Chapter 16 ends here.

;;* 17 (info "(emacs)Keyboard Macros")

(leuven--chapter leuven-load-chapter-17-keyboard-macros "17 Keyboard Macros"

;;** 17.1 (info "(emacs)Basic Keyboard Macro") Use

  (leuven--section "17.1 (emacs)Basic Keyboard Macro Use")

  (defun lvn-kmacro-toggle-recording ()
    "Toggle keyboard macro recording on and off."
    (interactive)
    (if defining-kbd-macro
        (progn
          (global-set-key (kbd "<S-f8>") #'lvn-kmacro-turn-on-recording)
          (kmacro-end-macro nil))
      (progn
        (global-set-key (kbd "<S-f8>") #'lvn-kmacro-turn-off-recording)
        (kmacro-start-macro nil))))

  (defun lvn-kmacro-turn-on-recording ()
    "Start recording a keyboard macro."
    (interactive)
    (global-set-key (kbd "<S-f8>") #'lvn-kmacro-toggle-recording)
    (kmacro-start-macro nil))

  (defun lvn-kmacro-turn-off-recording ()
    "Stop recording a keyboard macro."
    (interactive)
    (global-set-key (kbd "<S-f8>") #'lvn-kmacro-toggle-recording)
    (kmacro-end-macro nil))

  ;; Start/stop recording a keyboard macro.
  (global-set-key (kbd "<S-f8>") #'lvn-kmacro-toggle-recording)

  ;; Execute the most recent keyboard macro.
  (global-set-key (kbd "<f8>") #'kmacro-call-macro)

;;** 17.5 Name and (info "(emacs)Save Keyboard Macro")s

  (leuven--section "17.5 (emacs)Name and Save Keyboard Macros")

  ;; Assign a name to the last keyboard macro defined.
  (global-set-key (kbd "<C-f8>") #'kmacro-name-last-macro)

)                                       ; Chapter 17 ends here.

;;* 18 (info "(emacs)Files") Handling

(leuven--chapter leuven-load-chapter-18-files "18 Files Handling"

;;** 18.2 (info "(emacs)Visiting") Files

  (leuven--section "18.2 (emacs)Visiting Files")

  (defun lvn--find-file-time-advice (orig-fun &rest args)
    "Advice function for `find-file' that reports the time spent on file loading."
    (let* ((filename (car args))
           (find-file-time-start (float-time)))
      (message "[Finding file %s...]" filename)
      (let ((result (apply orig-fun args)))
        (message "[Found file %s in %.2f s]" filename
                 (- (float-time) find-file-time-start))
        result)))

  (advice-add 'find-file :around #'lvn--find-file-time-advice)

  ;; Visit a file.
  (global-set-key (kbd "<f3>") #'find-file)

  (defcustom lvn-large-file-warning-threshold
    (* 512 1024 1024) ; 512 MB
    "Threshold for the 'File xxx is large, really open? (y or n)' warning."
    :group 'leuven
    :type 'integer)

  ;; Maximum buffer size for which line number should be displayed.
  (setq line-number-display-limit lvn-large-file-warning-threshold)
                                        ; 14.18 Optional Mode Line Features.

  (defun lvn-file-too-large-p ()
    "Check if the file is too large and might cause performance issues."
    (> (buffer-size) lvn-large-file-warning-threshold))

  (defun lvn-optimize-large-file-viewing ()
    "Optimize Emacs performance when viewing large files."
    (setq buffer-read-only t)
    (setq-local bidi-display-reordering nil) ; Default local setting.
    (jit-lock-mode nil)
    (buffer-disable-undo)
    (set (make-variable-buffer-local 'global-hl-line-mode) nil)
    (set (make-variable-buffer-local 'line-number-mode) nil)
    (set (make-variable-buffer-local 'column-number-mode) nil)

    ;; Disable costly modes.
    (when (fboundp 'smartparens-mode)
      (smartparens-mode -1))
    (when (fboundp 'anzu-mode)
      (anzu-mode -1)))

  (define-derived-mode lvn-large-file-mode fundamental-mode "LvnLargeFile"
    "Major mode for optimized viewing of large files."
    (lvn-optimize-large-file-viewing))

  (add-to-list 'magic-mode-alist (cons #'lvn-file-too-large-p #'lvn-large-file-mode))

  ;; (defun leuven-find-large-file-conservatively (filename)
  ;;   (interactive
  ;;    (list (read-file-name
  ;;           "Find file conservatively: " nil default-directory
  ;;           (confirm-nonexistent-file-or-buffer))))
  ;;   (let ((auto-mode-alist nil))
  ;;     (find-file filename)
  ;;     (fundamental-mode)
  ;;     (leuven--view-large-file)))

;;** 18.3 (info "(emacs)Saving") Files

  (leuven--section "18.3 (emacs)Saving Files")

  (defun lvn--report-saving-time (orig-fun &rest args)
    "Save the file and report time spent."
    (let* ((filename (buffer-file-name))
           (start-time (float-time)))
      (message "[Saving file %s...]" filename)
      (let ((result (apply orig-fun args)))
        (message "[Saved file %s in %.2f s]" filename
                 (- (float-time) start-time))
        result)))

  (advice-add 'save-buffer :around #'lvn--report-saving-time)

  ;; Make your changes permanent.
  (global-set-key (kbd "<f2>") #'save-buffer)

  ;; Enable numbered backups.
  (setq version-control t)

  ;; Set the backup directory path for Emacs backups.
  (defcustom lvn-backup-directory "~/.emacs.d/backups/"
    "Directory path for Emacs backups."
    :group 'leuven
    :type 'directory)

  ;; Create the backup directory if it doesn't exist.
  (when (not (file-exists-p lvn-backup-directory))
    (make-directory lvn-backup-directory t))

  ;; Configure backup files to be saved in the central backup location.
  (setq backup-directory-alist `(("." . ,lvn-backup-directory)))

  ;; ;; Number of oldest versions to keep when a new numbeRed backup is made.
  ;; (setq kept-old-versions 0)            ; [Default: 2]

  ;; Number of newest versions to keep when a new numbered backup is made.
  (setq kept-new-versions 5)            ; [Default: 2]

  ;; Don't ask me about deleting excess backup versions.
  (setq delete-old-versions t)

  ;; Always use copying to create backup files (don't clobber symlinks).
  (setq backup-by-copying t)

  ;; Ensure newline at end of file for text-based modes.
  (defun lvn--ensure-final-newline ()
    "Ensure a final newline is added when saving text-based buffers."
    (setq-local mode-require-final-newline t))

  (dolist (hook '(text-mode-hook fundamental-mode-hook))
    (add-hook hook #'lvn--ensure-final-newline))

  ;; Automatically update timestamps and copyright notices before saving.
  (defun lvn--update-timestamps-and-copyright ()
    "Update timestamps and copyright notices in the buffer before saving.
  Skips updates in `diff-mode' buffers."
    (unless (derived-mode-p 'diff-mode)
      (time-stamp)
      (copyright-update)))

  ;; Configure timestamp format after loading `time-stamp'.
  (with-eval-after-load 'time-stamp
    (setq-default time-stamp-format "%:y-%02m-%02d %3a %02H:%02M")
    ;; %:y = 4-digit year, %02m = 2-digit month, %02d = 2-digit day,
    ;; %3a = 3-letter day abbreviation, %02H:%02M = 24-hour:minutes.
  )

  ;; Add update function to `before-save-hook'.
  (add-hook 'before-save-hook #'lvn--update-timestamps-and-copyright)

;;** 18.4 (info "(emacs)Reverting") a Buffer

  (leuven--section "18.4 (emacs)Reverting a Buffer")

  ;; Time between Auto-Revert Mode file checks.
  (setq auto-revert-interval 1)         ; [Default: 5]

  ;; ;; But if, for instance, a new version is checked in from outside the current
  ;; ;; Emacs session, the version control number in the mode line, as well as
  ;; ;; other version control related information, may not be properly updated
  ;; (setq auto-revert-check-vc-info t)

  ;; Sync buffer with disk and clear specific highlights.
  (defun lvn-sync-buffer-and-clear-overlays ()
    "Revert buffer from disk and remove specified overlays in visible area."
    (interactive)
    (revert-buffer t t) ;; Ignore auto-save and confirm prompts.
    (dolist (ov (overlays-in (window-start) (window-end)))
      (when (memq (overlay-get ov 'face)
                  '(recover-this-file
                    highlight-changes
                    highlight-changes-delete
                    org-block-executing))
        (delete-overlay ov)))
    (message "[Buffer synced with disk]"))

  ;; Bind to C-S-y globally.
  (global-set-key (kbd "C-S-y") #'lvn-sync-buffer-and-clear-overlays)

  (when (and (bound-and-true-p lvn--cygwin-p)
                                        ; Cygwin Emacs uses gfilenotify (based
                                        ; on GLib) and there are performance
                                        ; problems... Emacs bug 20927
             (fboundp 'auto-revert-use-notify))  ; Ensure the function is defined.

    ;; Disable file notification functions.
    (setq auto-revert-use-notify nil))  ; XXX Apply this in EmacsW32 if it doesn't revert!

  (use-package autorevert
    ;; Defer loading until explicitly needed or triggered.
    :defer t
    :init
    ;; Load autorevert after 2 seconds of idle time.
    (run-with-idle-timer 2 nil (lambda () (require 'autorevert)))
    :config
    ;; This runs when autorevert is loaded.
    ;; Enable Global Auto-Revert mode to auto-refresh buffers.
    (global-auto-revert-mode 1)
    ;; Check and warn about remote files setting.
    (when (and (boundp 'auto-revert-remote-files)
               auto-revert-remote-files)
      (warn "`auto-revert-remote-files' is non-nil, this may generate significant network traffic.")))

  ;; Consider setting `auto-revert-remote-files' to nil to reduce network
  ;; traffic.

  ;; Load autorevert after 2 seconds of idle time.
  (idle-require 'autorevert)

  ;; Global Auto-Revert mode operates on all buffers (Dired, etc.)
  (setq global-auto-revert-non-file-buffers t)

  ;; Do not generate any messages (be quiet about refreshing Dired).
  (setq auto-revert-verbose nil)        ; Avoid "Reverting buffer `some-dir/'.".

;;** 18.6 (info "(emacs)Auto Save"): Protection Against Disasters

  (leuven--section "18.6 (emacs)Auto Save: Protection Against Disasters")

  ;; Auto-save every 100 input events.
  (setq auto-save-interval 100)         ; [Default: 300].

  ;; Save files automatically if application is idle for 15 sec.
  (setq auto-save-timeout 15)           ; [Default: 30].

  (define-minor-mode sensitive-mode
    "For sensitive files like password lists.
  It disables backup creation and auto saving in the current buffer.

  With no argument, this command toggles the mode.  Non-null prefix argument
  turns on the mode.  Null prefix argument turns off the mode."
    :init-value nil                     ; Initial value.
    :lighter " Sensitive"               ; Indicator for the mode line.
    :keymap nil                         ; Minor mode bindings.
    (if (symbol-value sensitive-mode)
        (progn
          ;; Disable backups.
          (set (make-local-variable 'backup-inhibited) t)
          ;; Disable auto-save.
          (if auto-save-default
              (auto-save-mode -1)))
      ;; Resort to default value of backup-inhibited.
      (kill-local-variable 'backup-inhibited)
      ;; Resort to default auto save setting.
      (if auto-save-default
          (auto-save-mode 1))))

  (defface recover-this-file
    '((t :weight bold :background "#FF3F3F"))
    "Face for buffers visiting files with auto save data."
    :group 'files)

  (defvar leuven--recover-this-file nil
    "If non-nil, an overlay indicating that the visited file has auto save data.")

  (defun leuven--recover-this-file ()
    (let ((warn (not buffer-read-only)))
      (when (and warn
                 ;; No need to warn if buffer is auto-saved under the name of
                 ;; the visited file.
                 (not (and buffer-file-name
                           auto-save-visited-mode)) ; Emacs 26.1
                 (file-newer-than-file-p (or buffer-auto-save-file-name
                                             (make-auto-save-file-name))
                                         buffer-file-name))
        (set (make-local-variable 'leuven--recover-this-file)
             (make-overlay (point-min) (point-max)))
        (overlay-put leuven--recover-this-file
                     'face 'recover-this-file))))

  (add-hook 'find-file-hook #'leuven--recover-this-file)

;;** 18.9 (info "(emacs)Comparing Files")

  (leuven--section "18.9 (emacs)Comparing Files")

  ;; ;; Default to unified diffs.
  ;; (setq diff-switches "-u")             ; Default in Emacs 25.

  (defun leuven-ediff-files-from-dired ()
"Quickly Ediff files from Dired"
    (interactive)
    (let ((files (dired-get-marked-files))
          (wnd (current-window-configuration)))
      (if (<= (length files) 2)
          (let ((file1 (car files))
                (file2 (if (cdr files)
                           (cadr files)
                         (read-file-name
                          "File B to compare: "
                          (dired-dwim-target-directory)))))
            (if (file-newer-than-file-p file1 file2)
                (ediff-files file2 file1)
              (ediff-files file1 file2))
            (add-hook 'ediff-after-quit-hook-internal
                      (lambda ()
                        (setq ediff-after-quit-hook-internal nil)
                        (set-window-configuration wnd))))
        (error "no more than 2 files should be marked"))))

  (with-eval-after-load 'dired
    (define-key dired-mode-map (kbd "E") #'leuven-ediff-files-from-dired))

  ;; Compare text in current window with text in next window.
  (global-set-key (kbd "C-=") #'compare-windows)

  ;; Change the cumbersome default prefix (C-c ^).
  (setq smerge-command-prefix (kbd "C-c v"))

;;** 18.10 (info "(emacs)Diff Mode")

  (leuven--section "18.10 (emacs)Diff Mode")

  ;; Mode for viewing/editing context diffs.
  (with-eval-after-load 'diff-mode

    ;; Highlight the changes with better granularity.
    (defun leuven-diff-make-fine-diffs ()
      "Enable Diff Auto-Refine mode."
      (interactive)
      (let (diff-refine)                ; Avoid refining the hunks redundantly ...
        (condition-case nil
            (save-excursion
              (goto-char (point-min))
              (while (not (eobp))
                (diff-hunk-next)
                (diff-refine-hunk)))    ; ... when this does it.
          (error nil))
        (run-at-time 0.0 nil
                     (lambda ()
                       (if (derived-mode-p 'diff-mode)
                           ;; Put back the cursor only if still in a Diff buffer
                           ;; after the delay.
                           (goto-char (point-min)))))))

    (defun vc-diff--diff-make-fine-diffs-if-necessary (&optional historic not-urgent)
      "Auto-refine only the regions of 14,000 bytes or less."
      ;; Check for auto-refine limit.
      (unless (> (buffer-size) 14000)
        (leuven-diff-make-fine-diffs)))
    ;; Push the auto-refine function after `vc-diff'.
    (advice-add 'vc-diff :after #'vc-diff--diff-make-fine-diffs-if-necessary)

    (defun vc-diff-finish--handle-color-in-diff-output (buffer messages &optional oldbuf)
      "Run `ansi-color-apply-on-region'."
      (interactive)
      (progn
        (require 'ansi-color)
        (let ((inhibit-read-only t))
          (ansi-color-apply-on-region (point-min) (point-max)))))
    (advice-add 'vc-diff-finish :after #'vc-diff-finish--handle-color-in-diff-output)

    )

  ;; ;; Ediff, a comprehensive visual interface to diff & patch
  ;; ;; setup for Ediff's menus and autoloads
  ;; (try-require 'ediff-hook)
  ;; already loaded (by Emacs?)

  (with-eval-after-load 'ediff

    ;; Ignore space.
    (setq ediff-diff-options (concat ediff-diff-options " -w"))
                                        ; Add new options after the default ones.

    ;; Skip over difference regions that differ only in white space and line
    ;; breaks.
    ;; (setq-default ediff-ignore-similar-regions  t)
    ;; XXX Make another key binding (than `E') with that value in a let-bind

    ;; Sometimes grab the mouse and put it in the control frame.
    (setq ediff-grab-mouse 'maybe)

    ;; Do everything in one frame.
    (setq ediff-window-setup-function 'ediff-setup-windows-plain)

    ;; Split the window (horizontally or vertically) depending on the frame
    ;; width.
    (setq ediff-split-window-function
          (lambda (&optional arg)
            (if (> (frame-width) split-width-threshold)
                (split-window-right arg)
              (split-window-below arg))))

    ;; (setq ediff-merge-split-window-function 'split-window-below)

    (defun turn-on-visible-mode ()
      "Make all invisible text visible."
      (visible-mode 1)
      (setq truncate-lines nil)
      (when (and (boundp 'hs-minor-mode)
                 hs-minor-mode)
        (hs-show-all))
      (when (derived-mode-p 'org-mode)
        (org-remove-inline-images)))

    ;; Force the buffers to unhide (folded) text (in Org files).
    (add-hook 'ediff-prepare-buffer-hook #'turn-on-visible-mode)

    (defun turn-off-visible-mode ()
      "Disable Visible mode."
      (visible-mode 0)
      (setq truncate-lines t)
      (when (derived-mode-p 'org-mode)
        (org-display-inline-images)))

    (add-hook 'ediff-quit-hook #'turn-off-visible-mode)

    )

  ;; ("M-m g v" . ztree-dir)
  ;; ("M-m g V" . ztree-diff)

;;** 18.11 (info "(emacs)Misc File Ops")

  (leuven--section "18.11 (emacs)Misc File Ops")

  ;; Use the system's Trash (when it is available).
  (setq delete-by-moving-to-trash t)

  ;; The EasyPG Assistant, transparent file encryption.
  (with-eval-after-load 'epa-file
    (custom-set-variables '(epg-gpg-program "gpg2"))
                                        ; If you have issues, try uninstalling
                                        ; gnupg, keeping only gnupg2!

    ;; Stop EasyPG from asking for the recipient used for encrypting files.
    (setq epa-file-encrypt-to (if (boundp 'user-mail-address)
                                  user-mail-address
                                '("john.doe@example.com")))
                                        ; If no one is selected (""), symmetric
                                        ; encryption will always be performed.

    ;; Cache passphrase for symmetric encryption (VERY important).
    (setq epa-file-cache-passphrase-for-symmetric-encryption t)
                                        ; Not to sound paranoid.  But if you
                                        ; want caching, it's recommended to use
                                        ; *public-key encryption* instead of
                                        ; symmetric encryption.  `gpg-agent' is
                                        ; the preferred way to do this.

    ;; Query passphrase through the minibuffer, instead of using an external
    ;; Pinentry program.
    (setenv "GPG_AGENT_INFO" nil)
    (setq epa-pinentry-mode 'loopback)

    ;; Enable `epa-file'.
    (epa-file-enable))

;;** 18.14 (info "(emacs)Remote Files")

  (leuven--section "18.14 (emacs)Remote Files")

;;*** Ange-FTP

  (leuven--section "Ange-FTP")

  ;; Transparent FTP support.
  (with-eval-after-load 'ange-ftp

    ;; Try to use passive mode in ftp, if the client program supports it.
    (setq ange-ftp-try-passive-mode t)) ; Needed for Ubuntu.

;;*** TRAMP - Transparent Remote Access, Multiple Protocols

  (leuven--section "TRAMP")

  (with-eval-after-load 'tramp         ; The autoloads are predefined.

    ;; Default transfer method.
    (setq tramp-default-method          ; [Default: "scp"]
          (cond (lvn--win32-p "plink")
                (t "ssh")))

    (defun lvn--find-file-sudo-header-warning ()
      "Display a warning in the header line of the current buffer."
      (let* ((warning "WARNING: EDITING FILE WITH ROOT PRIVILEGES!")
             (space (+ 6 (- (frame-width) (length warning))))
             (bracket (make-string (/ space 2) ?-))
             (warning (concat bracket warning bracket)))
        (setq header-line-format
              (propertize warning 'face 'header-line))))

    (defun lvn-find-file-sudo (filename)
      "Open FILENAME with root privileges using Tramp's sudo method."
      (interactive "F")
      (let ((sudo-filename (concat "/sudo::" filename)))
        (find-file sudo-filename)
        (lvn--find-file-sudo-header-warning)))

    (defun lvn--find-file-sudo-advice (orig-fun &rest args)
      "Open FILENAME with root privileges using Tramp's sudo method if it's read-only.
    Prompts the user for confirmation before opening the file as root."
      (let ((filename (car args)))
        (if (and (file-exists-p filename)
                 (not (file-writable-p filename))
                 (not (file-remote-p filename))
                 (y-or-n-p (format "File %s is read-only. Open it as root? " filename)))
            (lvn-find-file-sudo filename)
          (apply orig-fun args))))

    (advice-add 'find-file :around #'lvn--find-file-sudo-advice)

    ;; How many seconds passwords are cached.
    (setq password-cache-expiry 60)     ; [Default: 16]

    ;; "Turn off" the effect of `backup-directory-alist' for TRAMP files.
    (add-to-list 'backup-directory-alist
                 (cons tramp-file-name-regexp nil))

    ;; Faster auto saves.
    (setq tramp-auto-save-directory temporary-file-directory)

    (defun leuven-tramp-beep-advice (&rest _)
      "Make TRAMP beep after performing an operation."
      (when (called-interactively-p 'any)
        (beep)))

    (advice-add 'tramp-handle-write-region :after #'leuven-tramp-beep-advice)
    (advice-add 'tramp-handle-do-copy-or-rename-file :after #'leuven-tramp-beep-advice)
    (advice-add 'tramp-handle-insert-file-contents :after #'leuven-tramp-beep-advice)

    ;; Debugging TRAMP.
    (setq tramp-verbose 6))             ; [Maximum: 10]

;;** 18.17 (info "(emacs)File Conveniences")

  (leuven--section "18.17 (emacs)File Conveniences")

  ;; Filenames excluded from the recent list.
  (setq recentf-exclude                 ; Has to be set before you require
                                        ; `recentf'!
        '(
          ".recentf"
          "~$"                          ; Emacs (and others) backup.
          "\\.aux$" "\\.log$" "\\.toc$" ; LaTeX.
          "/tmp/"
          ))

  ;; Setup a menu of recently opened files.
  (idle-require 'recentf)

  (with-eval-after-load 'recentf

    ;; Maximum number of items that will be saved.
    (setq recentf-max-saved-items 300)  ; Just 20 is too recent.

    ;; File to save the recent list into.
    (setq recentf-save-file (concat user-emacs-directory ".recentf"))

    ;; (When using TRAMP) turn off the cleanup feature of `recentf'.
    (setq recentf-auto-cleanup 'never)  ; Disable before we start recentf!

    ;; Save file names relative to my current home directory.
    (setq recentf-filename-handlers '(abbreviate-file-name))

    ;; Enable recentf-mode
    (recentf-mode 1)

    ;; Remove non-existent files from the recent files list automatically.
    (defun lvn-recentf-cleanup ()
      "Clean up recentf list by removing non-existent files."
      (interactive)
      (setq recentf-list (cl-remove-if-not 'file-exists-p recentf-list))
      (recentf-cleanup))

    ;; Advice recentf-load-list to perform cleanup after loading the recentf
    ;; list.
    (advice-add 'recentf-load-list :after #'lvn-recentf-cleanup))

  (leuven--section "Helm")

  ;; Change `helm-command-prefix-key'.
  (global-set-key (kbd "C-c h") #'helm-command-prefix)

  ;; Open Helm (QuickSilver-like candidate-selection framework).
  (when (locate-library "helm-autoloads")
                                        ; [default `helm-command-prefix-key']
                                        ; Explicitly loads `helm-autoloads'!
                                        ; CAUTION for recursive loads...
    (idle-require 'helm-mode) ; See https://emacs.stackexchange.com/questions/70122/error-running-timer-void-function-helm-completion-flex-transform-pattern
    (global-unset-key (kbd "C-x c"))

    ;; Resume a previous `helm' session.
    (global-set-key (kbd "C-M-z") #'helm-resume)

    ;; Via: http://www.reddit.com/r/emacs/comments/3asbyn/new_and_very_useful_helm_feature_enter_search/
    (setq helm-echo-input-in-header-line t)
    ;; (defun helm-hide-minibuffer-maybe ()
    ;;   (when (with-helm-buffer helm-echo-input-in-header-line)
    ;;     (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
    ;;       (overlay-put ov 'window (selected-window))
    ;;       (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
    ;;                               `(:background ,bg-color :foreground ,bg-color)))
    ;;       (setq-local cursor-type nil))))
    ;;
    ;; (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

    ;; Better version of `occur'.
;;    (global-set-key [remap occur] #'helm-occur) ; helm-regexp.el
    (global-set-key (kbd "C-o")   #'helm-occur) ; helm-regexp.el
    (global-set-key (kbd "C-c o") #'helm-occur) ; helm-regexp.el

    (global-set-key (kbd "M-x") #'helm-M-x)

    ;; Bind the Helm-for-Files command to the F3 key.
    (global-set-key (kbd "<f3>") #'helm-for-files)

    ;; ;; Remap the standard 'find-file' key binding (C-x C-f) to use Helm for file
    ;; ;; navigation.
    ;; (global-set-key [remap find-file] #'helm-find-files)

    ;; Buffer list.
    (global-set-key (kbd "C-x b") #'helm-mini) ; OK.
                                        ; = `helm-buffers-list' + recents.

    (global-set-key [remap list-buffers] #'helm-buffers-list) ; OK. C-x C-b

    ;; `dabbrev-expand' (M-/) =>`helm-dabbrev'
    ;; (define-key global-map [remap dabbrev-expand] 'helm-dabbrev)

    (defun lvn-generic-imenu (arg)
      "Jump to a place in the buffer using an Index menu.

For programming mode buffers, this function displays a menu to
navigate through functions, variables, and other relevant items
in the current buffer."
      (interactive "P")
      (cond ((derived-mode-p 'org-mode)
             (if (fboundp 'helm-org-in-buffer-headings)
                 (helm-org-in-buffer-headings)
               (message "[helm-org-in-buffer-headings is not available]")))
            ((derived-mode-p 'tex-mode)
             (helm-imenu))
            (t
             (helm-semantic-or-imenu arg))) ; More generic than `helm-imenu'.
      )

    (global-set-key (kbd "<C-f12>") #'lvn-generic-imenu) ; Awesome.
    ;; (global-set-key (kbd "<f4>") #'lvn-generic-imenu)
                                        ; And `C-c =' (like in RefTeX)?

    (when (fboundp 'helm-org-agenda-files-headings)
      (global-set-key (kbd "C-c o") #'helm-org-agenda-files-headings))

    (global-set-key (kbd "C-h a") #'helm-apropos) ; OK!

    (global-set-key (kbd "C-h i") #'helm-info-emacs) ; OK.

    (global-set-key (kbd "C-h b") #'helm-descbinds) ; OK.

  )                                     ; require 'helm-autoloads ends here.

  (with-eval-after-load 'helm

    ;;! Rebind TAB to do persistent action
    (define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
    (define-key helm-map (kbd "C-i")   #'helm-execute-persistent-action)
                                        ; Make TAB works in terminal.

    ;; List available actions using C-z.
    ;; (define-key helm-map (kbd "C-z")       #'helm-select-action)
    (define-key helm-map (kbd "<backtab>") #'helm-select-action)

    ;; @ reserved for searching inside buffers! (See C-h m)

    ;; Various functions for Helm (Shell history, etc.).
    (require 'helm-misc)
    ;; For multi-line items in e.g. minibuffer history, match entire items,
    ;; not individual lines within items.

    ;; (try-require 'helm-dictionary)

    ;; Use the *current window* (no popup) to show the candidates.
    (setq helm-full-frame nil)

    ;; Open `helm-buffer' in another window.
    (setq helm-split-window-default-side 'other)

    ;; Default function used for splitting window.
    (setq helm-split-window-preferred-function
          (lambda (window)
            (split-window-sensibly)))

    ;; ;; Move to end or beginning of source when reaching top or bottom of
    ;; ;; source.
    ;; (setq helm-move-to-line-cycle-in-source t)

    ;; Separator showing up between candidate groups or entries in commands like
    ;; `helm-show-kill-ring', or anything displaying multi-line candidates.
    (setq helm-candidate-separator "────────")

    ;; Suppress displaying sources which are out of screen at first.
    (setq helm-quick-update t)

    ;; Time that the user has to be idle for, before ALL candidates are
    ;; collected.
    (setq helm-input-idle-delay 0.75)    ; 0.06 OK // 0.70 NOK

    ;; ;; Enable adaptive sorting in all sources.
    ;; (helm-adaptive-mode 1)

    ;; ;; Enable generic Helm completion (for all functions in Emacs that use
    ;; ;; `completing-read' or `read-file-name' and friends).
    ;; (helm-mode 1)
    )

  ;; Disable fuzzy matching.
  (setq helm-ff-fuzzy-matching nil)

  (with-eval-after-load 'helm-files


    ;; Don't show only basename of candidates in `helm-find-files'.
    (setq helm-ff-transformer-show-only-basename nil)

    ;; Search for library in `require' and `declare-function' sexp.
    (setq helm-ff-search-library-in-sexp t)

    ;; ;; Use `recentf-list' instead of `file-name-history' in `helm-find-files'.
    ;; (setq helm-ff-file-name-history-use-recentf t)
    )

  ;; This set Helm to open files using designated programs.
  (setq helm-external-programs-associations
        '(("rmvb" . "smplayer")
          ("mp4"  . "smplayer")))

  ;; A convenient `describe-bindings' with `helm'.
  (with-eval-after-load 'helm-descbinds

    ;; Window splitting style.
    (setq helm-descbinds-window-style 'split-window))

  ;;
  (with-eval-after-load 'helm-grep-autoloads

      (global-set-key (kbd "M-g ,") #'helm-do-grep)

      (global-set-key (kbd "M-g a") #'helm-do-grep-ag) ; Thierry Volpiatto
                                        ; Or `C-c p s s' (Helm-projectile ag?)
      )

  ;;
  (with-eval-after-load 'helm-grep
      (setq helm-grep-ag-command "rg --color=always --colors 'match:fg:black' --colors 'match:bg:yellow' --smart-case --no-heading --line-number %s %s %s")
      (setq helm-grep-ag-pipe-cmd-switches '("--colors 'match:fg:black'" "--colors 'match:bg:yellow'")) ; #CDCD00
      )

  ;; the_silver_searcher.
  (when (executable-find "ag")

    ;; The silver searcher with Helm interface.
    (with-eval-after-load 'helm-ag-autoloads

      (global-set-key (kbd "C-c s") #'helm-ag)
      (global-set-key (kbd "M-s s") #'helm-ag)

      ;; Find in Project with Ag (from project root).
      (global-set-key (kbd "C-S-f")   #'helm-do-ag-project-root) ;; Find in project. DOES NOT WORK WELL.
      (global-set-key (kbd "C-M-S-f") #'helm-do-ag-project-root) ;; Find in project. DOES NOT WORK WELL.

      ;; ;; Search with Ag.  Ask for directory first.
      ;; (global-set-key (kbd "C-S-d") #'helm-do-ag)

      ;; Search with Ag this file (like Swoop).
      (global-set-key (kbd "M-g >") #'helm-ag-this-file)

      ;; Search with Ag in current projectile project.
      (global-set-key (kbd "C-S-a") #'helm-projectile-ag)

      (global-set-key (kbd "M-g ,") #'helm-ag-pop-stack)
      ))

  (with-eval-after-load 'helm-ag

    ;; Base command of `ag'.
    (setq helm-ag-base-command (concat helm-ag-base-command " --ignore-case"))

    ;; Command line option of `ag'
    (setq helm-ag-command-option "--all-text")

    ;; Insert thing at point as search pattern.
    (setq helm-ag-insert-at-point 'symbol))

  (with-eval-after-load 'helm-command

    ;; Save command even when it fails (on errors).
    (setq helm-M-x-always-save-history t))

  ;; (with-eval-after-load 'helm-autoloads
  ;;   (global-set-key [remap locate] #'helm-locate))

  ;; XXX Problems since Cygwin update (beginning of 2020-02).
  ;; (with-eval-after-load 'helm-locate
  ;;
  ;;   (when (and (or lvn--win32-p
  ;;                  lvn--wsl-p
  ;;                  lvn--cygwin-p)
  ;;              (executable-find "es"))
  ;;
  ;;     ;; Sort locate results by full path.
  ;;     (setq helm-locate-command "es -s %s %s")))

  (with-eval-after-load 'helm-buffers

    ;; Don't truncate buffer names.
    (setq helm-buffer-max-length nil)

    ;; Never show details in buffer list.
    (setq helm-buffer-details-flag nil)

    ;; String to display at end of truncated buffer names.
    (setq helm-buffers-end-truncated-string "…"))

  ;; (with-eval-after-load 'helm-adaptive
  ;;
  ;;   ;; Don't save history information to file.
  ;;   (remove-hook 'kill-emacs-hook 'helm-adaptive-save-history))

  ;; Paste from History.
  (global-set-key (kbd "M-y") #'helm-show-kill-ring) ; OK.

  ;; ;; (global-set-key (kbd "C-h SPC") #'helm-all-mark-rings)
  ;; (global-set-key (kbd "C-c m") #'helm-all-mark-rings)

  ;; kill-ring, mark-ring, and register browsers for Helm.
  (with-eval-after-load 'helm-ring

    ;; Max number of lines displayed per candidate in kill-ring browser.
    (setq helm-kill-ring-max-lines-number 20))

  ;; (with-eval-after-load 'helm-utils
  ;;   (setq helm-yank-symbol-first t)

  ;; List Git files.
  (with-eval-after-load 'helm-ls-git-autoloads

    ;; Browse files and see status of project with its VCS.
    (global-set-key (kbd "C-x g") #'helm-browse-project) ; uses `helm-ls-git'.
    (global-set-key (kbd "<S-f3>") #'helm-browse-project))

  ;; Emacs Helm Interface for quick Google searches
  (with-eval-after-load 'helm-google-autoloads
    (global-set-key (kbd "C-c h g") #'helm-google)
    (global-set-key (kbd "C-c h s") #'helm-google-suggest))

  ;; (with-eval-after-load 'helm-google
  ;;
  ;;   ;; (when (executable-find "curl")
  ;;   ;;   (setq helm-google-suggest-use-curl-p t))
  ;;   )

  ;; Disable fuzzy matching for Helm Projectile commands.
  (setq helm-projectile-fuzzy-match nil)

  ;; (global-set-key (kbd "C-;") #'helm-projectile)

  ;; Lisp complete.
  (define-key lisp-interaction-mode-map
    [remap completion-at-point] #'helm-lisp-completion-at-point)
  (define-key emacs-lisp-mode-map
    [remap completion-at-point] #'helm-lisp-completion-at-point)

  ;; Efficiently hopping squeezed lines powered by Helm interface
  ;; (= Helm occur + Follow mode!).
  (with-eval-after-load 'helm-swoop-autoloads

    ;; Better version of `(helm-)occur'.
    (global-set-key (kbd "C-o")   #'helm-swoop)
    (global-set-key (kbd "M-s o") #'helm-swoop)
    ;; (global-set-key (kbd "M-i") #'helm-swoop)
    ;; (global-set-key (kbd "M-I") #'helm-swoop-back-to-last-point)

    (global-set-key (kbd "M-s O") #'helm-multi-swoop)
    (global-set-key (kbd "M-s /") #'helm-multi-swoop)
    ;; (global-set-key (kbd "C-c M-i") #'helm-multi-swoop)

    ;; (global-set-key (kbd "C-x M-i") #'helm-multi-swoop-all)

    ;; When doing Isearch, hand the word over to `helm-swoop'.
    (define-key isearch-mode-map (kbd "C-o") #'helm-swoop-from-isearch)
    ;; (define-key isearch-mode-map (kbd "M-i") #'helm-swoop-from-isearch)

    (with-eval-after-load 'dired
      (define-key dired-mode-map (kbd "C-o") #'helm-swoop)
      ;; (define-key dired-mode-map (kbd "M-i") #'helm-swoop)
      ))

  (with-eval-after-load 'helm-swoop

    ;; Move up and down like Isearch.
    (define-key helm-swoop-map (kbd "C-r") #'helm-previous-line)
    (define-key helm-swoop-map (kbd "C-s") #'helm-next-line)
    (define-key helm-multi-swoop-map (kbd "C-r") #'helm-previous-line)
    (define-key helm-multi-swoop-map (kbd "C-s") #'helm-next-line)

    ;; From `helm-swoop' to `helm-multi-swoop-all'.
    (define-key helm-swoop-map (kbd "C-o") #'helm-multi-swoop-all-from-helm-swoop)
    ;; (define-key helm-swoop-map (kbd "M-i") #'helm-multi-swoop-all-from-helm-swoop)

    ;; Don't slightly boost invoke speed in exchange for text color.
    (setq helm-swoop-speed-or-color t)

    ;; Split direction.
    ;; (setq helm-swoop-split-direction 'split-window-right)
    (setq helm-swoop-split-direction 'split-window-sensibly)

    ;; Don't save each buffer you edit when editing is complete.
    (setq helm-multi-swoop-edit-save nil))

  (leuven--section "Image mode")

  ;; Show image files as images (not as semi-random bits).
  (add-hook 'find-file-hook #'auto-image-file-mode)

)                                       ; Chapter 18 ends here.

;;* 19 Using Multiple (info "(emacs)Buffers")

(leuven--chapter leuven-load-chapter-19-buffers "19 Using Multiple Buffers"

;;** 19.2 (info "(emacs)List Buffers")

  (leuven--section "19.2 (emacs)List Buffers")

;;** 19.4 (info "(emacs)Kill Buffer")

  (leuven--section "19.4 (emacs)Kill Buffer")

  ;; Kill the current buffer without confirmation (if not modified).
  (defun lvn-kill-current-buffer-no-confirm ()
    "Kill the current buffer without confirmation (if not modified)."
    (interactive)
    (kill-buffer nil))

  ;; Key binding.
  (global-set-key (kbd "<S-f12>") #'lvn-kill-current-buffer-no-confirm)

;;** 19.5 (info "(emacs)Several Buffers")

  (leuven--section "19.5 (emacs)Several Buffers")

  ;; Put the current buffer at the end of the list of all buffers.
  (global-set-key (kbd "<M-f12>") #'bury-buffer)

;;** 19.7 (info "(emacs)Buffer Convenience") and Customization of Buffer Handling

  (leuven--section "19.7 (emacs)Buffer Convenience and Customization of Buffer Handling")

  ;; Unique buffer names dependent on file name.
  (try-require 'uniquify)

  (with-eval-after-load 'uniquify

    ;; Distinguish directories by adding extra separator.
    (setq uniquify-trailing-separator-p t))

)                                       ; Chapter 19 ends here.

;;* 20 Multiple (info "(emacs)Windows")

(leuven--chapter leuven-load-chapter-20-windows "20 Multiple Windows"

;;** 20.1 (info "(emacs)Basic Window")

  (leuven--section "20.1 (emacs)Basic Window")

;;** 20.3 (info "(emacs)Other Window")

  (leuven--section "20.3 (emacs)Other Window")

  (global-set-key (kbd "<f6>") #'other-window)

  (defun lvn-switch-or-rotate-buffer ()
    "Switch to the previous buffer or rotate window configuration.

If there is only one window in the frame, this function switches
to the previous buffer, cycling through the buffer list in the
current window.

If there are multiple windows in the frame, this function rotates
the window configuration, moving to the previous window in the
cyclic order."
    (interactive)
    (if (one-window-p t)
        ;; Switch to the previous buffer.
        (switch-to-buffer (other-buffer (current-buffer) 1))
      ;; Move to the previous window in a multi-window configuration.
      (other-window -1)))

  (global-set-key (kbd "<f6>") #'lvn-switch-or-rotate-buffer)

;;** 20.5 (info "(emacs)Change Window")

  (leuven--section "20.5 (emacs)Change Window")

  (defun lvn-toggle-or-delete-window-layout ()
    "Toggle or delete the window layout.

If there is only one window in the frame, this function will split the window
either horizontally or vertically, depending on the frame's width, as defined by
`split-width-threshold' variable. If the frame width is greater than
`split-width-threshold', it will split the window horizontally, otherwise
vertically.

If there are multiple windows in the frame, this function will delete all other
windows, leaving only the currently active window visible."
    (interactive)
    (cond ((one-window-p t)
           (select-window
            (if (> (frame-width) split-width-threshold)
                (split-window-right)
              (split-window-below))))
          (t
           (delete-other-windows))))

  (global-set-key (kbd "<f5>") #'lvn-toggle-or-delete-window-layout)

  ;; Swap 2 windows.
  (defun leuven-swap-windows ()
    "If you have 2 windows, swap them."
    (interactive)
    (cond ((not (= (count-windows) 2))
           (message "[You need exactly 2 windows to swap them]"))
          (t
           (let* ((wind-1 (first (window-list)))
                  (wind-2 (second (window-list)))
                  (buf-1 (window-buffer wind-1))
                  (buf-2 (window-buffer wind-2))
                  (start-1 (window-start wind-1))
                  (start-2 (window-start wind-2)))
             (set-window-buffer wind-1 buf-2)
             (set-window-buffer wind-2 buf-1)
             (set-window-start wind-1 start-2)
             (set-window-start wind-2 start-1)))))

  (global-set-key (kbd "C-c ~") #'leuven-swap-windows)

  (defun leuven-toggle-window-split ()
    "Toggle between vertical and horizontal split.
  Vertical split shows more of each line, horizontal split shows more lines.
  This code only works for frames with exactly two windows."
    (interactive)
    (cond ((not (= (count-windows) 2))
           (message "[You need exactly 2 windows to toggle the window split]"))
          (t
           (let* ((this-win-buffer (window-buffer))
                  (next-win-buffer (window-buffer (next-window)))
                  (this-win-edges (window-edges (selected-window)))
                  (next-win-edges (window-edges (next-window)))
                  (this-win-2nd (not (and (<= (car this-win-edges)
                                              (car next-win-edges))
                                          (<= (cadr this-win-edges)
                                              (cadr next-win-edges)))))
                  (splitter
                   (if (= (car this-win-edges)
                          (car (window-edges (next-window))))
                       'split-window-right
                     'split-window-below)))
             (delete-other-windows)
             (let ((first-win (selected-window)))
               (funcall splitter)
               (if this-win-2nd (other-window 1))
               (set-window-buffer (selected-window) this-win-buffer)
               (set-window-buffer (next-window) next-win-buffer)
               (select-window first-win)
               (if this-win-2nd (other-window 1)))))))

  (global-set-key (kbd "C-c |") #'leuven-toggle-window-split)

  (defun toggle-current-window-dedication ()
    "Toggle whether the current active window is dedicated or not."
    (interactive)
    (let* ((window (selected-window))
           (dedicated (window-dedicated-p window)))
      (set-window-dedicated-p window (not dedicated))
      (message "[Window %sdedicated to %s]"
               (if dedicated "no longer " "")
               (buffer-name))))

  ;; Press [pause] key in each window you want to "freeze".
  (global-set-key (kbd "<pause>") #'toggle-current-window-dedication)

;;** 20.6 (info "(emacs)Displaying Buffers")

  (leuven--section "20.6 (emacs)Pop Up Window")

  ;; Don't allow splitting windows vertically.
  (setq split-height-threshold nil)

  ;; ;; Minimum width for splitting windows horizontally.
  ;; (setq split-width-threshold (* 2 80))      ; See `split-window-sensibly'.

)                                       ; Chapter 20 ends here.

;;* 21 (info "(emacs)Frames") and Graphical Displays

(leuven--chapter leuven-load-chapter-21-frames "21 Frames and Graphical Displays"

;;** 21.1 (info "(emacs)Mouse Commands")

  (leuven--section "21.1 (emacs)Mouse Commands")

  ;; Scroll one line at a time.
  (setq mouse-wheel-scroll-amount
        '(1
          ((shift) . 1)))

  ;; Paste at text-cursor, not at mouse-cursor.
  (setq mouse-yank-at-point t)

;;** 21.6 (info "(emacs)Creating Frames")

  (leuven--section "21.6 (emacs)Creating Frames")

  (when (display-graphic-p)
    ;; Put Emacs at the top-left corner of the screen.
    (setq initial-frame-alist '((top . 0) (left . 0)))

    ;; Auto-detect the screen dimensions and compute the height of Emacs.
    (let* ((screen-geometry (car (display-monitor-attributes-list)))
           (screen-height (- (nth 4 (assq 'geometry screen-geometry)) 177)) ; Account for Emacs' title bar and taskbar.
           (frame-char-height (frame-char-height)))
      (add-to-list 'default-frame-alist (cons 'height (/ screen-height frame-char-height)))))

  ;; Title bar display of visible frames.
  (setq frame-title-format
        (format "%s Emacs%s %s%s of %s - PID: %d"
                (replace-regexp-in-string "-.*$" "" (capitalize (symbol-name system-type)))
                (if (string-match-p "^x86_64-.*" system-configuration)
                    "-w64"
                  "-w32")
                emacs-version
                (if (and (bound-and-true-p emacs-repository-version)
                         emacs-repository-version)
                    (concat " (" (substring (replace-regexp-in-string " .*" "" emacs-repository-version) 0 7) ")")
                  "")
                (format-time-string "%Y-%m-%d" emacs-build-time)
                (emacs-pid)))

  (defun leuven-detach-window ()
    "Close current window and re-open it in new frame."
    (interactive)
    (let ((current-buffer (window-buffer)))
      (delete-window)
      (select-frame (make-frame))
      (set-window-buffer (selected-window) current-buffer)))

;;** 21.7 (info "(emacs)Frame Commands")

  (leuven--section "21.7 (emacs)Frame Commands")

  ;; ;; Maximize Emacs frame by default.
  ;; (modify-all-frames-parameters '((fullscreen . maximized)))

  ;; Full screen.
  (global-set-key (kbd "<C-S-f12>") #'toggle-frame-fullscreen)

;;** 21.9 (info "(emacs)Speedbar")

  (leuven--section "21.9 (emacs)Speedbar Frames")

  (unless (locate-library "helm-autoloads")  ; Helm is better than speedbar!

    ;; Jump to speedbar frame.
    (global-set-key (kbd "<f4>") #'speedbar-get-focus))

  ;; Everything browser (into individual source files), or Dired on steroids.
  (with-eval-after-load 'speedbar

    ;; Number of spaces used for indentation.
    (setq speedbar-indentation-width 2)

    ;; Add new extensions for speedbar tagging (allow to expand/collapse
    ;; sections, etc.) -- do this BEFORE firing up speedbar?
    (speedbar-add-supported-extension
     '(".bib" ".css" ".jpg" ".js" ".nw" ".org" ".php" ".png" ".R" ".tex" ".txt"
       ".w" "README"))

    ;; Bind the arrow keys in the speedbar tree.
    (define-key speedbar-mode-map (kbd "<right>") #'speedbar-expand-line)
    (define-key speedbar-mode-map (kbd "<left>")  #'speedbar-contract-line)

    ;; Parameters to use when creating the speedbar frame in Emacs.
    (setq speedbar-frame-parameters '((width . 30)
                                      (height . 45)
                                      (foreground-color . "blue")
                                      (background-color . "white")))

    ;; Speedbar in the current frame (vs in a new frame).
    (when (and (not (locate-library "helm-autoloads"))
                                        ; Helm is better than speedbar!
               (locate-library "sr-speedbar"))

      (autoload 'sr-speedbar-toggle "sr-speedbar" nil t)
      (global-set-key (kbd "<f4>") #'sr-speedbar-toggle)))

;;** 21.12 (info "(emacs)Scroll Bars")

  (leuven--section "21.12 (emacs)Scroll Bars")

  (if (and (display-graphic-p)
           ;; (featurep 'powerline)
           )

      ;; Turn scroll bar off.
      (scroll-bar-mode -1)

    ;; Position of the vertical scroll bar.
    (setq-default vertical-scroll-bar 'right))

;;** 21.16 Using (info "(emacs)Dialog Boxes")

  (leuven--section "21.16 (emacs)Using Dialog Boxes")

  ;; Don't use dialog boxes to ask questions.
  (setq use-dialog-box nil)

  ;; Don't use a file dialog to ask for files.
  (setq use-file-dialog nil)

;;** 21.17 (info "(emacs)Tooltips")

  (leuven--section "21.17 (emacs)Tooltips")

  ;; Disable Tooltip mode (use the echo area for help and GUD tooltips).
  (unless leuven--console-p (tooltip-mode -1))

)                                       ; Chapter 21 ends here.

;;* 22 (info "(emacs)International") Character Set Support

(leuven--chapter leuven-load-chapter-22-international "22 International Character Set Support"

;;** 22.1 (info "(emacs)International Chars")

  (leuven--section "22.1 (emacs)International Chars")

  ;; Keyboard input definitions for ISO 8859-1.
  (with-eval-after-load 'iso-transl

    ;; Add binding for "zero width space".
    (define-key iso-transl-ctl-x-8-map (kbd "0") [?​]))

;;** 22.2 (info "(emacs)Language Environments")

  (leuven--section "22.2 (emacs)Language Environments")

  ;; Specify your character-set locale.
  (setenv "LANG" "en_US.utf8")          ; For `svn' not to report warnings.

  ;; System locale to use for formatting time values.
  (setq system-time-locale "C")         ; Make sure that the weekdays in the
                                        ; time stamps of your Org mode files and
                                        ; in the agenda appear in English.

  ;; (setq system-time-locale (getenv "LANG"))
                                        ; For weekdays in your locale settings.

;;** 22.3 (info "(emacs)Input Methods")

  (leuven--section "22.3 (emacs)Input Methods")

  ;; Get 8-bit characters in terminal mode (Cygwin Emacs).
  (set-input-mode (car (current-input-mode))
                  (nth 1 (current-input-mode))
                  0)

  ;; Disable any input method to use pure English input.
  (setq default-input-method nil)         ; STOP ENCOUNTERING LAGGY ISSUES ON WSL2.

  (defun leuven-list-unicode-display (&optional regexp)
    "Display a list of unicode characters and their names in a buffer."
    (interactive "sRegexp (default \".*\"): ")
    (let* ((regexp (or regexp ".*"))
           (case-fold-search t)
           (cmp (lambda (x y) (< (cdr x) (cdr y))))
           ;; alist like ("name" . code-point).
           (char-alist (sort (cl-remove-if-not (lambda (x) (string-match regexp (car x)))
                                               (ucs-names))
                             cmp)))
      (with-help-window "*Unicode characters*"
        (with-current-buffer standard-output
          (dolist (c char-alist)
            (insert (format "0x%06X\t" (cdr c)))
            (insert (cdr c))
            (insert (format "\t%s\n" (car c))))))))

;;** 22.6 (info "(emacs)Recognize Coding") Systems

  (leuven--section "22.6 (emacs)Recognize Coding Systems")

  ;; Default coding system (for new files), also moved to the front of the
  ;; priority list for automatic detection.
  (prefer-coding-system 'utf-8-unix)    ; Unix flavor for code blocks executed
                                        ; via Org-Babel.

(defun lvn-replace-non-utf8-chars ()
  "Replace non-UTF-8 characters with their corresponding UTF-8 equivalents."
  (interactive)
  ;; Replace non-UTF-8 characters using predefined substitutions.
  (lvn--apply-accent-substitutions lvn--non-utf8-to-utf8-mapping))

(defconst lvn--non-utf8-to-utf8-mapping
  '(("\200" . "EUR")  ;; \342\202\254
    ("\205" . "...")
    ("\221" . "`")
    ("\222" . "'")    ;; \342\200\231
    ("\223" . "\"")
    ("\224" . "\"")
    ("\226" . "-")
    ("\227" . "--")
    ("\234" . "oe")
    ("\240" . " ")    ;; \302\240
    ("\246" . "|")
    ("\251" . "©")
    ("\253" . "«")
    ("\256" . "®")
    ("\260" . "°")
    ("\265" . "u")
    ("\272" . "°")
    ("\273" . "»")
    ("\274" . "1/4")
    ("\275" . "1/2")
    ("\276" . "3/4")
    ("\277" . "¿")
    ("\300" . "À")
    ;; ("\301" . "") ;; caps spanish a ("facil")
    ("\302" . "Â")
    ("\304" . "Ä")
    ("\307" . "Ç")
    ("\310" . "È")
    ("\311" . "É")
    ("\312" . "Ê")
    ("\316" . "Î")
    ("\317" . "Ï")
    ("\324" . "Ô")
    ("\326" . "Ö")
    ("\331" . "Ù")
    ("\337" . "ss")
    ("\333" . "Û")
    ("\334" . "Ü")
    ("\340" . "à")    ;; \303\240
    ("\341" . "á")    ;; \303\241
    ("\342" . "â")    ;; \303\242
    ("\344" . "ä")
    ("\347" . "ç")
    ("\350" . "è")    ;; \303\250
    ("\351" . "é")    ;; \303\251
    ("\352" . "ê")
    ("\353" . "ë")
    ("\355" . "í")
    ("\356" . "î")
    ("\357" . "ï")
    ("\361" . "ñ")
    ("\363" . "ó")    ;; \303\263
    ("\364" . "ô")    ;; \303\264
    ("\365" . "õ")
    ("\366" . "ö")
    ("\371" . "ù")
    ("\372" . "ú")
    ("\373" . "û")    ;; \303\273
    ("\374" . "ü"))   ;; \303\274
  "Mapping of non-UTF-8 characters to their UTF-8 equivalents.")

;; https://lists.gnu.org/archive/html/gnu-emacs-sources/2005-12/msg00005.html
(defun lvn--apply-accent-substitutions (subst-list)
  "Apply substitutions based on a given list of replacements.
SUBST-LIST is an alist where each element has the form (REGEXP . REPLACEMENT)."
  (dolist (pair subst-list)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward (car pair) nil t)
        (replace-match (cdr pair) t t)))))

;;** 22.7 (info "(emacs)Specify Coding") System of a File

  (leuven--section "22.7 (emacs)Specify Coding System of a File")

  ;; To copy and paste to and from Emacs through the clipboard (with coding
  ;; system conversion).
  (cond (lvn--win32-p
         (set-selection-coding-system 'compound-text-with-extensions))
        (t
         (set-selection-coding-system 'utf-8)))

)                                       ; Chapter 22 ends here.

;;* 23 (info "(emacs)Modes")

(leuven--chapter leuven-load-chapter-23-major-and-minor-modes "23 Major and Minor Modes"

;;** 23.3 (info "(emacs)Choosing Modes")

  (leuven--section "23.3 (emacs)Choosing File Modes")

  ;; Define a list of filename patterns and their associated major modes.
  (setq auto-mode-alist
        (append '(("\\.log\\'"       . text-mode)
                  ;; ("\\.[tT]e[xX]\\'" . latex-mode)
                  ;; ("\\.cls\\'"       . LaTeX-mode)
                  ("\\.cgi\\'"       . perl-mode)
                  ;; ("[mM]akefile"     . makefile-mode)
                  (".ssh/config\\'"  . ssh-config-mode)
                  ("sshd?_config\\'" . ssh-config-mode)
                  ) auto-mode-alist))

  ;; Major mode for fontifiying ssh config files.
  (autoload 'ssh-config-mode "ssh-config-mode"
    "Major mode for fontifiying ssh config files." t)

  ;; Major mode for editing comma-separated value files.
  (with-eval-after-load 'csv-mode-autoloads

    (add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode)))

  (with-eval-after-load 'csv-mode

    ;; Field separators: a list of *single-character* strings.
    (setq csv-separators '("," ";")))

  ;; List of interpreters specified in the first line (starts with `#!').
  (push '("expect" . tcl-mode) interpreter-mode-alist)

  ;; ;; Load generic modes which support e.g. batch files.
  ;; (try-require 'generic-x)

)                                       ; Chapter 23 ends here.

;;* 24 (info "(emacs)Indentation")

(leuven--chapter leuven-load-chapter-24-indentation "24 Indentation"

;;** 24.1 (info "(emacs)Indentation Commands") and Techniques

  (leuven--section "24.1 (emacs)Indentation Commands and Techniques")

  (defun leuven-indent-buffer ()
    "Indent each non-blank line in the buffer."
    (interactive)
    (save-excursion
      (indent-region (point-min) (point-max) nil)))

  (defun leuven-align-code (begin end)
    "Align region to equal signs and colons."
    (interactive "r")
    ;; Keep them separate align calls, otherwise colons align with spaces if
    ;; they're in the same region.
    (align-regexp begin end "\\(\\s-*\\)=" 1 1)
    (align-regexp begin end "\\(\\s-*\\):" 1 1))

  ;; Align your code in a pretty way.
  (global-set-key (kbd "C-x \\") #'leuven-align-code)
  (global-set-key (kbd "C-c =")  #'leuven-align-code)

  ;; Show vertical lines to guide indentation.
  (with-eval-after-load 'indent-guide-autoloads-XXX ; Display problems with CrossMapIntegration.java

    ;; Enable indent-guide-mode automatically.
    (add-hook 'prog-mode-hook #'indent-guide-mode))

  (with-eval-after-load 'indent-guide

    ;; Character used as vertical line.
    (setq indent-guide-char
          (cond ((char-displayable-p ?\u254E) "╎")
                ((char-displayable-p ?\u2502) "│")
                (t ":")))

    (diminish 'indent-guide-mode))

;;** 24.3 TABs vs. (info "(emacs)Just Spaces")

  (leuven--section "24.3 TABs vs. (emacs)Just Spaces")

  ;; Set the default for indentation to use spaces instead of tabs.
  (setq-default indent-tabs-mode nil)

  ;; (setq tab-always-indent 'complete)

)                                       ; Chapter 24 ends here.

;;* 25 Commands for (info "(emacs)Text") Human Languages

(leuven--chapter leuven-load-chapter-25-text "25 Commands for Human Languages"

;;** 25.1 (info "(emacs)Words")

  (leuven--section "25.1 (emacs)Words")

;;** 25.2 (info "(emacs)Sentences")

  (leuven--section "25.2 (emacs)Sentences")

  ;; ;; A single space does end a sentence.
  ;; (setq-default sentence-end-double-space nil) ; see `ispell-dictionary'

  ;; Use M-ù for backward-paragraph.
  (global-set-key (kbd "M-ù") 'backward-paragraph)

  ;; Use M-* for forward-paragraph.
  (global-set-key (kbd "M-*") 'forward-paragraph)

  (defun leuven-nbsp-command ()
    "Insert the no-break space character 00A0."
    (interactive)
    (insert-char ?\u00A0))

  (global-set-key (kbd "S-SPC") #'leuven-nbsp-command)

;;** 25.5 (info "(emacs)Filling") Text

  (leuven--section "25.5 (emacs)Filling Text")

  ;; Line-wrapping beyond that column (when pressing `M-q').
  (setq-default fill-column 80)

  ;; Toggle paragraph filling/unfilling with optional custom width.
  (defun lvn-toggle-paragraph-fill (arg)
    "Fill or unfill paragraph/region with customizable column width.
  With numeric ARG (e.g., C-u 80), set fill column width explicitly.
  When called twice consecutively without prefix, unfills the paragraph.
  In Org mode, uses `org-fill-paragraph` for specialized formatting."
    (interactive "P")
    (let ((fill-column (cond
                        (arg
                         (prefix-numeric-value arg))
                        ((eq last-command 'lvn-toggle-paragraph-fill)
                         (setq this-command nil)
                         (point-max))
                        (t
                         fill-column))))
      (if (derived-mode-p 'org-mode)
          (org-fill-paragraph)
        (fill-paragraph))))

  ;; M-q.
  (global-set-key [remap fill-paragraph] #'lvn-toggle-paragraph-fill)
  (with-eval-after-load 'org
    (define-key org-mode-map (kbd "M-q") #'lvn-toggle-paragraph-fill))

  ;; Prevent breaking lines just before a punctuation mark such as `?' or `:'.
  (add-hook 'fill-nobreak-predicate #'fill-french-nobreak-p)

  ;; Activate Auto Fill for all text mode buffers.
  (add-hook 'text-mode-hook #'auto-fill-mode)

  (defun leuven-replace-nbsp-by-spc ()
    "Replace all nbsp by normal spaces."
    (interactive "*")
    (save-excursion
      (save-restriction
        (save-match-data
          (progn
            (goto-char (point-min))
            (while (re-search-forward "[  ]" nil t)
              (replace-match " " nil nil)))))))

  (defun leuven-good-old-fill-paragraph ()
    (interactive)
    (let ((fill-paragraph-function nil)
          (adaptive-fill-function nil))
      (fill-paragraph)))

  ;; (defun leuven-smart-punctuation-apostrophe ()
  ;;   "Replace second apostrophe by backquote in front of symbol."
  ;;   (interactive)
  ;;   (cond
  ;;    ((or (bolp) (not (looking-back "'")))
  ;;     ;; Insert just one '.
  ;;     (self-insert-command 1))
  ;;    ((save-excursion
  ;;       (backward-char)
  ;;       ;; Skip symbol backwards.
  ;;       (and (not (zerop (skip-syntax-backward "w_.")))
  ;;            (not (looking-back "`"))
  ;;            (or (insert-and-inherit "`") t))))
  ;;    (t
  ;;     ;; Insert `' around following symbol.
  ;;     (delete-char -1)
  ;;     (unless (looking-back "`") (insert-and-inherit "`"))
  ;;     (save-excursion
  ;;       (skip-syntax-forward "w_.")
  ;;       (unless (looking-at "'") (insert-and-inherit "'"))))))

  (defun leuven-smart-punctuation-quotation-mark ()
    "Replace two following double quotes by French quotes."
    (interactive)
    (let ((dict (or (when (boundp 'ispell-local-dictionary)
                      ispell-local-dictionary)
                    (when (boundp 'ispell-dictionary)
                      ispell-dictionary))))
      (message "[>>> %s]" major-mode)
      (cond
       ((and (string= dict "francais")
             (eq (char-before) ?\")
             (or (not (equal mode-name "Org"))
                 (not (member (org-element-type (org-element-at-point))
                              '(src-block keyword table dynamic-block)))))
        (backward-delete-char 1)
        (insert "«  »")
        (backward-char 2))
       ((and (eq (char-before) ?\")
             (derived-mode-p 'latex-mode))
        (backward-delete-char 1)
        (insert "\\enquote{}")
        (backward-char 1))
       (t
        (insert "\"")))))

  (defun leuven--smart-punctuation ()
    "Replace second apostrophe or quotation mark."
    ;; (local-set-key [39] #'leuven-smart-punctuation-apostrophe)
    (local-set-key "\"" #'leuven-smart-punctuation-quotation-mark))

  (add-hook 'text-mode-hook #'leuven--smart-punctuation)
  (add-hook 'message-mode-hook #'leuven--smart-punctuation)

  (with-eval-after-load 'key-chord-autoloads
    (key-chord-mode 1))

  ;; Map pairs of simultaneously pressed keys to commands.
  (with-eval-after-load 'key-chord

    (with-eval-after-load 'helm-command
      (key-chord-define-global "xx" #'helm-M-x)) ; NEW-10

    (key-chord-define-global "hf" #'describe-function) ; NEW-11.3
    (key-chord-define-global "hv" #'describe-variable) ; NEW-11.3
    ;; (key-chord-define-global "hb" #'describe-bindings) ; NEW-11.8

    (key-chord-define-global "xh" #'mark-whole-buffer) ; NEW-12.2

    (with-eval-after-load 'expand-region-autoloads
      (key-chord-define-global "hh" #'er/expand-region) ; NEW-12.2
      (key-chord-define-global "HH" #'er/contract-region))

    (key-chord-define-global "kk" #'kill-whole-line) ; NEW-13.1.2

    (with-eval-after-load 'helm-ring
      (key-chord-define-global "yy" #'helm-show-kill-ring)) ; NEW-13.2.1

    (with-eval-after-load 'avy-autoloads
      (key-chord-define-global "jj" #'avy-goto-word-1)
      (key-chord-define-global "jl" #'avy-goto-line))

    (key-chord-define-global "hj" #'undo) ; NEW-17.1

    (with-eval-after-load 'helm-for-files
      (key-chord-define-global "FF" #'helm-for-files)) ; NEW-19.2

    (key-chord-define-global "xk" #'kill-buffer) ; NEW-20.4
    ;; (key-chord-define-global "kb" #'kill-buffer)

    ;; (key-chord-define-global "22" #'split-window-below) ; "vertically" ; NEW-21.2
    ;; (key-chord-define-global "33" #'split-window-right) ; "horizontally" ; NEW-21.2

    (key-chord-define-global "jw" #'other-window) ; NEW-21.3
    (key-chord-define-global "ww" #'other-window) ; NEW-21.3

    (key-chord-define-global "sq" "''\C-b") ; NEW-26.5
    (key-chord-define-global "dq" "\"\"\C-b")
    (key-chord-define-global "<<" (lambda () (interactive) (insert "«"))) ; NEW-26.5
    (key-chord-define-global ">>" (lambda () (interactive) (insert "»")))

    (key-chord-define-global "vb" #'eval-buffer) ; NEW-28.9

    ;; (key-chord-define-global "JJ" #'xref-find-definitions) ; NEW-29.4.1.1

    (key-chord-define-global "xj" #'dired-jump) ; NEW-31.1
    ;; (key-chord-define-global ";d" #'dired-jump-other-window)
    )

;;** 25.6 (info "(emacs)Case") Conversion Commands

  (leuven--section "25.6 (emacs)Case Conversion Commands")

  ;; Enable the use of some commands without confirmation.
  (dolist (command
           ;; Disabled commands.
           '(downcase-region
             upcase-region))
    (put command 'disabled nil))

;;** 25.8 (info "(emacs)Outline Mode")

  (leuven--section "25.8 (emacs)Outline Mode")

  ;; Outline mode commands for Emacs.
  (with-eval-after-load 'outline

    ;; Bind the outline minor mode functions to an easy to remember prefix
    ;; key (more accessible than the horrible prefix `C-c @').
    (setq outline-minor-mode-prefix (kbd "C-c C-o")) ; like in nXML mode

    ;; ;; Make other `outline-minor-mode' files (LaTeX, etc.) feel the Org
    ;; ;; mode outline navigation (written by Carsten Dominik).
    ;; (try-require 'outline-magic)
    ;; (with-eval-after-load 'outline-magic
    ;;   (add-hook 'outline-minor-mode-hook
    ;;             (lambda ()
    ;;               (define-key outline-minor-mode-map
    ;;                           (kbd "<S-tab>") #'outline-cycle)
    ;;               (define-key outline-minor-mode-map
    ;;                           (kbd "<M-left>") #'outline-promote)
    ;;               (define-key outline-minor-mode-map
    ;;                           (kbd "<M-right>") #'outline-demote)
    ;;               (define-key outline-minor-mode-map
    ;;                           (kbd "<M-up>") #'outline-move-subtree-up)
    ;;               (define-key outline-minor-mode-map
    ;;                           (kbd "<M-down>") #'outline-move-subtree-down))))

    ;; ;; Extra support for outline minor mode.
    ;; (try-require 'out-xtra)


    ;; Org-style folding for a `.emacs' (and much more).

    ;; FIXME This should be in an `eval-after-load' of Org, so that
    ;; `org-level-N' are defined when used

    (defun leuven--outline-regexp ()
      "Calculate the outline regexp for the current mode."
      (let ((comment-starter (replace-regexp-in-string
                              "[[:space:]]+" "" comment-start)))
        (when (string= comment-start ";")
          (setq comment-starter ";;"))
        ;; (concat "^" comment-starter "\\*+")))
        (concat "^" comment-starter "[*]+ ")))

    ;; Fontify the whole line for headings (with a background color).
    (setq org-fontify-whole-heading-line t)

    (defun leuven--outline-minor-mode-hook ()
      (setq outline-regexp (leuven--outline-regexp))
      (let* ((org-fontify-whole-headline-regexp "") ; "\n?")
             (heading-1-regexp
              (concat (substring outline-regexp 0 -1)
                      "\\{1\\} \\(.*" org-fontify-whole-headline-regexp "\\)"))
             (heading-2-regexp
              (concat (substring outline-regexp 0 -1)
                      "\\{2\\} \\(.*" org-fontify-whole-headline-regexp "\\)"))
             (heading-3-regexp
              (concat (substring outline-regexp 0 -1)
                      "\\{3\\} \\(.*" org-fontify-whole-headline-regexp "\\)"))
             (heading-4-regexp
              (concat (substring outline-regexp 0 -1)
                      "\\{4,\\} \\(.*" org-fontify-whole-headline-regexp "\\)")))
        (font-lock-add-keywords nil
         `((,heading-1-regexp 1 'org-level-1 t)
           (,heading-2-regexp 1 'org-level-2 t)
           (,heading-3-regexp 1 'org-level-3 t)
           (,heading-4-regexp 1 'org-level-4 t)))))

    (add-hook 'outline-minor-mode-hook #'leuven--outline-minor-mode-hook)

    ;; Add the following as the top line of your `.emacs':
    ;;
    ;; ; -*- mode: emacs-lisp; eval: (outline-minor-mode 1); -*-
    ;;
    ;; Now you can add `;;' and `;;*', etc. as headings in your `.emacs'
    ;; and cycle using `<S-tab>', `<M-left>' and `<M-right>' will collapse
    ;; or expand all headings respectively.  I am guessing you mean to make
    ;; segments such as `;; SHORTCUTS' and `;; VARIABLES', this will do
    ;; that, but not too much more.
    )

    (add-hook 'outline-minor-mode-hook
              (lambda ()
                (when (and outline-minor-mode (derived-mode-p 'emacs-lisp-mode))
                  (hide-sublevels 1000))))

  ;; (add-hook 'outline-minor-mode-hook
  ;;           (lambda ()
  ;;             (define-key outline-minor-mode-map (kbd "<C-tab>") #'org-cycle)
  ;;             (define-key outline-minor-mode-map (kbd "<S-tab>") #'org-global-cycle))) ; backtab?

  ;; Cycle globally if cursor is at beginning of buffer and not at a headline.
  (setq org-cycle-global-at-bob t)

  ;; (setq org-cycle-level-after-item/entry-creation nil)

  ;; ;; ‘org-cycle’ should never emulate TAB.
  ;; (setq org-cycle-emulate-tab nil)

  (global-set-key (kbd "<S-tab>") #'org-cycle) ; that works (but on level 1+)
  ;; (global-set-key (kbd "S-<tab>") (kbd "C-u M-x org-cycle")) ; that works (but on level 1+)

  ;; TODO Look at org-cycle-global and local below, they work better, but
  ;; still on level 1+
  ;; TODO Replace it by a function which alternatively does `hide-body' and
  ;; `show-all'

  ;; from Bastien

  ;; ;; XXX 2010-06-21 Conflicts with outline-minor-mode bindings
  ;; ;; add a hook to use `orgstruct-mode' in Emacs Lisp buffers
  ;; (add-hook 'emacs-lisp-mode-hook #'orgstruct-mode)

  (defun org-cycle-global ()
    (interactive)
    (org-cycle t))

  (global-set-key (kbd "C-M-]") #'org-cycle-global)
                                        ; XXX ok on Emacs Lisp, not on LaTeX
                                        ; S-TAB?

  ;; (defun org-cycle-local ()
  ;;   (interactive)
  ;;   (save-excursion
  ;;     (move-beginning-of-line nil)
  ;;     (org-cycle)))

  (defun org-cycle-local ()
    (interactive)
    (ignore-errors
      (end-of-defun)
      (beginning-of-defun))
    (org-cycle))

  (global-set-key (kbd "M-]") #'org-cycle-local)
                                        ; XXX ok on Emacs Lisp, not on LaTeX

;; C-M-] and M-] fold the whole buffer or the current defun.

  ;; ;; Unified user interface for Emacs folding modes, bound to Org key-strokes.
  ;; (try-require 'fold-dwim-org)

  ;; 25.8.2
  ;; Toggle display of invisible text.
  (defun leuven-toggle-show-everything (&optional arg)
    "Show all invisible text."
    (interactive (list (or current-prefix-arg 'toggle)))
    (if (derived-mode-p 'prog-mode)
        (hs-show-all)
      (visible-mode arg)))

  (global-set-key (kbd "M-A") #'leuven-toggle-show-everything) ; `M-S-a'.

;;** (info "(emacs-goodies-el)boxquote")

  (leuven--section "(emacs-goodies-el)boxquote")

  (use-package boxquote
    :bind (("C-c b" . boxquote-region))
    :config
    (setq boxquote-top-and-tail  "────")
    (setq boxquote-title-format  " %s")
    (setq boxquote-top-corner    "  ┌")
    (setq boxquote-side          "  │ ")
    (setq boxquote-bottom-corner "  └"))

;;** (info "phonetic")

  (leuven--section "phonetic")

  ;; Phonetic spelling.
  (use-package phonetic
    :if (locate-library "phonetic")
    ;; Translate the region according to the phonetic alphabet.
    :commands phonetize-region)

)                                       ; Chapter 25 ends here.

;;** 25.11 (info "(emacs)TeX Mode")

(leuven--chapter leuven-load-chapter-25.11-tex-mode "25.11 TeX Mode"

  (leuven--section "25.11 (emacs)TeX Mode")

  ;; Define a derived mode for colorized PDFLaTeX output.
  (define-derived-mode latex-output-mode fundamental-mode "LaTeX-Output"
    "Major mode for colorizing LaTeX output."
    (setq-local font-lock-defaults
                '((latex-output-font-lock-keywords))))

  ;; Font lock keywords.
  (defconst latex-output-font-lock-keywords
    '(;; LaTeX error messages.
      ("^!.*" . compilation-error-face)
      ;; Latexmk separator lines.
      ("^-+$" . compilation-info-face)
      ;; LaTeX package errors.
      ("Package .* Error:.*" . compilation-error-face)
      ;; LaTeX package warnings.
      ("^Package .* Warning:.*" . compilation-warning-face)
      ;; Undefined references.
      ("Reference .* undefined" . compilation-warning-face)
      ;; Overfull/Underfull boxes.
      ("^\\(?:Overfull\\|Underfull\\|Tight\\|Loose\\).*" . font-lock-string-face)
      ;; Font warnings.
      ("^LaTeX Font Warning:" . font-lock-string-face)
      ;; Output written lines (successful compilation)
      ("^Output written on .*\\.pdf (.*)" . font-lock-function-name-face)
      ;; Add more patterns as needed...
      )
    "Font lock keywords for `latex-output-mode'.")

  ;; Function to apply latex-output-mode and ensure scrolling.
  (defun lvn--setup-latex-output ()
    "Enable `latex-output-mode' in the LaTeX output buffer and ensure
scrolling to the bottom."
    ;; Ensure mode is always reapplied.
    (unless (eq major-mode 'latex-output-mode)
      (latex-output-mode))
    (set (make-local-variable 'window-point-insertion-type) t)
    ;; Scroll to the bottom.
    (goto-char (point-max)))

  ;; Add our function to TeX-output-mode-hook.
  (add-hook 'TeX-output-mode-hook #'lvn--setup-latex-output)

  ;; Align columns in LaTeX tables within the selected region.
  (defun lvn-align-latex-tables (start end)
    "Align columns in LaTeX tables."
    (interactive "r")
    (align-regexp start end "\\(\\s-*\\)&" 1 1 t))

  (leuven--section "25.11 (emacs)AUCTeX Mode")

;;** 1.2 (info "(auctex)Installation") of AUCTeX

  ;; (try-require 'tex-site)

  ;; Support for LaTeX documents.
  (with-eval-after-load 'latex

    ;; ;; LaTeX-sensitive spell checking
    ;; (add-hook 'tex-mode-hook
    ;;           (lambda ()
    ;;             (make-local-variable 'ispell-parser)
    ;;             (setq ispell-parser 'tex)))

;;** 2.1 (info "(auctex)Quotes")

    (leuven--section "2.1 (auctex)Quotes")

    ;; Insert right brace with suitable macro after typing left brace.
    (setq LaTeX-electric-left-right-brace t)

;;** 2.6 (info "(auctex)Completion")

    (leuven--section "2.6 (auctex)Completion")

    ;; If this is non-nil when AUCTeX is loaded, the TeX escape character `\'
    ;; will be bound to `TeX-electric-macro'.
    (setq TeX-electric-escape t)

;;** 2.8 (info "(auctex)Indenting")

    (leuven--section "2.8 (auctex)Indenting")

    ;; Leave some environments un-indented when using `M-q'.
    (dolist (env '("tikzpicture" "comment" "sverbatim"))
      (add-to-list 'LaTeX-indent-environment-list (list env 'current-indentation)))

    ;; Auto-indentation (suggested by the AUCTeX manual -- instead of adding
    ;; a local key binding to `RET' in the `LaTeX-mode-hook').
    (setq TeX-newline-function 'newline-and-indent)

;;** 4.1 Executing (info "(auctex)Commands")

    (leuven--section "4.1 Executing (auctex)Commands")

    ;; Add a command to execute on the LaTeX document.
    (add-to-list 'TeX-command-list      ; ~ `tex-compile-commands'.
                 '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))

    ;; (add-to-list 'TeX-command-list
    ;;              '("latexmk" "(run-latexmk)"
    ;;                TeX-run-function nil t :help "Run latexmk") :append)
    ;; (setq TeX-command-default "latexmk")

    ;; Not called?
    (defun lvn--setup-latex-mode ()
      "Custom hook for LaTeX mode."
      (setq TeX-command-default (lvn--determine-tex-command))
      (TeX-fold-mode 1))

    (defun lvn--determine-tex-command ()
      "Determine the appropriate TeX command based on package usage."
      (let ((fontspec-regex "^\\s-*\\\\usepackage\\(?:\\[.*\\]\\)?{.*\\<\\(?:font\\|math\\)spec\\>.*}")
            (search-limit 3000))
        (if (lvn--file-contains-regex fontspec-regex search-limit)
            "XeLaTeX"
          "LaTeX")))

    (defun lvn--file-contains-regex (regex limit)
      "Check if the current buffer contains REGEX within LIMIT lines from the start."
      (save-excursion
        (save-restriction
          (widen)
          (goto-char (point-min))
          (re-search-forward regex limit t))))

    ;; Automatically switch to French dictionary when LaTeX document uses French.
    (defun lvn--switch-to-french-dictionary ()
      "Change the local dictionary to French when using French in LaTeX babel package."
      (when (eq major-mode 'latex-mode)
        (when (save-excursion
                (goto-char (point-min))
                (or (re-search-forward "\\(documentclass.*french\\)" nil t)
                    (re-search-forward "\\(usepackage.*french.*babel\\)" nil t)))
          (message "[Switched dictionary to français]")
          (sit-for 0.5)
          (save-excursion
            (ispell-change-dictionary "francais")
            (force-mode-line-update)
            (when flyspell-mode
              (flyspell-buffer))))))

    (add-hook 'LaTeX-mode-hook #'lvn--switch-to-french-dictionary)

    ;; Don't ask user for permission to save files before starting TeX.
    (setq TeX-save-query nil)

    (defun TeX-default ()
      "Choose the default command from `C-c C-c'."
      (interactive)
      (TeX-save-document "")          ; or just use `TeX-save-query'
      (execute-kbd-macro (kbd "C-c C-c RET")))

    ;; Rebind the "compile command" to default command from `C-c C-c' (in LaTeX
    ;; mode only).
    (define-key LaTeX-mode-map (kbd "<f9>") #'TeX-default)

    ;; Use PDF mode by default (instead of DVI).
    (setq-default TeX-PDF-mode t)

;;** 4.2 (info "(auctex)Viewing") the formatted output

    (leuven--section "4.2 (auctex)Viewing the formatted output")

    ;; Use a saner PDF viewer (SumatraPDF, evince).
    (defvar leuven--sumatrapdf-command
      (concat leuven--windows-program-files-dir "SumatraPDF/SumatraPDF.exe")
      "Path to the SumatraPDF executable.")

    ;; Configure SumatraPDF as the PDF viewer for Windows-based systems.
    (when (or lvn--win32-p
              lvn--wsl-p
              lvn--cygwin-p)
      ;; Add SumatraPDF to available viewers (AUCTeX 11.86+).
      (when (boundp 'TeX-view-program-list)
        (add-to-list 'TeX-view-program-list
                     `("SumatraPDF"
                       ,(list (concat "\"" leuven--sumatrapdf-command "\" %o")))))
      ;; Set SumatraPDF as default PDF viewer.
      (setcdr (assoc 'output-pdf TeX-view-program-selection)
              '("SumatraPDF")))

;;** 4.7 (info "(auctex)Documentation")

;;** 5.2 (info "(auctex)Multifile") Documents

    ;; ;; Assume that the file is a master file itself.
    ;; (setq-default TeX-master t)

;;** 5.3 Automatic (info "(auctex)Parsing Files")

    ;; Enable parse on load (if no style hook is found for the file).
    (setq TeX-parse-self t)

    ;; Enable automatic save of parsed style information when saving the buffer.
    (setq TeX-auto-save t)

;;** 5.4 (info "(auctex)Internationalization")

    ;; ;; XXX Insert a literal hyphen.
    ;; (setq LaTeX-babel-insert-hyphen nil)

;;** 5.5 (info "(auctex)Automatic") Customization

    ;; TODO Add beamer.el to TeX-style-path

;;*** 5.5.1 (info "(auctex)Automatic Global") Customization for the Site

    (leuven--section "5.5.1 (auctex)Automatic Global Customization for the Site")

    ;; Directory containing automatically generated TeX information.
    (setq TeX-auto-global
          (concat user-emacs-directory "auctex-auto-generated-info/"))
                                        ; Must end with a slash.

;;*** 5.5.3 (info "(auctex)Automatic Local") Customization for a Directory

    (leuven--section "5.5.3 (auctex)Automatic Local Customization for a Directory")

    ;; Directory containing automatically generated TeX information.
    (setq TeX-auto-local (concat user-emacs-directory "auctex-auto-generated-info/"))
                                        ; Must end with a slash.

;;** (info "(preview-latex)Top")

    (leuven--section "(preview-latex)Top")

    (with-eval-after-load 'preview

      ;; Determine the path to the `gs' command for format conversions.
      (setq preview-gs-command
            (cond
             (lvn--win32-p
              ;; Windows-specific path for `gswin32c.exe'.
              (or (executable-find "gswin32c.exe")
                  "C:/texlive/2015/tlpkg/tlgs/bin/gswin32c.exe"))

             (t
              ;; Default for Unix-like systems or Cygwin Emacs.
              (or (executable-find "rungs") ; Cygwin-specific gs command.
                  "/usr/bin/gs"))))     ; Default Ghostscript path for Unix-like systems.

      ;; Ensure the `gs' command is executable, or signal an error if not.
      (lvn--validate-file-executable-p preview-gs-command)

      ;; Scale factor for included previews.
      (setq preview-scale-function 1.2))

    (add-hook 'LaTeX-mode-hook #'reftex-mode) ; with AUCTeX LaTeX mode

    ;; Minor mode with distinct support for `\label', `\ref', `\cite' and
    ;; `\index' in LaTeX.
    (with-eval-after-load 'reftex

      ;; Turn all plug-ins on.
      (setq reftex-plug-into-AUCTeX t)

      ;; Use a separate selection buffer for each label type -- so the menu
      ;; generally comes up faster.
      (setq reftex-use-multiple-selection-buffers t))

    ;; BibTeX mode.
    (with-eval-after-load 'bibtex

      ;; Current BibTeX dialect.
      (setq bibtex-dialect 'biblatex))

    )                                   ; with-eval-after-load "latex" ends here.

)                                       ; Chapter 25.11-tex-mode ends here.

(leuven--chapter leuven-load-chapter-25-text "25 Commands for Human Languages"

;;** 25.12 (info "(emacs)HTML Mode")

  (leuven--section "25.12 (emacs)HTML Mode")

  (when (locate-library "html-helper-mode")

    (autoload 'html-helper-mode "html-helper-mode"
      "Mode for editing HTML documents." t)

    ;; Invoke html-helper-mode automatically on .html files.
    (add-to-list 'auto-mode-alist '("\\.html?\\'" . html-helper-mode))

    ;; Invoke html-helper-mode automatically on .asp files.
    (add-to-list 'auto-mode-alist '("\\.asp\\'" . html-helper-mode))

    ;; Invoke html-helper-mode automatically on .jsp files.
    (add-to-list 'auto-mode-alist '("\\.jsp\\'" . html-helper-mode)))

  (with-eval-after-load 'web-mode-autoloads
    (add-to-list 'auto-mode-alist '("\\.aspx\\'"   . web-mode))
    (add-to-list 'auto-mode-alist '("\\.html?\\'"  . web-mode))
    (add-to-list 'auto-mode-alist '("\\.jsp\\'"    . web-mode))
    (add-to-list 'auto-mode-alist '("\\.x[ms]l\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.xhtml?\\'" . web-mode)))

  ;; Major mode for editing web templates.
  (with-eval-after-load 'web-mode

    (define-key web-mode-map (kbd "C--")      #'web-mode-fold-or-unfold)
    (define-key web-mode-map (kbd "C-+")      #'web-mode-fold-or-unfold)
    (define-key web-mode-map (kbd "M-(")      #'web-mode-element-wrap)

    (define-key web-mode-map (kbd "M-h")      #'web-mode-mark-and-expand)

    ;; Moving.
    (define-key web-mode-map (kbd "M-n")      #'web-mode-tag-next)
    (define-key web-mode-map (kbd "C-M-e")    #'web-mode-element-end)
    (define-key web-mode-map (kbd "M-<down>") #'web-mode-element-sibling-next) ;; end or next? XXX

    (define-key web-mode-map (kbd "M-p")      #'web-mode-tag-previous)
    (define-key web-mode-map (kbd "C-M-p")    #'web-mode-tag-previous)
    (define-key web-mode-map (kbd "C-M-a")    #'web-mode-element-previous)
    (define-key web-mode-map (kbd "M-<up>")   #'web-mode-element-sibling-previous)

    (define-key web-mode-map (kbd "C-M-u")    #'web-mode-element-parent)

    (define-key web-mode-map (kbd "C-M-d")    #'web-mode-element-child)


  (defun web-mode-edit-element-elements-end-inside ()
    "Move point to the end of the current HTML element and then one
character backward."
    (interactive)
    (web-mode-element-end)
    (backward-char))

  (defun web-mode-edit-element-utils-x-position (fx)
    "Call the given function and return the point position."
    (save-excursion
      (funcall fx)
      (point)))

  (defun web-mode-edit-element-utils-fnil (val f)
    "Return VAL if it's non-nil, otherwise, call the given function
F and return its result."
    (if val
        val
      (funcall f)))

  (defun web-mode-edit-element-elements-sibling-next-p ()
    "Check if the next element is a sibling or part of the parent
element."
    (let ((parent-position
           (web-mode-edit-element-utils-fnil
            (save-excursion
              (web-mode-element-beginning)
              (web-mode-element-parent-position))
            'point))
          (tag-next-position
           (web-mode-edit-element-utils-x-position
            (lambda ()
              (web-mode-edit-element-elements-end-inside)
              (web-mode-tag-next)
              (web-mode-element-beginning)))))
      (not (= parent-position tag-next-position))))

  (defun web-mode-edit-element-elements-sibling-next-or-next-parent ()
    "Move to the next sibling element or, if there are none, move to
the parent element."
    (interactive)
    (if (web-mode-edit-element-elements-sibling-next-p)
        (web-mode-element-sibling-next)
      (web-mode-element-parent)
      (web-mode-element-sibling-next)))

  (define-key web-mode-map (kbd "M-<down>")
              #'web-mode-edit-element-elements-sibling-next-or-next-parent)



;; XXX What about Fold Tag Attributes?

;; C-M-a           c-beginning-of-defun
;; C-M-e           c-end-of-defun
;; C-M-h           c-mark-function
;; C-M-j           c-indent-new-comment-line
;; C-M-q           c-indent-exp
;; M-a             c-beginning-of-statement
;; M-e             c-end-of-statement
;; M-j             c-indent-new-comment-line
;; M-q             c-fill-paragraph

    ;; Script element left padding.
    (setq web-mode-script-padding
          (if (and (boundp 'standard-indent) standard-indent) standard-indent 4))

    ;; Style element left padding.
    (setq web-mode-style-padding
          (if (and (boundp 'standard-indent) standard-indent) standard-indent 4))

    ;; CSS indentation level.
    (setq-default web-mode-css-indent-offset
                  (if (and (boundp 'standard-indent) standard-indent) standard-indent 4))

    (setq-default web-mode-attr-indent-offset
                  (if (and (boundp 'standard-indent) standard-indent) standard-indent 4))

    ;; Code (JavaScript, php, etc.) indentation level.
    (setq-default web-mode-code-indent-offset
                  (if (and (boundp 'standard-indent) standard-indent) standard-indent 4))
                                        ; XXX Check out ab-pm-cf-wr-newother.axvw.

    ;; Auto-pairing.
    (setq web-mode-enable-auto-pairing t)

    ;; Enable element highlight.
    (setq web-mode-enable-current-element-highlight t) ; web-mode-current-element-highlight-face.

    ;; Enable block face (useful for setting background of <style>).
    (setq web-mode-enable-block-face t) ; web-mode-block-face.

    ;; Enable part face (useful for setting background of <script>).
    (setq web-mode-enable-part-face t) ; web-mode-part-face.

    ;; ;; Comment style : 1 = default, 2 = force server comments outside a block.
    ;; (setq web-mode-comment-style 2)

    ;; (flycheck-add-mode 'html-tidy 'web-mode)

    )

  (with-eval-after-load 'nxml-mode

    ;; Indent 4 spaces (for the children of an element relative to the start-tag).
    (setq nxml-child-indent 4)

    (setq nxml-slash-auto-complete-flag t)

    ;; Remove the binding of `C-c C-x' (`nxml-insert-xml-declaration'), used by
    ;; Org timeclocking commands.
    (define-key nxml-mode-map (kbd "C-c C-x") nil)

    ;; View the buffer contents in a browser.
    (define-key nxml-mode-map (kbd "C-c C-v") #'browse-url-of-buffer)
                                        ; XXX Normally bound to
                                        ; `rng-validate-mode'.

;; causes entire elements (with children) to be treated as sexps.
(setq nxml-sexp-element-flag t)

    ;; Fix XML folding.
    (add-to-list 'hs-special-modes-alist
                 '(nxml-mode
                   "<!--\\|<[^/>]*[^/]>"
                   "-->\\|</[^/>]*[^/]>"
                   "<!--"
                   nxml-forward-element
                   nil))

    (add-hook 'nxml-mode-hook 'hs-minor-mode))

  ;; Highlight the current SGML tag context (`hl-tags-face').
  (try-require 'hl-tags-mode)
  (with-eval-after-load 'hl-tags-mode

    (add-hook 'html-mode-hook
              (lambda ()
                (require 'sgml-mode)
                ;; When `html-mode-hook' is called from `html-helper-mode'.
                (hl-tags-mode 1)))      ; XXX Can't we simplify this form?

    (add-hook 'nxml-mode-hook
              (lambda ()
                (when (< (buffer-size) lvn-large-file-warning-threshold) ; View large files.
                  (hl-tags-mode 1))))

    ;; (add-hook 'web-mode-hook #'hl-tags-mode)
    )

  ;; TODO: Handle media queries
  ;; TODO: Handle wrapped lines
  ;; TODO: Ignore vendor prefixes
  (defun leuven-sort-css-properties ()
    "Sort CSS properties alphabetically."
    (interactive)
    (let ((start (search-forward "{"))
          (end (search-forward "}")))
      (when (and start end)
        (sort-lines nil start end)
        (sort-declarations))))

)                                       ; Chapter 25 ends here.

;;* 26 Editing (info "(emacs)Programs")

(leuven--chapter leuven-load-chapter-26-programs "26 Editing Programs"

  ;; Swap the current and next line.
  (defun leuven-move-line-down ()
    "Move the current line down one line."
    (interactive)
    (forward-line 1)
    (transpose-lines 1)
    (forward-line -1))

  ;; Swap the current and previous line.
  (defun leuven-move-line-up ()
    "Move the current line up one line."
    (interactive)
    (transpose-lines 1)
    (forward-line -2))

  (add-hook 'prog-mode-hook
            (lambda ()
              (local-set-key (kbd "<C-S-down>") #'leuven-move-line-down)
              (local-set-key (kbd "<C-S-up>")   #'leuven-move-line-up)
                                        ; Sublime Text and js2-refactor.
              (local-set-key (kbd "<M-S-down>") #'leuven-move-line-down)
              (local-set-key (kbd "<M-S-up>")   #'leuven-move-line-up)))
                                        ; IntelliJ IDEA.

  ;; Move caret down and up in the editor.
  (add-hook 'prog-mode-hook
            (lambda ()
              ;; Scroll text of current window upward by one line.
              (local-set-key (kbd "<C-up>")   (kbd "C-u 1 C-v"))

              ;; Scroll text of current window downward by one line.
              (local-set-key (kbd "<C-down>") (kbd "C-u 1 M-v"))))
                                        ; Sublime Text + SQL Management Studio + IntelliJ IDEA.

;;** 26.1 Major Modes for (info "(emacs)Program Modes")

  (leuven--section "26.1 Major Modes for (emacs)Program Modes")

;;** 26.2 Top-Level Definitions, or (info "(emacs)Defuns")

  (leuven--section "26.2 Top-Level Definitions, or (emacs)Defuns")

  (defun leuven-beginning-of-next-defun ()
    "Move forward to the beginning of next defun."
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'beginning-of-defun)))

  ;; Next Method.
  (global-set-key (kbd "<M-down>") #'leuven-beginning-of-next-defun)

  ;; Previous Method.
  (global-set-key (kbd "<M-up>")   #'beginning-of-defun) ; C-M-a.

  ;; Making buffer indexes as menus.
  (try-require 'imenu)                  ; Try to load the awesome 'imenu' library.

  (with-eval-after-load 'imenu
    ;; Always rescan buffers for Imenu.
    (setq imenu-auto-rescan t)

    ;; Function to add Imenu to the menu bar in modes that support it.
    (defun lvn--try-to-add-imenu ()
      "Attempt to add an Imenu index to the menu bar."
      (condition-case nil
          (imenu-add-to-menubar "Outline") ; Add Imenu index.
        (error nil)))

    ;; Add Imenu to the menu bar in any mode that supports it.
    (add-hook 'font-lock-mode-hook #'lvn--try-to-add-imenu)

    ;; Bind Imenu to the mouse.
    (global-set-key [S-mouse-3] #'imenu)

    ;; Set the string to display in the mode line when the current function is
    ;; unknown.
    (setq which-func-unknown "(Top Level)")

    ;; Enable which-function-mode to show the current function in the mode line
    ;; based on Imenu.
    (which-function-mode 1)             ; ~ Stickyfunc mode (in header line).

    (defcustom lvn-which-func-max-length 30
      "Maximum length of the function name displayed in the modeline."
      :group 'leuven
      :type 'integer)

    (defun lvn--which-func-current ()
      "Return the current function name, truncated to `lvn-which-func-max-length'."
      (let ((current (gethash (selected-window) which-func-table)))
        (if current
            (truncate-string-to-width current
                                      lvn-which-func-max-length
                                      nil nil "...")
          which-func-unknown)))

    (setq which-func-format
          `("[" (:propertize (:eval (lvn--which-func-current))
                             local-map ,which-func-keymap
                             face which-func
                             mouse-face mode-line-highlight
                             help-echo "mouse-1: go to beginning\n\
mouse-2: toggle rest visibility\n\
mouse-3: go to end") "]")))

  (with-eval-after-load 'helm-autoloads

    ;; Keybinding to quickly jump to a symbol in buffer.
    (global-set-key [remap imenu] #'helm-imenu))

  ;; Helm interface for Imenu.
  (with-eval-after-load 'helm-imenu

    ;; Delimit types of candidates and his value
    (setq helm-imenu-delimiter ": ")

    ;; Do not directly jump to the definition even if there is just on candidate.
    (setq helm-imenu-execute-action-at-once-if-one nil))

;;** 26.3 (info "(emacs)Program Indent")ation

    (leuven--section "26.3 (emacs)Program Indentation")

    ;; Turn on auto-fill mode in Lisp modes.
    (dolist (mode '(lisp-mode
                    emacs-lisp-mode))
      (add-hook (intern (format "%s-hook" mode)) #'auto-fill-mode))

    ;; Auto-indentation: automatically jump to the "correct" column when the RET
    ;; key is pressed while editing a program (act as if you pressed `C-j').
    (add-hook 'prog-mode-hook
              (lambda ()
                (local-set-key (kbd "<RET>") #'newline-and-indent)
                (local-set-key (kbd "C-j") #'newline)))

    ;; ;; Function to move to the beginning of the line or back to the indentation.
    ;; (defun back-to-indentation-or-beginning ()
    ;;   (interactive)
    ;;   (if (/= (point) (line-beginning-position))
    ;;       (beginning-of-line)
    ;;     (back-to-indentation)))
    ;;
    ;; ;; Function to align selected text using spaces for whitespace.
    ;; (defun align-with-spaces (beg end)
    ;;   "Align selected text using only spaces for whitespace."
    ;;   (interactive "r")
    ;;   (let ((indent-tabs-mode nil))
    ;;     (align beg end)))

    ;; Use SMIE code for navigation and indentation in "sh-script" mode.
    (with-eval-after-load 'sh-script
      (setq sh-use-smie t))

;;** 26.4 Commands for Editing with (info "(emacs)Parentheses")

  (leuven--section "26.4 Commands for Editing with (emacs)Parentheses")

  ;; Check for unbalanced parentheses in supported modes.
  (dolist (mode '(emacs-lisp clojure js2 js))
    (add-hook (intern (format "%s-mode-hook" mode))
              (lambda ()
                (add-hook 'after-save-hook 'check-parens nil t))))

  ;; Move the cursor to the offscreen open-paren when a close-paren is inserted.
  (setq blink-matching-paren 'jump-offscreen)
  ;; Note: This doesn't work when `show-paren-mode' is enabled XXX

  ;; Enable show-paren-mode to highlight matching parentheses.
  (show-paren-mode 1)

  ;; Configure the style for highlighting parentheses to 'mixed' (or
  ;; 'expression' to highlight the entire expression).
  (setq show-paren-style 'mixed)

  ;; Ring the bell when there is a mismatch between parentheses.
  (setq show-paren-ring-bell-on-mismatch t)

  ;; Highlight matching parentheses when the point is inside a parenthesis.
  (setq show-paren-when-point-inside-paren t)

  ;; Highlight matching parentheses when the point is in the periphery (before
  ;; or after) of an expression.
  (setq show-paren-when-point-in-periphery t)

  ;; XXX Navigate to the code block start.
  (global-set-key (kbd "C-)") #'forward-sexp)
  (global-set-key (kbd "C-(") #'backward-sexp)

  ;; Jump to matching parenthesis.
  (defun leuven-goto-matching-paren (arg)
    "Go to the matching parenthesis, if on a parenthesis."
    (interactive "p")
    (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
          ((looking-at "\\s\)") (forward-char 1) (backward-list 1))))

  (global-set-key (kbd "C-S-)") #'leuven-goto-matching-paren)
  (global-set-key (kbd "C-°")   #'leuven-goto-matching-paren)

  ;; Automatic insertion, wrapping and paredit-like navigation with user defined
  ;; pairs.
  (with-eval-after-load 'smartparens-autoloads-XXX

    ;; Default configuration for smartparens package.
    (require 'smartparens-config)       ; Keybinding management, markdown-mode,
                                        ; org-mode, (la)tex-mode, Lisp modes,
                                        ; C++, PHP.
    (global-set-key "\M-R" #'sp-splice-sexp-killing-around) ; `sp-raise-sexp'.

    ;; Toggle Smartparens mode in all buffers.
    (smartparens-global-mode 1)         ; How to disable this in large files?

    ;; Toggle Show-Smartparens mode in all buffers.
    (show-smartparens-global-mode 1)

    ;; Remove local pairs in Text mode.
    (sp-local-pair 'text-mode "'" nil :actions nil)
    (sp-local-pair 'text-mode "\"" nil :actions nil)

    (push 'latex-mode sp-ignore-modes-list)

    (defun leuven-sp-kill-maybe (arg)
      (interactive "P")
      (if (consp arg)
          (sp-kill-sexp)
        (kill-line arg)))

    (global-set-key [remap kill-line] #'leuven-sp-kill-maybe)

    )

;;** 26.5 (info "(emacs)Comments")

  (leuven--section "26.5 (emacs)Comments")

  ;; Always comment out empty lines.
  (setq comment-empty-lines t)

  (defun lvn--comment-advice (orig-fun &rest args)
    "Comment or uncomment lines intelligently.

  When called interactively with no active region, comment a single
  line instead."
    (if (or (use-region-p) (not (called-interactively-p 'any)))
        (apply orig-fun args)
      (comment-or-uncomment-region (line-beginning-position)
                                   (line-end-position))
      (message "[Commented line]")))

  (advice-add 'comment-dwim :around #'lvn--comment-advice)

;;** 26.6 (info "(emacs)Documentation") Lookup

  (leuven--section "26.6 (emacs)Documentation Lookup")

  ;; Idle time to wait before printing documentation.
  (setq eldoc-idle-delay 0.2)

  ;; Resize echo area to fit documentation.
  (setq eldoc-echo-area-use-multiline-p t)

  ;; ;; Show the function arglist or the variable docstring in the echo area.
  ;; (global-eldoc-mode)                 ; In Emacs 25.

;;** 26.7 (info "(emacs)Hideshow") minor mode

  (leuven--section "26.7 (emacs)Hideshow minor mode")

  ;; Enable Hideshow (code folding) for programming modes.
  (add-hook 'prog-mode-hook #'hs-minor-mode)

  (with-eval-after-load 'hideshow

    ;; Unhide both code and comment hidden blocks when doing incremental search.
    (setq hs-isearch-open t)

    (defun lvn--expand-after-goto (orig-fun &rest args)
      "Expand the block at point after jumping to a line or definition."
      (let ((result (apply orig-fun args)))
        (save-excursion (hs-show-block))
        result))

    (advice-add 'goto-line :after #'lvn--expand-after-goto)
    (advice-add 'xref-find-definitions :after #'lvn--expand-after-goto)

    ;; Define prefix `C-c f' for folding commands.
    (define-key hs-minor-mode-map (kbd "C-c f h") #'hs-hide-block)
    (define-key hs-minor-mode-map (kbd "C-c f s") #'hs-show-block)
    (define-key hs-minor-mode-map (kbd "C-c f H") #'hs-hide-all)
    (define-key hs-minor-mode-map (kbd "C-c f S") #'hs-show-all)

    ;; Alternative numpad shortcuts.
    (define-key hs-minor-mode-map (kbd "<C-kp-subtract>")   #'hs-hide-block)  ;; `C--'.
    (define-key hs-minor-mode-map (kbd "<C-kp-add>")        #'hs-show-block)  ;; `C-+'.
    (define-key hs-minor-mode-map (kbd "<C-S-kp-subtract>") #'hs-hide-all)    ;; `C-S--'.
    (define-key hs-minor-mode-map (kbd "<C-S-kp-add>")      #'hs-show-all)    ;; `C-S-+'.

    ;; Remove default `C-c @' prefix.
    (define-key hs-minor-mode-map (kbd "C-c @") nil)

    (defcustom hs-face 'hs-face
      "*Specify the face to to use for the hidden region indicator"
      :group 'hideshow
      :type 'face)

    (defface hs-face
      '((t :box "#777777" :foreground "#9A9A6A" :background "#F3F349"))
      "Face to hightlight the \"...\" area of hidden regions"
      :group 'hideshow)

    (defun hs-display-code-line-counts (ov)
      (when (eq 'code (overlay-get ov 'hs))
        (overlay-put ov 'display (propertize "..." 'face 'hs-face))))

    (setq hs-set-up-overlay 'hs-display-code-line-counts)

    ;; ;; Hide all top level blocks.
    ;; (add-hook 'find-file-hook #'hs-hide-all)
)

;;** 26.8 (info "(emacs)Symbol Completion")

  (leuven--section "26.8 (emacs)Symbol Completion")

;;** 26.9 (info "(emacs)Glasses") minor mode

  (leuven--section "26.9 (emacs)Glasses minor mode")

  (add-hook 'ess-mode-hook          #'glasses-mode)
  (add-hook 'inferior-ess-mode-hook #'glasses-mode)
  (add-hook 'java-mode-hook         #'glasses-mode)

  (with-eval-after-load 'glasses

    ;; String to be displayed as a visual separator in unreadable identifiers.
    (setq glasses-separator "")

    ;; No display change.
    (setq glasses-original-separator "")

    ;; Face to be put on capitals of an identifier looked through glasses.
    (make-face 'leuven-glasses-face)
    (set-face-attribute 'leuven-glasses-face nil :weight 'bold)
    (setq glasses-face 'leuven-glasses-face)
                                        ; Avoid the black foreground set in
                                        ; `emacs-leuven-theme' to face `bold'.

    ;; Set properties of glasses overlays.
    (glasses-set-overlay-properties)

    ;; No space between an identifier and an opening parenthesis.
    (setq glasses-separate-parentheses-p nil))

  ;; An interface to the Eclipse IDE.
  (with-eval-after-load 'emacs-eclim-autoloads-XXX

    ;; Enable Eclim mode in Java.
    (add-hook 'java-mode-hook #'eclim-mode))

  (with-eval-after-load 'eclim

    ;; Find Eclim installation.
    (setq eclim-executable
          (or (executable-find "eclim")
              (concat leuven--windows-program-files-dir "eclipse/eclim.bat")))
    ;; (setq eclim-executable "C:/PROGRA~2/eclipse/eclim.bat")
    ;; (setq eclim-executable "C:/Users/Fabrice/Downloads/eclipse/eclim.bat")

    ;; (add-to-list 'eclim-eclipse-dirs
    ;;              (concat leuven--windows-program-files-dir "eclipse/eclim"))

    ;; Print debug messages.
    (setq eclim-print-debug-messages t)

    ;; Add key binding.
    (define-key eclim-mode-map (kbd "M-.") #'eclim-java-find-declaration)

    ;; Display compilation error messages in the echo area.
    (setq help-at-pt-display-when-idle t)
    (setq help-at-pt-timer-delay 0.1)
    (help-at-pt-set-timer)

    ;; Add the emacs-eclim source.
    (require 'ac-emacs-eclim-source)

    ;;! Limit `ac-sources' to Eclim source.
    (defun ac-emacs-eclim-java-setup ()
      (setq ac-sources '(ac-source-emacs-eclim)))
   ;; (setq ac-sources (delete 'ac-source-words-in-same-mode-buffers ac-sources))

    (ac-emacs-eclim-config)

    ;; Configure company-mode.
    (require 'company-emacs-eclim)
    (company-emacs-eclim-setup)

    ;; Control the Eclim daemon from Emacs.
    (require 'eclimd)

    )

  (with-eval-after-load 'js2-mode-autoloads

    (add-to-list 'auto-mode-alist '("\\.js\\'\\|\\.json\\'" . js2-mode)))

  (with-eval-after-load 'js2-mode

    ;; Add highlighting of many ECMA built-in functions.
    (setq js2-highlight-level 3)

    ;; Delay in secs before re-parsing after user makes changes.
    (setq-default js2-idle-timer-delay 0.1)

    ;; `js2-line-break' in mid-string will make it a string concatenation.
    ;; The '+' will be inserted at the end of the line.
    (setq js2-concat-multiline-strings 'eol)

    ;; (setq js2-mode-show-parse-errors nil)

    ;; Don't emit Ecma strict-mode warnings.
    (setq js2-mode-show-strict-warnings nil)

    ;; Let Flycheck handle parse errors.
    (setq js2-strict-missing-semi-warning nil)

    ;; Treat unused function arguments like declared-but-unused variables.
    (setq js2-warn-about-unused-function-arguments t)

    ;; Augment the default indent-line behavior with cycling among several
    ;; computed alternatives.
    (setq js2-bounce-indent-p t)

)

;; Xref-js2

;; {{ Patching Imenu in js2-mode
;; (setq js2-imenu-extra-generic-expression javascript-common-imenu-regex-list)

(defvar js2-imenu-original-item-lines nil
  "List of line information of original Imenu items.")

(defun js2-imenu--get-line-start-end (pos)
  (let (b e)
    (save-excursion
      (goto-char pos)
      (setq b (line-beginning-position))
      (setq e (line-end-position)))
    (list b e)))

(defun js2-imenu--get-pos (item)
  (let (val)
    (cond
     ((integerp item)
      (setq val item))

     ((markerp item)
      (setq val (marker-position item))))

    val))

(defun js2-imenu--get-extra-item-pos (item)
  (let (val)
    (cond
     ((integerp item)
      (setq val item))

     ((markerp item)
      (setq val (marker-position item)))

     ;; plist
     ((and (listp item) (listp (cdr item)))
      (setq val (js2-imenu--get-extra-item-pos (cadr item))))

     ;; alist
     ((and (listp item) (not (listp (cdr item))))
      (setq val (js2-imenu--get-extra-item-pos (cdr item)))))

    val))

(defun js2-imenu--extract-line-info (item)
  "Recursively parse the original imenu items created by js2-mode.
The line numbers of items will be extracted."
  (let (val)
    (if item
      (cond
       ;; Marker or line number
       ((setq val (js2-imenu--get-pos item))
        (push (js2-imenu--get-line-start-end val)
              js2-imenu-original-item-lines))

       ;; The item is Alist, example: (hello . 163)
       ((and (listp item) (not (listp (cdr item))))
        (setq val (js2-imenu--get-pos (cdr item)))
        (if val (push (js2-imenu--get-line-start-end val)
                      js2-imenu-original-item-lines)))

       ;; The item is a Plist
       ((and (listp item) (listp (cdr item)))
        (js2-imenu--extract-line-info (cadr item))
        (js2-imenu--extract-line-info (cdr item)))

       ;;Error handling
       (t (message "[Impossible to here! item=%s]" item)
          )))
    ))

(defun js2-imenu--item-exist (pos lines)
  "Try to detect does POS belong to some LINE"
  (let (rlt)
    (dolist (line lines)
      (if (and (< pos (cadr line)) (>= pos (car line)))
          (setq rlt t)))
    rlt))

(defun js2-imenu--is-item-already-created (item)
  (unless (js2-imenu--item-exist
           (js2-imenu--get-extra-item-pos item)
           js2-imenu-original-item-lines)
    item))

(defun js2-imenu--check-single-item (r)
  (cond
   ((and (listp (cdr r)))
    (let (new-types)
      (setq new-types
            (delq nil (mapcar 'js2-imenu--is-item-already-created (cdr r))))
      (if new-types (setcdr r (delq nil new-types))
        (setq r nil))))
   (t (if (js2-imenu--item-exist (js2-imenu--get-extra-item-pos r)
                                 js2-imenu-original-item-lines)
          (setq r nil))))
  r)

(defun js2-imenu--remove-duplicate-items (extra-rlt)
  (delq nil (mapcar 'js2-imenu--check-single-item extra-rlt)))

(defun js2-imenu--merge-imenu-items (rlt extra-rlt)
  "RLT contains imenu items created from AST.
EXTRA-RLT contains items parsed with simple regex.
Merge RLT and EXTRA-RLT, items in RLT has *higher* priority."
  ;; Clear the lines.
  (set (make-variable-buffer-local 'js2-imenu-original-item-lines) nil)
  ;; Analyze the original imenu items created from AST,
  ;; I only care about line number.
  (dolist (item rlt)
    (js2-imenu--extract-line-info item))

  ;; @see https://gist.github.com/redguardtoo/558ea0133daa72010b73#file-hello-js
  ;; EXTRA-RLT sample:
  ;; ((function ("hello" . #<marker 63>) ("bye" . #<marker 128>))
  ;;  (controller ("MyController" . #<marker 128))
  ;;  (hellworld . #<marker 161>))
  (setq extra-rlt (js2-imenu--remove-duplicate-items extra-rlt))
  (append rlt extra-rlt))

(with-eval-after-load 'js2-mode
  (defun lvn--js2-mode-create-imenu-index-advice (orig-fun &rest args)
    "Advice to enhance js2-mode's imenu index creation."
    (let* ((original-index (apply orig-fun args))
           (extra-index (save-excursion
                          (imenu--generic-function js2-imenu-extra-generic-expression))))
      (js2-imenu--merge-imenu-items original-index extra-index)))

  (advice-add 'js2-mode-create-imenu-index :around #'lvn--js2-mode-create-imenu-index-advice))
;; }}

    (defun js2-imenu-record-object-clone-extend ()
      (let* ((node (js2-node-at-point (1- (point)))))
      (when (js2-call-node-p node)
        (let* ((args (js2-call-node-args node))
               (methods (second args))
               (super-class (first args))
               (parent (js2-node-parent node)))
          (when (js2-object-node-p methods)
            (let ((subject (cond ((js2-var-init-node-p parent)
                                  (js2-var-init-node-target parent))
                                 ((js2-assign-node-p parent)
                                  (js2-assign-node-left parent)))))
              (when subject
                (js2-record-object-literal methods
                                           (js2-compute-nested-prop-get subject)
                                           (js2-node-abs-pos methods)))))))))

    ;; Color identifiers based on their names.
    (with-eval-after-load 'color-identifiers-mode-autoloads
      (add-hook 'js2-mode-hook 'color-identifiers-mode))

    ;; JS-comint.
    ;; (define-key js2-mode-map (kbd "C-c b")   #'js-send-buffer)
    ;; (define-key js2-mode-map (kbd "C-c C-b") #'js-send-buffer-and-go)

;; Disable JSHint since we prefer ESLint checking.
(with-eval-after-load 'flycheck

  ;; (setq-default flycheck-disabled-checkers
  ;;               (append flycheck-disabled-checkers
  ;;                       '(javascript-jshint)))

  ;; Disable the JavaScript ESLint checker by adding it to the list of disabled
  ;; checkers.
  (setq-default flycheck-disabled-checkers
                (append flycheck-disabled-checkers
                        '(javascript-eslint)))

  ;; ;; use eslint with web-mode for jsx files
  ;; (flycheck-add-mode 'javascript-eslint 'web-mode)

    ;; (add-hook 'js2-mode-hook
    ;;           (lambda () (flycheck-select-checker "javascript-eslint")))

  ;; Set up configurations for the `js2-mode` by adding a hook.
  (add-hook 'js2-mode-hook
            (defun leuven--js2-mode-setup ()
              (flycheck-mode t)
              ;; Enable a specific checker if ESLint is available:
              ;; (when (executable-find "eslint")
              ;;   (flycheck-select-checker 'javascript-eslint))
              ))

  ;; (setq flycheck-display-errors-function
  ;;       'flycheck-display-error-messages-unless-error-list)
  ;;
  ;; ;; (setq flycheck-standard-error-navigation nil)
  ;;
  ;; (setq flycheck-global-modes '(not erc-mode
  ;;                                   message-mode
  ;;                                   git-commit-mode
  ;;                                   view-mode
  ;;                                   outline-mode
  ;;                                   text-mode
  ;;                                   org-mode))
  )

    ;; (define-key js2-mode-map (kbd "C-c d") #'my/insert-or-flush-debug)

    (defvar my/debug-counter 1)
    (defun my/insert-or-flush-debug (&optional reset beg end)
      (interactive "pr")
      (cond
       ((= reset 4)
        (save-excursion
          (flush-lines "console.log('DEBUG: [0-9]+" (point-min) (point-max))
          (setq my/debug-counter 1)))
       ((region-active-p)
        (save-excursion
          (goto-char end)
          (insert ");\n")
          (goto-char beg)
          (insert (format "console.log('DEBUG: %d', " my/debug-counter))
          (setq my/debug-counter (1+ my/debug-counter))
          (js2-indent-line)))
       (t
        ;; Wrap the region in the debug.
        (insert (format "console.log('DEBUG: %d');\n" my/debug-counter))
        (setq my/debug-counter (1+ my/debug-counter))
        (backward-char 3)
        (js2-indent-line))))

;;   (setup "jquery-doc"
;;     (setup-hook 'js-mode-hook 'jquery-doc-setup)
;;     (setup-after "popwin"
;;       (push '("^\\*jQuery doc" :regexp t) popwin:special-display-config))
;;     (setup-keybinds js-mode-map
;;       "<f1> s" 'jquery-doc)))

    (when (executable-find "tern")
      (add-hook 'js-mode-hook  #'tern-mode)
      (add-hook 'js2-mode-hook #'tern-mode)
      (add-hook 'web-mode-hook #'tern-mode))

;; (require 'css-mode)
;; (define-key css-mode-map (kbd "C-c i") #'emr-css-toggle-important)

)                                       ; Chapter 26 ends here.

;;* 27 (info "(emacs)Building") Compiling and Testing Programs

(leuven--chapter leuven-load-chapter-27-building "27 Compiling and Testing Programs"

;;** 27.1 Running (info "(emacs)Compilation")s under Emacs

  (leuven--section "27.1 Running (emacs)Compilations under Emacs")

  ;; Invoke a compiler with the same command as in the last invocation of
  ;; `compile'.
  (autoload 'recompile "compile"
    "Re-compile the program including the current buffer." t)

  (global-set-key (kbd "<f9>") #'recompile)

  ;; Scroll the `*compilation*' buffer window to follow output as it appears.
  (setq compilation-scroll-output t)

  ;; ;; Number of lines in a compilation window.
  ;; (setq compilation-window-height 8)

  ;; Always kill a running compilation process before starting a new one.
  (setq compilation-always-kill t)

  (defun lvn--compilation-hide-window-if-successful (buffer message)
    "Handle the compilation result in BUFFER with the given MESSAGE."
    (if (string-match "exited abnormally" message)
        ;; There were errors. Provide a suggestion to visit errors.
        (message "[Compilation errors detected. Press C-x ` to visit.]")
      ;; No errors, close the compilation window after 0.5 seconds.
      (run-at-time 0.5 nil
                   #'delete-windows-on buffer)
      (message "[No compilation errors!]")))

  ;; (add-to-list 'compilation-finish-functions #'lvn--compilation-hide-window-if-successful)

  (defun lvn--compilation-move-to-first-error (buffer message)
    "Move to the first compilation error in BUFFER and beep."
    (with-current-buffer buffer
      (goto-char (point-min))
      (compilation-next-error 1)
      (beep)))

  ;; (add-to-list 'compilation-finish-functions #'lvn--compilation-move-to-first-error)

  (defun lvn--compilation-scroll-to-end-of-buffer (buffer message)
    "Ensure that BUFFER is visible, scrolling to the end if needed."
    (let ((buffer-window (get-buffer-window buffer))
          (current-window (selected-window)))
      (when buffer-window
        (select-window buffer-window)
        (with-current-buffer buffer
          (when (> (line-number-at-pos (point-max)) (window-height))
            (goto-char (point-max))
            (recenter (window-height))))
        (select-window current-window))))

  (add-to-list 'compilation-finish-functions #'lvn--compilation-scroll-to-end-of-buffer)

  (defvar make-clean-command "make clean all"
    "*Command used by the `make-clean' function.")

  (defun make-clean (&optional arg)
    "Run a make clean."
    (interactive "P")
    (require 'compile)                  ; Needed for compile-internal.
    (if arg
        (setq make-clean-command
              (read-string "Command: " make-clean-command)))
    (save-some-buffers (not compilation-ask-about-save) nil)
    (compile-internal make-clean-command "No more errors"))

  (global-set-key (kbd "<S-f9>") #'make-clean)

  (defvar leuven--ant-command-history nil
    "Ant command history variable")

  (defun leuven-ant (&optional args)
    "Runs ant in the current project. Starting at the directory
     where the file being visited resides, a search is made for
     build.xml recursively. A maven command is made from the first
     directory where the build.xml file is found is then displayed in
     the minibuffer. The command can be edited as needed and then
     executed. Errors are navigate to as in any other compile mode"
    (interactive)
    (let ((fn (buffer-file-name)))
      (let ((dir (file-name-directory fn)))
        (while (and (not (file-exists-p (concat dir "/build.xml")))
                    (not (equal dir (file-truename (concat dir "/..")))))
          (setf dir (file-truename (concat dir "/.."))))
        (if (not (file-exists-p (concat dir "/build.xml")))
            (message "[No build.xml found]")
          (compile (read-from-minibuffer "Command: "
                                         (concat "ant -emacs -f "
                                         dir "/build.xml compile") nil
                                         nil
                                         'leuven--ant-command-history))))))

  (add-hook 'java-mode-hook
            (lambda ()
              (local-set-key "<f9>" 'leuven-ant)))

  ;; Use Java for class files decompiled with Jad.
  (add-to-list 'auto-mode-alist '("\\.jad\\'" . java-mode))

  ;; Color identifiers based on their names.
  (with-eval-after-load 'color-identifiers-mode-autoloads
    (add-hook 'java-mode-hook 'color-identifiers-mode))

;;** 27.2 (info "(emacs)Compilation Mode")

  (leuven--section "27.2 (emacs)Compilation Mode")

  ;; ;; Automatically jump to the first error during compilation.
  ;; (setq compilation-auto-jump-to-first-error t)

  ;; Display the next compiler error message.
  (global-set-key (kbd "<f10>")   #'next-error) ; C-M-down in IntelliJ IDEA.
                                        ; Also on `M-g n', `M-g M-n' and `C-x `'.

  ;; Display the previous compiler error message.
  (global-set-key (kbd "<S-f10>") #'previous-error) ; C-M-up in IntelliJ IDEA.
                                        ; Also on `M-g p' and `M-g M-p'.

  ;; Display the first compiler error message.
  (global-set-key (kbd "<C-f10>") #'first-error)

  ;; ;; Prefer fringe.
  ;; (setq next-error-highlight 'fringe-arrow)

  ;; Highlight and parse the whole compilation output as soon as it arrives.
  (setq compile-auto-highlight t)

;;** 27.4 (info "(emacs)Grep Searching") under Emacs

  (leuven--section "27.4 (emacs)Grep Searching under Emacs")

  (with-eval-after-load 'grep

    ;; Run `grep' via `find', with user-friendly interface.
    (global-set-key (kbd "C-c 3") #'rgrep)

    ;; Ignore case distinctions in the default `grep' command.
    (grep-apply-setting 'grep-command "grep -i -H -n -e ")

    ;; Do not append `null-device' (`/dev/null' or `NUL') to `grep' commands.
    (grep-apply-setting 'grep-use-null-device nil)
                                        ; Not necessary if the `grep' program
                                        ; used supports the `-H' option.

  (with-eval-after-load 'grep
    ;; Files to ignore for MEPLA.
    (add-to-list 'grep-find-ignored-files "archive-contents"))

    (when (executable-find "rgXXX")        ; ripgrep.

      ;; Default grep command for `M-x grep'.
      ;; (grep-apply-setting 'grep-command "ag --nogroup --numbers ")

      ;; Default command to run for `M-x lgrep'.
      (grep-apply-setting 'grep-template "rg --no-heading -H -uu -g <F> <R> <D>")

      ;; Default find command for `M-x grep-find'.
      ;; (grep-apply-setting 'grep-find-command '("ag --noheading --column " . 25))

      ;; Default command to run for `M-x rgrep'.
      (grep-apply-setting 'grep-find-template
                          "find <D> <X> -type f <F> -exec rg <C> --no-heading -H <R> /dev/null {} +"))
                                        ; `<D>' = path.
                                        ; `<X>' for the find options to restrict
                                        ;       directory list.
                                        ; `<F>' = glob.
                                        ; ------------------------------------
                                        ; `<C>' for the place to put `-i' if the
                                        ;       search is case-insensitive.
                                        ; `<R>' = pattern.

    ;; Prefer rg > ag.
    (when (and (executable-find "agXXX") ; XXX Need to fix base dir and file extensions!!!
               (not (executable-find "rg")))

      ;; Default grep command for `M-x grep'.
      ;; (grep-apply-setting 'grep-command "ag --nogroup --numbers ")

      ;; Default command to run for `M-x lgrep'.
      ;; (grep-apply-setting 'grep-template "ag --depth 0 <R> <F>")

      ;; Default find command for `M-x grep-find'.
      ;; (grep-apply-setting 'grep-find-command '("ag --noheading --column " . 25))

      ;; Default command to run for `M-x rgrep' (`C-c 3').
      (grep-apply-setting 'grep-find-template
                          "ag --color --nogroup --line-numbers <R> ."))
                                        ; `<D>' for the base directory.
                                        ; `<X>' for the find options to restrict
                                        ;       directory list.
                                        ; `<F>' for the find options to limit
                                        ;       the files matched.
                                        ; ------------------------------------
                                        ; `<C>' for the place to put `-i' if the
                                        ;       search is case-insensitive.
                                        ; `<R>' for the regular expression to
                                        ;       search for.

    ;; This is how compilers number the first column, usually 1 or 0.
    ;; (setq-default grep-first-column 1)

    ;; Use `find -print0' and `xargs -0'.
    (setq grep-find-use-xargs 'gnu))    ; with-eval-after-load "grep" ends here.

  ;; Run `grep' via `find', with user-friendly interface.
  (global-set-key (kbd "C-c 3") #'rgrep)

;;** 27.5 (info "(emacs)Flymake")

  (leuven--section "27.5 (emacs)Flymake")

  ;; Enable on-the-fly syntax checking with Flycheck.
  (with-eval-after-load 'flycheck-autoloads
    ;; ;; Enable Flycheck mode in all programming modes.
    ;; (add-hook 'prog-mode-hook #'flycheck-mode)
    ;;
    ;; ;; Enable Flycheck mode in LaTeX mode.
    ;; (add-hook 'LaTeX-mode-hook #'flycheck-mode)

    ;; Set a global keybinding to quickly access the Flycheck error list.
    (global-set-key (kbd "M-g l") #'flycheck-list-errors))

  (with-eval-after-load 'flycheck

    ;; Delay in seconds before displaying errors at point.
    (setq flycheck-display-errors-delay 0.3)

    (setq flycheck-indication-mode 'left-fringe) ; See init.el.
    ;; ;; Indicate errors and warnings via icons in the right fringe.
    (setq flycheck-indication-mode 'right-fringe)

    ;; Remove newline checks, since they would trigger an immediate check when
    ;; we want the `flycheck-idle-change-delay' to be in effect while editing.
    (setq flycheck-check-syntax-automatically
          '(save
            idle-change
            ;; new-line
            mode-enabled))

    ;; Each buffer get its local `flycheck-idle-change-delay' because of the
    ;; buffer-sensitive adjustment above.
    (make-variable-buffer-local 'flycheck-idle-change-delay)

    (defun leuven--adjust-flycheck-automatic-syntax-eagerness ()
      "Adjust how often we check for errors based on if there are any.

This lets us fix any errors as quickly as possible, but in
a clean buffer we're an order of magnitude laxer about checking."
      (setq flycheck-idle-change-delay
            (if (assq 'error (flycheck-count-errors flycheck-current-errors))
                ; only check for REAL errors (original source: Magnar Sveen)
                1
              20)))

    ;; Functions to run after each syntax check.
    (add-hook 'flycheck-after-syntax-check-hook
              #'leuven--adjust-flycheck-automatic-syntax-eagerness)

    ;; Change mode line color with Flycheck status.
    (with-eval-after-load 'flycheck-color-mode-line
      (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)))

  (global-set-key (kbd "C-x C-S-e") #'elint-current-buffer)

  (with-eval-after-load 'elint
    (add-to-list 'elint-standard-variables 'current-prefix-arg)
    (add-to-list 'elint-standard-variables 'command-line-args-left)
    (add-to-list 'elint-standard-variables 'buffer-file-coding-system)
    (add-to-list 'elint-standard-variables 'emacs-major-version)
    (add-to-list 'elint-standard-variables 'window-system))

;;** 27.6 Running (info "(emacs)Debuggers") Under Emacs

  (leuven--section "27.6 Running (emacs)Debuggers Under Emacs")

  (with-eval-after-load 'gdb-mi

    ;; Enable Gdb-Many-Windows mode.
    (setq gdb-many-windows t))          ; The only important parameter for GDB.

  (defvar gud-overlay
    (let* ((ov (make-overlay (point-min) (point-min))))
      (overlay-put ov 'face '(:background "#F6FECD"))
                                        ; Color for Leuven theme
                                        ; (highlight-yellow).
      ov)
    "Overlay variable for GUD highlighting.")

  (defun lvn--gud-highlight-advice (orig-fun &rest args)
    "Highlight current line after displaying it in GUD."
    (let ((result (apply orig-fun args)))
      (let* ((ov gud-overlay)
             (bf (gud-find-file true-file)))
        (with-current-buffer bf
          (move-overlay ov (line-beginning-position) (line-end-position))))
      result))

  (advice-add 'gud-display-line :after #'lvn--gud-highlight-advice)

;;** Debugging Lisp programs

  ;; Source-level debugger for Emacs Lisp.
  (with-eval-after-load 'edebug

    ;; ;; Display a trace of function entry and exit.
    ;; (setq edebug-trace t)

    (defun lvn--highlight-line-advice (orig-fun &rest args)
      "Highlight line currently being Edebug'ged."
      (require 'hl-line)
      (hl-line-mode 1)
      (apply orig-fun args))

    (advice-add 'edebug-overlay-arrow :around #'lvn--highlight-line-advice)

    (defun lvn-edebug-quit ()
      "Stop Edebug'ging and remove highlighting."
      (interactive)
      (hl-line-mode -1)
      (top-level))

    (define-key edebug-mode-map [remap top-level] #'lvn-edebug-quit))

;;** 27.8 (info "(emacs)Lisp Libraries") for Emacs

  (leuven--section "27.8 (emacs)Lisp Libraries")

  ;; Remove *.elc when save.
  (defun remove-elc-on-save ()
    "If you're saving an elisp file, likely the .elc is no longer valid."
    (make-local-variable 'after-save-hook)
    (add-hook 'after-save-hook
              (lambda ()
                (if (file-exists-p (concat buffer-file-name "c"))
                    (delete-file (concat buffer-file-name "c"))))))

  (add-hook 'emacs-lisp-mode-hook #'remove-elc-on-save)

  ;; Force load of `.el' files when they are newer than the `.elc' files.
  (setq load-prefer-newer t)            ; From Emacs 24.4.

;;** 27.9 (info "(emacs)Lisp Eval") Expressions

  (leuven--section "27.9 (emacs)Lisp Eval Expressions")

  ;; Enable the use of the command `eval-expression' without confirmation.
  (put 'eval-expression 'disabled nil)

  ;; Maximum depth of lists to print in the result of the evaluation commands
  ;; before abbreviating them.
  (setq eval-expression-print-level nil) ; No limit.

  ;; Maximum length of lists to print in the result of the evaluation commands
  ;; before abbreviating them.
  (setq eval-expression-print-length nil) ; No limit.

  ;; ;; Limit serving to catch infinite recursions for you before they
  ;; ;; cause actual stack overflow in C, which would be fatal for Emacs.
  ;; (setq max-lisp-eval-depth 600)        ; 1000?

  ;; Dynamic evaluation replacement with Emacs.
  (with-eval-after-load 'litable-autoloads

    (add-hook 'lisp-interaction-mode-hook #'litable-mode))

;;** 27.10 (info "(emacs)Lisp Interaction") Buffers

  (leuven--section "27.10 (emacs)Lisp Interaction Buffers")

  ;; Don't display the "Welcome to GNU Emacs" buffer on startup.
  (setq inhibit-startup-screen t)

  ;; Don't insert instructions in the `*scratch*' buffer at startup.
  (setq initial-scratch-message nil)

  ;; Major mode command symbol to use for the initial `*scratch*' buffer.
  (setq initial-major-mode 'fundamental-mode)

  (setq switch-to-buffer-in-dedicated-window 'prompt)

)                                       ; Chapter 27 ends here.

;;* 28 (info "(emacs)Maintaining") Programs

(leuven--chapter leuven-load-chapter-28-maintaining "28 Maintaining Programs"

;;** 28.1 (info "(emacs)Version Control")

  (leuven--section "28.1 (emacs)Version Control")

  ;; Always follow symlinks to files under source-control.  Don't ask.
  (setq vc-follow-symlinks t)

  ;; (setq vc-allow-async-revert t)

  ;; (setq vc-git-diff-switches '("-w" "-U3")) ;; XXX What about mnemonicprefix=true?

;; ;; When opening a file that is a symbolic link, don't ask whether I
;; ;; want to follow the link. Just do it
;; (setq find-file-visit-truename t)

;;*** 28.1.4 (info "(emacs)Log Buffer")

  (defun leuven--vc-log-mode-setup ()
    (when (lvn--executable-ispell-program-name-p)
      (setq ispell-local-dictionary "american")
      (flyspell-mode)))

  (add-hook 'vc-log-mode-hook #'leuven--vc-log-mode-setup)

  (autoload 'vc-git-root "vc-git")

  (with-eval-after-load 'vc-git
    ;; Align with Git's 50-character commit summary convention.
    (setq vc-git-log-edit-summary-max-len 50)

    ;; Load 'git-commit' if available (now provided by Magit).
    (when (locate-library "git-commit")
      ;; Major mode for editing Git commit messages.
      (idle-require 'git-commit)))

  (with-eval-after-load 'git-commit
    ;; Enable on-the-fly spell-checking in commit messages.
    (add-hook 'git-commit-setup-hook #'flyspell-mode)

    ;; Function to disable save-place in Git commit buffers.
    (defun lvn--git-commit-disable-save-place ()
      "Disable save-place mode in Git commit buffers."
      (save-place-mode -1))

    ;; Add the function to the git-commit-setup-hook.
    (add-hook 'git-commit-setup-hook #'lvn--git-commit-disable-save-place))

;;*** 28.1.6 (info "(emacs)Old Revisions")

  (leuven--section "28.1.6 Examining And Comparing Old Revisions")

  ;; Switches for diff under VC.
  (setq vc-diff-switches diff-switches)

;;*** 28.1.7 (info "(emacs)VC Change Log")

  (leuven--section "28.1.7 VC Change Log")

  (global-set-key (kbd "C-x v H") #'vc-region-history)

  ;; Walk through Git revisions of a file.
  (with-eval-after-load 'git-timemachine-autoloads

    ;; Number of chars from the full SHA1 hash to use for abbreviation.
    (setq git-timemachine-abbreviation-length 7)

    (global-set-key (kbd "C-x v t") #'git-timemachine))

  ;; Show the last commit information for the current line.
  (with-eval-after-load 'git-messenger
    ;; Keybinding.
    (global-set-key (kbd "C-x v p") #'git-messenger:popup-message)
                                        ; 'p' for "popup".

    ;; Show commit ID, author and date.
    (setq git-messenger:show-detail t))

;;*** 28.1.9 (info "(emacs)VC Directory Mode")

  (leuven--section "28.1.9 VC Directory Mode")

  ;; Ensure `vc-dir` always operates from the top-level VCS directory.
  (defun lvn--vcs-goto-top-directory-advice (orig-fun buffer dir backend &rest rest)
    (let ((vcs-top-dir (vc-call-backend backend 'responsible-p dir)))
      (if (stringp vcs-top-dir)
          (apply orig-fun buffer vcs-top-dir backend rest)
        (apply orig-fun buffer dir backend rest))))

  (advice-add 'vc-dir-prepare-status-buffer :around #'lvn--vcs-goto-top-directory-advice)

  (defun lvn-jump-to-vc-status-buffer-for-current-directory ()
    "Jump to the VC status buffer for the current directory."
    (interactive)
    (let* ((buffer-file (buffer-file-name))
           (directory (if buffer-file
                          (if (file-directory-p buffer-file)
                              buffer-file
                            (file-name-directory buffer-file))
                        default-directory)))
      (message "[VC status for directory: %s]" directory)
      (vc-dir directory)))

  ;; VC status without asking for a directory.
  (global-set-key (kbd "<C-f9>") #'lvn-jump-to-vc-status-buffer-for-current-directory)

  (add-hook 'vc-dir-mode-hook
            (lambda ()
              ;; Hide up-to-date and unregistered files.
              (define-key vc-dir-mode-map
                          (kbd "x") #'lvn-hide-up-to-date-and-unregistered-files-in-vc-dir)
              (define-key vc-dir-mode-map
                          (kbd "E") #'vc-ediff)
              (define-key vc-dir-mode-map
                          (kbd "#") #'lvn-vc-ediff-ignore-whitespace)
                                        ; ediff-windows-wordwise?
              ))

  (defun lvn-hide-up-to-date-and-unregistered-files-in-vc-dir ()
    "Hide up-to-date and unregistered files in VC directory buffer."
    (interactive)
    (vc-dir-hide-up-to-date)
    ;; (vc-dir-hide-up-to-date 'unregistered)
    (lvn-vc-dir-hide-unregistered)
    )

  (defun lvn-vc-dir-hide-unregistered ()
    "Hide ‘unregistered’ items from display."
    (interactive)
    (let ((current-item (ewoc-nth vc-ewoc -1))
          (first-item (ewoc-nth vc-ewoc 0)))
      ;; Iterate from the last item to the first and remove unregistered files
      ;; and directories without child files.
      (while (not (eq current-item first-item))
        (let* ((item-data (ewoc-data current-item))
               (is-directory (vc-dir-fileinfo->directory item-data))
               (next-item (ewoc-next vc-ewoc current-item))
               (prev-item (ewoc-prev vc-ewoc current-item))
               ;; Necessary for ewoc-delete to work...
               (inhibit-read-only t))
          (when (or
                 ;; Remove directories with no child files.
                 (and is-directory
                      (or
                       ;; No item follows this directory.
                       (not next-item)
                       ;; Next item is a directory.
                       (vc-dir-fileinfo->directory (ewoc-data next-item))))
                 ;; Remove files in the unregistered state.
                 (eq (vc-dir-fileinfo->state item-data) 'unregistered))
            (ewoc-delete vc-ewoc current-item))
          (setq current-item prev-item)))))

  (defun lvn-vc-ediff-ignore-whitespace (historic &optional not-urgent)
    "Ignore regions that differ in white space & line breaks only."
    (interactive (list current-prefix-arg t))
    (require 'ediff)
    (let ((ediff-ignore-similar-regions t))
      (call-interactively 'vc-ediff)))  ; XXX does not work yet!

;;*** 28.1.13 (info "(emacs)Customizing VC")

  (leuven--section "28.1.13 Customizing VC")

  ;; Files covered by VC get backups (as with other files).
  (setq vc-make-backup-files t)

  (defun lvn--ediff-revision (file rev1 &optional rev2)
    "Compare two revisions of FILE (REV1 and REV2) using Ediff.
  If the current buffer is modified, prompt to save it before proceeding."
    (require 'ediff)
    (let ((buffer (find-file-noselect file)))
      (with-current-buffer buffer
        (when (and (buffer-modified-p)
                   (y-or-n-p (format "Buffer %s is modified. Save it? "
                                     (buffer-name))))
          (save-buffer)))
      (ediff-load-version-control)
      (funcall (intern (format "ediff-%s-internal" ediff-version-control-package))
               rev1 (rev2 "" nil))))

  (defun lvn-vc-diff-buffer-file (arg)
    "Diff the current file against a revision using Ediff, or run
 `vc-diff' with prefix ARG.
  With prefix ARG, call `vc-diff' interactively.
  Without ARG, prompt for a revision to compare against the current file
  using Ediff."
    (interactive "P")
    (let ((file (or (buffer-file-name)
                    (error "No file associated with this buffer"))))
      (if arg
          (vc-diff nil)
        (lvn--ediff-revision file
                            (read-string "Revision? " "HEAD" nil "HEAD")
                            ""))))

  (define-key vc-prefix-map (kbd "=") #'lvn-vc-diff-buffer-file)

(setq vc-annotate-display-mode nil)

;; http://www.onerussian.com/Linux/.files/dot_emacs
(setq vc-annotate-background "seashell")
(setq vc-annotate-very-old-color "black")

(setq vc-annotate-color-map
  '((  1.0 . "#FFCCCC") ; red
    (  2.0 . "#FFE4CC") ; orange
    (  7.0 . "#FFE4CC") ; yellow
    ( 32.0 . "#DEFFCC") ; green
    ( 92.0 . "#CCE4FF") ; blue
    (366.0 . "#C9C9C9"))) ; gray

;;** 28.2 (info "(emacs)Change Log")

  (leuven--section "28.2 (emacs)Change Logs")

  (with-eval-after-load 'add-log

    ;; Don't make a new entry, when the last entry was made by you and on the
    ;; same date.
    (setq add-log-always-start-new-record nil)

    ;; Add the file's version number to the change log entry.
    (setq change-log-version-info-enabled t)

    ;; Remove 'Invalid function' in Emacs 27
    ;; (add-hook 'change-log-mode-hook
    ;;           (add-to-list
    ;;            'change-log-font-lock-keywords
    ;;            '("^[0-9-]+:? +\\|^\\(Sun\\|Mon\\|Tue\\|Wed\\|Thu\\|Fri\\|Sat\\) [A-z][a-z][a-z] [0-9:+ ]+"
    ;;              (0 'change-log-date-face)
    ;;              ("\\([^<(]+?\\)[   ]*[(<]\\([[:alnum:]_.+-]+@[[:alnum:]_.-]+\\)[>)]" nil nil
    ;;               (1 'change-log-name)
    ;;               (2 'change-log-email)))))
  )

;;** 28.3 (info "(emacs)Tags")

  (leuven--section "28.3 (emacs)Tags Tables")

  ;; (with-eval-after-load 'etags
  ;;
  ;;   ;; Select from multiple tags.
  ;;   (try-require 'etags-select))

  (with-eval-after-load 'etags-select

    ;; Do a `find-tag-at-point', and display all exact matches.
    (global-set-key (kbd "M-?") #'etags-select-find-tag-at-point))

  ;; Find the definition of the Emacs Lisp function or variable near point.
  (find-function-setup-keys)

  (with-eval-after-load 'lisp-mode

    (defun leuven-goto-lisp-symbol-at-point ()
      "Go to the definition of the Emacs Lisp symbol at point."
      (interactive)
      (require 'thingatpt)              ; XXX use xref-find-definitions instead?
      (let ((sym (symbol-at-point)))    ; or (find-tag-default) or (current-word)?
        (funcall (pcase sym
                   ((pred facep)           'find-face)
                   ((pred symbol-function) 'find-function)
                   (_                      'find-variable))
                 sym)))

    (define-key emacs-lisp-mode-map (kbd "M-.") #'leuven-goto-lisp-symbol-at-point))

;;** 28.4 (info "(emacs)EDE")

  (leuven--section "28.4 Emacs Development Environment")

  ;; Configure Semantic default submodes.
  (setq semantic-default-submodes
        '(global-semanticdb-minor-mode           ; Store parse results in DB.
          global-semantic-idle-scheduler-mode    ; Auto-reparse in idle time.
          global-semantic-idle-summary-mode      ; Show symbol summary.
          global-semantic-idle-completions-mode  ; Show completion tooltips.
          global-semantic-mru-bookmark-mode      ; Track recent tags.
          global-semantic-stickyfunc-mode        ; Show function header.
          global-semantic-highlight-func-mode    ; Highlight current function.
          global-semantic-decoration-mode))      ; Show method separators.

  ;; Enable Semantic mode for Java.
  (add-hook 'java-mode-hook #'semantic-mode)
                                        ; Avoid enabling it for prog-mode, as
                                        ; this would trigger Semantic to start
                                        ; after Emacs initialization, since the
                                        ; scratch buffer uses Emacs Lisp...

  ;; Configure Semantic features after loading.
  (with-eval-after-load 'semantic
    ;; General programming mode keybindings.
    (defun lvn--setup-semantic-keys ()
      "Set up Semantic keybindings for programming modes."
      (local-set-key (kbd "C-c ?") #'semantic-ia-complete-symbol)    ; Complete symbol.
      (local-set-key (kbd "C-c j") #'semantic-ia-fast-jump)          ; Jump to definition.
      (local-set-key (kbd "C-c q") #'semantic-ia-show-doc)           ; Show documentation.
      (local-set-key (kbd "C-c s") #'semantic-ia-show-summary)       ; Show summary.
      (local-set-key (kbd "C-c >") #'semantic-complete-analyze-inline) ; Member completion.
      ;; (local-set-key (kbd "C-c p") #'semantic-analyze-proto-impl-toggle) ; Conflict with projectile.
      (local-set-key (kbd "C-c =") #'semantic-decoration-include-visit) ; Visit header.
      (local-set-key (kbd "C-c +") #'semantic-tag-folding-show-block)  ; Unfold block.
      (local-set-key (kbd "C-c -") #'semantic-tag-folding-fold-block) ; Fold block.
      ;; (local-set-key (kbd "C-c C-c +") #'semantic-tag-folding-show-all)
      ;; (local-set-key (kbd "C-c C-c -") #'semantic-tag-folding-fold-all)
      )

    (add-hook 'prog-mode-hook #'lvn--setup-semantic-keys)

    ;; C-specific Semantic configuration.
    (defun lvn--setup-c-semantic ()
      "Set up C-specific Semantic keybindings and completion."
      (local-set-key (kbd ".") #'semantic-complete-self-insert)  ; Complete on ..
      (local-set-key (kbd ">") #'semantic-complete-self-insert)  ; Complete on ->.
      (local-set-key (kbd "C-c C-r") #'semantic-symref))         ; Symbol references.

    (add-hook 'c-mode-common-hook #'lvn--setup-c-semantic))
                                        ; Be aware that this will affect all
                                        ; cc-modes, such as c-mode, c++-mode,
                                        ; php-mode, csharp-mode, and awk-mode.

  ;; Semantic Imenu configuration.
  (defun lvn--setup-semantic-imenu ()
    "Add Semantic tags to Imenu menu."
    (imenu-add-to-menubar "TAGS"))

  (add-hook 'semantic-init-hook #'lvn--setup-semantic-imenu)

  (with-eval-after-load 'projectile-autoloads
    (idle-require 'projectile)

    (with-eval-after-load 'projectile
      ;; Turn on projectile mode by default for all file types
      (projectile-mode)
      ;; (projectile-global-mode) ??

      ;; Add keymap prefix.
      (define-key projectile-mode-map (kbd "C-c p")   #'projectile-command-map)

      (define-key projectile-mode-map (kbd "C-c p g") #'projectile-grep)

      (setq projectile-completion-system 'helm)
      (setq projectile-completion-system 'helm-comp-read)

      ;; Turn on Helm key bindings for projectile.
      (when (locate-library "helm-projectile")
        (helm-projectile-on))

      ;; ;; For large projects.
      ;; (setq helm-projectile-sources-list
      ;;       '(helm-source-projectile-projects
      ;;         helm-source-projectile-files-list))
  ))

  (with-eval-after-load 'projectile

    ;; Indexing method.
    ;; (setq projectile-indexing-method 'native)

    ;; Enable caching of the project's files unconditionally.
    (setq projectile-enable-caching t)

    ;; Action invoked AFTER SWITCHING PROJECTS with `C-c p p'.
    (setq projectile-switch-project-action 'helm-projectile-find-file)
                                        ;; 'projectile-dired
                                        ;; 'projectile-find-file ; Default.
                                        ;; 'projectile-find-file-in-known-projects
                                        ;; 'projectile-find-file-dwim
                                        ;; 'projectile-find-dir

    ;; Don't echo messages that are not errors.
    (setq projectile-verbose nil)

    ;; Always ignore .class files.
    (add-to-list 'projectile-globally-ignored-file-suffixes ".class")

    ;; Ignore remote projects.
    (setq projectile-ignored-project-function 'file-remote-p)

    ;; Mode line lighter prefix for Projectile.
    (setq projectile-mode-line-prefix " P")
    ;; (setq projectile-mode-line-function
    ;;       '(lambda ()
    ;;          (if (and (projectile-project-p)
    ;;                   (not (file-remote-p default-directory)))
    ;;              (format " P[%s]" (projectile-project-name))
    ;;            "")))
  )

)                                       ; Chapter 28 ends here.

;;* 29 (info "(emacs)Abbrevs")

(leuven--chapter leuven-load-chapter-29-abbrevs "29 Abbrevs"

  ;; See (info "(autotype)") as well

;;** 29.3 Controlling (info "(emacs)Expanding Abbrevs")

  (leuven--section "29.3 Controlling Expanding Abbrevs")

  ;; Yet Another Snippet extension for Emacs
  (with-eval-after-load 'yasnippet-autoloads
    (idle-require 'yasnippet))

  (with-eval-after-load 'yasnippet

    ;; Add root directories that store the snippets.
    (let ((leuven-snippets              ; Additional YASnippets.
           (concat lvn--directory "../.emacs.d/snippets")))

      (when (file-directory-p leuven-snippets)
        (add-to-list 'yas-snippet-dirs leuven-snippets)))
                                        ; The first element (inserted last) is
                                        ; always the user-created snippets
                                        ; directory.

    ;; Use Snippet mode for files with a `yasnippet' extension.
    (add-to-list 'auto-mode-alist '("\\.yasnippet\\'" . snippet-mode))

    ;; Enable YASnippet in all buffers.
    (yas-global-mode 1)

    (with-eval-after-load 'diminish-autoloads
      (diminish 'yas-minor-mode " y"))

    ;; Load the snippet tables.
    (yas-reload-all)

    ;; Wrap around region.
    (setq yas-wrap-around-region t)

    ;; Don't expand when you are typing in a string or comment.
    (add-hook 'prog-mode-hook
              (lambda ()
                (setq yas-buffer-local-condition
                      '(if (nth 8 (syntax-ppss))
                                        ; Non-nil if in a string or comment.
                           '(require-snippet-condition . force-in-comment)
                         t))))

    ;; UI for selecting snippet when there are multiple candidates.
    (setq yas-prompt-functions '(yas-dropdown-prompt))

    (global-set-key (kbd "C-c & C-r") #'yas-reload-all)

    ;; Automatically reload snippets after saving.
    (defun recompile-and-reload-all-snippets ()
      (interactive)
      (when (derived-mode-p 'snippet-mode)
        (yas-recompile-all)
        (yas-reload-all)
        (message "[Reloaded all snippets]")))

    (add-hook 'after-save-hook #'recompile-and-reload-all-snippets)

    (global-set-key (kbd "C-c & C-l") #'yas-describe-tables)

    (defvar leuven-contextual-menu-map
      (let ((map (make-sparse-keymap "Contextual menu")))
        (define-key map [help-for-help] (cons "Help" 'help-for-help))
        (define-key map [seperator-two] '(menu-item "--"))
        map)
      "Keymap for the contextual menu.")

    (defun leuven-popup-contextual-menu (event &optional prefix)
      "Popup a contextual menu."
      (interactive "@e \nP")
        (define-key leuven-contextual-menu-map [lawlist-major-mode-menu]
          `(menu-item ,(symbol-name major-mode)
            ,(mouse-menu-major-mode-map) :visible t))
        (define-key leuven-contextual-menu-map (vector major-mode)
          `(menu-item ,(concat "Insert " (symbol-name major-mode) " snippet")
            ,(gethash major-mode yas--menu-table)
              :visible (yas--show-menu-p ',major-mode)))
        (popup-menu leuven-contextual-menu-map event prefix))

    (global-set-key [mouse-3] #'leuven-popup-contextual-menu)

    (add-hook 'snippet-mode-hook
              (lambda ()
                (setq require-final-newline nil)))

    ;; ;; Make the "yas-minor-mode"'s expansion behavior to take input word
    ;; ;; including hyphen.
    ;; (setq yas-key-syntaxes '("w_" "w_." "^ "))
                                        ; [default:
                                        ; '("w" "w_" "w_." "w_.()"
                                        ;   yas-try-key-from-whitespace)]

    )

    ;; Log level for `yas--message'.
    (setq yas-verbosity 2)              ; Warning.

  (with-eval-after-load 'auto-yasnippet-autoloads
    ;; (global-set-key (kbd "H-w") #'aya-create)
    (global-set-key (kbd "H-y") #'aya-open-line))

;;** 29.7 (info "(emacs)Dabbrev Customization")

  (leuven--section "29.7 Dabbrev Customization")

  ;; (with-eval-after-load 'dabbrev
  ;;
  ;;   ;; Preserve case when expanding the abbreviation.
  ;;   (setq dabbrev-case-replace nil))

  ;; Expand text trying various ways to find its expansion.
  (global-set-key (kbd "M-/") #'hippie-expand) ; Built-in.

  (with-eval-after-load 'hippie-exp

    ;; List of expansion functions tried (in order) by `hippie-expand'
    ;; (completion strategy).
    (setq hippie-expand-try-functions-list
          '(;; Searching the current buffer.
            try-expand-dabbrev

            ;; Emacs Lisp symbol, as many characters as unique.
            try-complete-lisp-symbol-partially

            ;; Emacs Lisp symbol.
            try-complete-lisp-symbol

            ;; Searching visible window parts.
            try-expand-dabbrev-visible

            ;; ;; Searching (almost) all other buffers (see
            ;; ;; `hippie-expand-ignore-buffers').
            ;; try-expand-dabbrev-all-buffers

            ;; File name, as many characters as unique.
            try-complete-file-name-partially

            ;; File name.
            try-complete-file-name))

    ;; Integrate YASnippet with `hippie-expand'.
    (with-eval-after-load 'yasnippet

      (add-to-list 'hippie-expand-try-functions-list
                   'yas-hippie-try-expand)))
                                        ; Makes more sense when placed at the
                                        ; top of the list.

  ;; Auto Completion.
  (with-eval-after-load 'auto-complete-autoloads-XXX
    (idle-require 'auto-complete-config)

    (global-set-key (kbd "C-/")     #'auto-complete)
    (global-set-key (kbd "C-S-SPC") #'auto-complete))

  (with-eval-after-load 'auto-complete-config

    ;; 6.1 Set a list of sources to use (by default + for some major modes)
    (ac-config-default))                ; ... and enable Auto-Complete mode in
                                        ; all buffers.

  (with-eval-after-load 'auto-complete
                                        ; Required by ESS.

    ;; 5.4 Completion will be started automatically by inserting 1 character.
    (setq ac-auto-start 1)              ; Also applies on arguments after
                                        ; opening parenthesis in ESS.

    ;; 7.5 Use `C-n/C-p' to select candidates (only when completion menu is
    ;; displayed).
    (setq ac-use-menu-map t)

    ;; Completion by TAB.
    (define-key ac-completing-map (kbd "<tab>")   #'ac-complete)

    ;; ;; Completion by RET.
    ;; (define-key ac-completing-map (kbd "<RET>") #'ac-complete)

    ;; Unbind some keys (inconvenient in Comint buffers).
    (define-key ac-completing-map (kbd "M-n")     nil)
    (define-key ac-completing-map (kbd "M-p")     nil)

    (define-key ac-completing-map (kbd "C-h")     #'ac-help)

    ;; Abort.
    (define-key ac-completing-map (kbd "C-g")     #'ac-stop)
    (define-key ac-completing-map (kbd "<left>")  #'ac-stop)
    ;; (define-key ac-completing-map (kbd "<right>") #'ac-stop)

    ;; Extend the `ac-modes' list with additional modes.
    (setq ac-modes
          (append ac-modes
                  '(change-log-mode
                    latex-mode
                    ;; org-mode
                    prog-mode           ; Programming modes.
                    snippet-mode
                    sql-mode
                    text-mode)))

    ;; 7.9 Just ignore case.
    (setq ac-ignore-case t)             ; ???

    ;; 8.1 Delay to completions will be available.
    (setq ac-delay 0)                   ; Faster than default 0.1.
    ;; Eclipse uses 500ms?

    ;; 8.2 Completion menu will be automatically shown.
    (setq ac-auto-show-menu 0.2)        ; [Default: 0.8].

    ;; 8.13 Delay to show quick help.
    (setq ac-quick-help-delay 0.5)

    ;; 8.15 Max height of quick help.
    (setq ac-quick-help-height 10)      ; Same as `ac-menu-height'.

    ;; 8.16 Limit on number of candidates.
    (setq ac-candidate-limit 100)

    ;; (setq ac-disable-inline t)
    ;; (setq ac-candidate-menu-min 0)

    ;; 11.1 Avoid Flyspell processes when auto completion is being started.
    (ac-flyspell-workaround)

)

(defun toggle-auto-complete-company-modes ()
  "Toggle beteen AC and Company modes."
  (interactive)
  (if auto-complete-mode
      (progn
        (auto-complete-mode -1)
        (company-mode 1)
        (message "[Disable AC.  Enable Company]")
        (sit-for 2))
    (auto-complete-mode 1)
    (company-mode -1)
    (message "[Disable Company.  Enable AC]")
    (sit-for 2)))

(global-set-key (kbd "<M-f1>") #'toggle-auto-complete-company-modes)

  ;; Modular text completion framework.
  (with-eval-after-load 'company-autoloads
    (idle-require 'company)
    (with-eval-after-load 'company
      ;; Enable Company mode in all buffers ....
      (global-company-mode 1)

      (global-set-key (kbd "C-c y") #'company-yasnippet)
                                        ; Better than `helm-yas-complete' as
                                        ; `company-yasnippet' shows both the key
                                        ; and the replacement.
      ))

  (with-eval-after-load 'company

    ;; ... Except in some modes.
    (setq company-global-modes
          '(not ess-mode                ; In (i)ESS buffers, Auto-Complete is
                inferior-ess-mode       ; enabled by default.
                magit-status-mode
                help-mode))

    ;; ;; Sort candidates according to their occurrences.
    ;; (setq company-transformers '(company-sort-by-occurrence))
    ;; (setq company-transformers '(;; company-sort-by-statistics ;; unknown
    ;;                              company-sort-by-backend-importance))

    ;; Align annotations to the right tooltip border.
    (setq company-tooltip-align-annotations t)

    ;; Minimum prefix length for idle completion.
    (setq company-minimum-prefix-length 1)

    ;; Start completion immediately.
    (setq company-idle-delay 0)

    ;; Show quick-access numbers for the first ten candidates.
    (setq company-show-numbers t)

    ;; Selecting item before first or after last wraps around.
    (setq company-selection-wrap-around t)

    ;; Abort.
    ;; (define-key company-active-map (kbd "<right>") #'company-abort)
    ;; (define-key company-active-map (kbd "<left>")  #'company-abort)

    ;; Ignore some keys (inconvenient in Comint buffers).
    (define-key company-active-map (kbd "M-n")     nil)
    (define-key company-active-map (kbd "M-p")     nil)

    ;; Completion by TAB (insert the selected candidate).
    (define-key company-active-map (kbd "<tab>")   #'company-complete-selection)

    ;; Temporarily show the documentation buffer for the selection.  Also on F1 or C-h.
    (define-key company-active-map (kbd "C-?")     #'company-show-doc-buffer)

    ;;! Temporarily display a buffer showing the selected candidate in context.
    (define-key company-active-map (kbd "M-.")     #'company-show-location) ; XXX Also on C-w.

    (setq company-auto-complete
          (lambda ()
            (and (company-tooltip-visible-p)
                 (company-explicit-action-p))))

    ;; Configure the list of commands to continue company mode.
    (setq company-continue-commands
          '(not save-buffer
                save-some-buffers
                save-buffers-kill-terminal
                save-buffers-kill-emacs
                comint-previous-matching-input-from-input
                comint-next-matching-input-from-input))

    (setq company-require-match nil)

    ;; Do nothing if the indicated candidate contains digits (actually, it will
    ;; try to insert the digit you type).
    (advice-add 'company-complete-number :around
                (lambda (fun n)
                  (let ((cand (nth (+ (1- n) company-tooltip-offset)
                                   company-candidates)))
                    (if (string-match-p "[0-9]" cand)
                        (let ((last-command-event (+ ?0 n)))
                          (self-insert-command 1))
                      (funcall fun n))))
                '((name . "Don't complete numbers")))

    ;; From https://github.com/company-mode/company-mode/issues/188
    (defun leuven-company-quick-access-key (numbered)
      "Replace default behavior of `company--show-numbers' function.
This example lists Azerty layout second row keys."
      (let ((value (mod numbered 10)))
        (format " %s"
                (cond ((eql value 1) "a")
                      ((eql value 2) "z")
                      ((eql value 3) "e")
                      ((eql value 4) "r")
                      ((eql value 5) "t")
                      ((eql value 6) "y")
                      ((eql value 7) "u")
                      ((eql value 8) "i")
                      ((eql value 9) "o")
                      (t "p")))))

    (setq company-show-numbers-function #'leuven-company-quick-access-key)

    (define-key company-active-map (kbd "M-a") (kbd "M-1"))
    (define-key company-active-map (kbd "M-z") (kbd "M-2"))
    (define-key company-active-map (kbd "M-e") (kbd "M-3"))
    (define-key company-active-map (kbd "M-r") (kbd "M-4"))
    (define-key company-active-map (kbd "M-t") (kbd "M-5"))
    (define-key company-active-map (kbd "M-y") (kbd "M-6"))
    (define-key company-active-map (kbd "M-u") (kbd "M-7"))
    (define-key company-active-map (kbd "M-i") (kbd "M-8"))
    (define-key company-active-map (kbd "M-o") (kbd "M-9"))
    (define-key company-active-map (kbd "M-p") (kbd "M-0"))

    )                                   ; with-eval-after-load "company".

  ;; Dabbrev-like company-mode back-end for code.
  (with-eval-after-load 'company-dabbrev-code

    ;; ;; Search all other buffers
    ;; (setq company-dabbrev-code-other-buffers 'all)

    ;; Offer completions in comments and strings.
    (setq company-dabbrev-code-everywhere t)

    ;; ;; Ignore case when collecting completion candidates.
    ;; (setq company-dabbrev-code-ignore-case t)

    (when (locate-library "web-mode")
      (add-to-list 'company-dabbrev-code-modes 'web-mode))
    )

  (add-hook 'js2-mode-hook
            (lambda ()
              (set (make-local-variable 'company-backends)
                   '((company-dabbrev-code company-yasnippet)))))

  ;; Dabbrev-like company-mode completion back-end.
  (with-eval-after-load 'company-dabbrev

    ;; Only search in the current buffer
    (setq company-dabbrev-other-buffers nil) ; Prevent Company completing
                                             ; numbers coming from other files.

    ;; Don't ignore case when collecting completion candidates.
    (setq company-dabbrev-ignore-case nil)

    ;; Don't downcase the returned candidates.
    (setq company-dabbrev-downcase nil)
    ;; Fix problem with lowercased completions in comments and strings, in many
    ;; programming modes.

    ;; Skip invisible text (Org drawers, etc.).
    (setq company-dabbrev-ignore-invisible t))

  (with-eval-after-load 'company-quickhelp-autoloads

    ;; Enable `company-quickhelp-mode'.
    (company-quickhelp-mode 1)

    ;; ;; Delay to show quick help.
    ;; (setq company-quickhelp-delay 0.5)

    ;; Maximum number of lines to show in the popup.
    (setq company-quickhelp-max-lines 10))

)                                       ; Chapter 29 ends here.

;;* 30 (info "(emacs)Dired"), the Directory Editor

(leuven--chapter leuven-load-chapter-30-dired "30 Dired, the Directory Editor"

;;** (info "(emacs)Dired Enter")

  ;; Directory-browsing commands configuration.
  (with-eval-after-load 'dired

    (leuven--section "30.1 (emacs)Dired Enter")

    ;; Switches passed to `ls' for Dired.
    (setq dired-listing-switches "-alF")

;;** (info "(emacs)ls in Lisp")

    (leuven--section "G.4 (emacs)ls in Lisp")

    ;; Emulate insert-directory completely in Emacs Lisp.
    (when (require 'ls-lisp)

      ;; Disable the case-sensitive sort of file names.
      (setq ls-lisp-ignore-case t)

      ;; Sort directories first.
      (setq ls-lisp-dirs-first t)

      ;; Use `ls-lisp' in all versions of Emacs for Dired sorting to work
      ;; correctly.
      (setq ls-lisp-use-insert-directory-program nil)
                                        ; [Default: nil for Windows, t otherwise]

      ;; Use ISO 8601 dates.
      (setq ls-lisp-format-time-list
            '("%Y-%m-%d %H:%M"
              "%Y-%m-%d %H:%M"))

      ;; Use localized date/time format.
      (setq ls-lisp-use-localized-time-format t))

;;** (info "(emacs)Dired Navigation")

    (leuven--section "30.2 (emacs)Dired Navigation")

    ;; Function to move the cursor to the top of the Dired buffer.
    (defun lvn-dired-back-to-top ()
      (interactive)
      (goto-char (point-min))
      (dired-next-line 4))

    (define-key dired-mode-map
                [remap beginning-of-buffer] #'lvn-dired-back-to-top)

    ;; Function to move the cursor to the bottom of the Dired buffer.
    (defun lvn-dired-jump-to-bottom ()
      (interactive)
      (goto-char (point-max))
      (dired-next-line -1))

    (define-key dired-mode-map
                [remap end-of-buffer] #'lvn-dired-jump-to-bottom)

    ;; Search in filenames (instead of in everything).
    (define-key dired-mode-map (kbd "C-s") #'dired-isearch-filenames)

;;** (info "(emacs)Dired Deletion")

    (leuven--section "30.3 (emacs)Dired Deletion")

    ;; Recursive deletes allowed, after asking for each directory at top level.
    (setq dired-recursive-deletes 'top)

;;** (info "(emacs)Dired Visiting")

    (leuven--section "30.5 (emacs)Dired Visiting")

    ;; Reveal active buffer's directory in the system file explorer.
    (defun lvn-open-buffer-directory-in-file-explorer ()
      "Open the current buffer's directory in the default file explorer."
      (interactive)
      (let ((dir (file-name-directory (or buffer-file-name default-directory))))
        (if dir
            (browse-url-of-file dir)
          (error "No directory associated with this buffer"))))

    ;; Mnemonic for "directory".
    (global-set-key (kbd "C-c d") #'lvn-open-buffer-directory-in-file-explorer)

    ;; In Dired, ask a WWW browser to display the file named on this line.
    (define-key dired-mode-map (kbd "e") #'browse-url-of-dired-file) ; <C-RET>?

    ;; Open files using Windows associations.
    (when (or lvn--win32-p
              lvn--wsl-p
              lvn--cygwin-p)
      (defun lvn-dired-open-files-externally (&optional arg)
        "In Dired, open the marked files (or directories) with the default Windows tool."
        (interactive "P")
        (mapcar
         (lambda (file)
           (if lvn--wsl-p
               (shell-command (format "start %s" (convert-standard-filename file)))
             (w32-shell-execute "open" (convert-standard-filename file))))
         (dired-get-marked-files nil arg)))

      ;; ;; Bind it to `E' in Dired mode.
      ;; (define-key dired-mode-map (kbd "E") #'lvn-dired-open-files-externally)
    )

    (defun dired-open-marked-files-externally ()
      ;; dired-open-marked-files-with-explorer
      "Open marked files in Dired using the default external application."
      (interactive)
      (if-let ((marks (dired-get-marked-files)))
          (dolist (file marks)
            (cond
             (lvn--win32-p
              (w32-shell-execute "open" file))
             (lvn--wsl-p
              (if (executable-find "wslview-XXX") ; TO TEST!
                  (start-process "" nil "wslview" file)
                ;; (w32-shell-execute "open" file)
                (shell-command (format "explorer.exe '%s'" (file-name-nondirectory file)))
              ))
             (t
              (start-process "" nil "xdg-open" file))))
        (user-error "No marked files; aborting")))

    (define-key dired-mode-map "o" 'dired-open-marked-files-externally)

    ;; Open current file with eww.
    (defun dired-open-with-eww ()
      "In Dired, visit (with eww) the file named on this line."
      (interactive)
      (eww-open-file (file-name-sans-versions (dired-get-filename) t)))

    ;; Add a binding "W" -> `dired-open-with-eww' to Dired.
    (define-key dired-mode-map (kbd "W") #'dired-open-with-eww)

;;** (info "(emacs)Operating on Files")

    (leuven--section "30.7 (emacs)Operating on Files")

    ;; Try to guess a default target directory (if there is a Dired buffer
    ;; displayed in the next window).
    (setq dired-dwim-target t)

    ;; Copy recursively without asking.
    (setq dired-recursive-copies 'always)

;;** (info "(emacs)Dired Updating")

    (leuven--section "30.15 (emacs)Dired Updating")

    ;; Automatically revert Dired buffer *on revisiting*.
    (setq dired-auto-revert-buffer t)

    ;; Dired sort.
    (try-require 'dired-sort-map)

;;** (info "(emacs)Dired and Find")

    (leuven--section "30.16 (emacs)Dired and Find")

    ;; Search for files with names matching a wild card pattern and Dired the
    ;; output.
    (global-set-key (kbd "C-c 1") #'find-name-dired)
                                        ; Case insensitive if
                                        ; `read-file-name-completion-ignore-case'
                                        ; is non-nil.

    ;; `find-grep-dired' case insensitivity.
    (setq find-grep-options "-i -q")

    ;; Search for files with contents matching a wild card pattern and Dired the
    ;; output.
    (global-set-key (kbd "C-c 2") #'find-grep-dired)

;;** (info "(emacs)Wdired")

    (leuven--section "30.17 Editing the (emacs)Wdired Buffer")

    ;; Put a Dired buffer in a mode in which filenames are editable.
    (with-eval-after-load 'wdired

      ;; Permissions bits of the files are editable.
      (setq wdired-allow-to-change-permissions t))

;;** (info "(emacs)Image-Dired")

    (leuven--section "30.18 Viewing Image Thumbnails in Dired")

    ;; Use Dired to browse and manipulate your images.
    (with-eval-after-load 'image-dired
      ;; Maximum number of files to show before warning the user.
      (setq image-dired-show-all-from-dir-max-files 100)

      ;; Remove the button-like border around thumbnails for a cleaner look.
      (setq image-dired-thumb-relief 0)

      ;; Increase the margin around thumbnails for better visual separation.
      (setq image-dired-thumb-margin 4)

      ;; Set the size of thumbnails for better visibility or to save space.
      (setq image-dired-thumb-size 100))

;;** Dired Extra

    (leuven--section "30.XX (dired-x)Top")

    (require 'dired-x)                  ; with-eval-after-load "dired" ends here.

    (when lvn--cygwin-p
      (defun lvn--dired-jump-advice (orig-fun &rest args)
        "Ask for confirmation before jumping to a Dired buffer.

      This advice checks the buffer size and prompts for confirmation if the buffer
      size is 1,400,000 bytes or more. It helps prevent time-consuming operations.
      Consider using `C-x d' instead for better performance."
        (if (or (< (buffer-size) 1400000)
                (y-or-n-p "Proceed with this time-consuming operation?  Consider using `C-x d' instead..."))
            (apply orig-fun args)
          (message "[Operation cancelled]")))

      (advice-add 'dired-jump :around #'lvn--dired-jump-advice)))

;;** Diff-hl

  (leuven--section "30.XX Diff-hl")

  ;; Enable VC diff highlighting on the side of a Dired window.
  (with-eval-after-load 'diff-hl-autoloads
    (add-hook 'dired-mode-hook #'diff-hl-dired-mode))

)                                       ; Chapter 30 ends here.

;;* 31 The (info "(emacs)Calendar/Diary")

(leuven--chapter leuven-load-chapter-31-calendar-diary "31 The Calendar and the Diary"

;;** 31.1 (info "(emacs)Calendar Motion")

  (leuven--section "31.1 (emacs)Calendar Motion")

  ;; Years must be written in full.
  (setq diary-abbreviated-year-flag nil)

  ;; Set the style of calendar and diary dates to ISO (how to interpret the
  ;; dates).
  (setq calendar-date-style 'iso)

  ;; Week in the calendar begins on Monday.
  (setq calendar-week-start-day 1)

  ;; Mark all visible dates that have diary entries.
  (when (file-exists-p "~/diary")
    (setq calendar-mark-diary-entries-flag t))

  ;; Mark the current date (by changing its face) after generating a calendar,
  ;; if today's date is visible.
  (add-hook 'calendar-today-visible-hook #'calendar-mark-today)

;;** 31.2 (info "(emacs)Scroll Calendar")

  (leuven--section "31.2 (emacs)Scroll Calendar")

  ;; Fix foolish calendar-mode scrolling: swap scroll direction.
  (add-hook 'calendar-load-hook
            (lambda ()
              ;; Bind '>' to scroll left (past dates) in the calendar view.
              (define-key calendar-mode-map (kbd ">") #'calendar-scroll-left)
              ;; Bind '<' to scroll right (future dates) in the calendar view.
              (define-key calendar-mode-map (kbd "<") #'calendar-scroll-right)))

;;** 31.7 Times of (info "(emacs)Sunrise/Sunset")

  (leuven--section "31.7 Times of (emacs)Sunrise/Sunset")

  ;; ;; Calendar functions for solar events.
  ;; (with-eval-after-load 'solar
  ;;
  ;;   ;; Name of the calendar location.
  ;;   (setq calendar-location-name "Leuven, BE")
  ;;
  ;;   ;; Latitude of `calendar-location-name'.
  ;;   (setq calendar-latitude 50.88)
  ;;
  ;;   ;; Longitude of `calendar-location-name'.
  ;;   (setq calendar-longitude 4.70))

;;** 31.11 (info "(emacs)Appointments")

  (leuven--section "31.11 (emacs)Appointments")

  ;; Insinuate appt if `diary-file' exists.
  (if (file-readable-p "~/diary")
      (try-require 'appt)               ; Requires `diary-lib', which requires
                                        ; `diary-loaddefs'.
    (message "[Appointment reminders lib `appt' not loaded (no diary file found)]"))

  (with-eval-after-load 'appt

    ;; Send the first warning 60 minutes before an appointment.
    (setq appt-message-warning-time 60) ; [default: 12]

    ;; Warn every 15 minutes.
    (setq appt-display-interval 15)     ; [default: 3]

    ;; Display appointment reminders in a separate window.
    (setq appt-display-format 'window)

    ;; Show appointment reminders via desktop notifications or echo area.
    (defun lvn--appt-notify (mins-to-appt current-time notification-string)
      "Display an appointment reminder using desktop notifications or echo area.
    MINS-TO-APPT is the time in minutes until the appointment (converted to a list if scalar).
    CURRENT-TIME is the current timestamp (currently unused).
    NOTIFICATION-STRING is the message or list of messages to display."
      (let ((messages (if (listp notification-string)
                          notification-string
                        (list notification-string))))
        (dolist (msg messages)
          (if (and (display-graphic-p) (executable-find "notify-send"))
              (let ((escaped-msg (shell-quote-argument msg)))
                (shell-command
                 (format "notify-send -i /usr/share/icons/gnome/32x32/status/appointment-soon.png -t 1000 'Appointment' %s"
                         escaped-msg)))
            (message "[%s]" msg)
            (sit-for 1)))))

    ;; Set custom function to display appointment reminders in a window.
    (setq appt-disp-window-function #'lvn--appt-notify)

    ;; Turn appointment checking on (enable reminders).
    (when lvn-verbose-loading
      (message "[Enable appointment reminders...]"))
    (appt-activate 1)
    (when lvn-verbose-loading
      (message "[Enable appointment reminders... Done]"))

    ;; Enable appointment notification, several minutes beforehand.
    (add-hook 'diary-hook #'appt-make-list)

    (with-eval-after-load 'org-agenda
      ;; Keep your appointment list clean: if you delete an appointment from
      ;; your Org agenda file, delete the corresponding alert.
      (defun lvn--org-agenda-to-appt-advice (orig-fun &rest args)
        "Clear the existing `appt-time-msg-list' before calling `org-agenda-to-appt'."
        (setq appt-time-msg-list nil)
        (apply orig-fun args))

      (advice-add 'org-agenda-to-appt :around #'lvn--org-agenda-to-appt-advice)

      ;; Add today's appointments (found in `org-agenda-files') each time the
      ;; agenda buffer is (re)built.
      (add-hook 'org-agenda-finalize-hook #'org-agenda-to-appt)
                                        ;! Don't use the `org-agenda-mode-hook'
                                        ;! because the Org agenda files would be
                                        ;! opened once by `org-agenda-to-appt',
                                        ;! and then killed by
                                        ;! `org-release-buffers' (because
                                        ;! `org-agenda-to-appt' closes all the
                                        ;! files it opened itself -- as they
                                        ;! weren't already opened), to be
                                        ;! finally re-opened!
    )

    )                                   ; with-eval-after-load "appt" ends here.

;;** 31.15 (info "(emacs)Advanced Calendar/Diary Usage")

  (leuven--section "31.15 (emacs)Advanced Calendar/Diary Usage")

  ;; Get rid of some holidays.
  (setq holiday-general-holidays nil)   ; Too U.S.-centric holidays.
  (setq holiday-oriental-holidays nil)  ; Oriental holidays.
  (setq holiday-hebrew-holidays nil)    ; Religious holidays.
  (setq holiday-islamic-holidays nil)   ; Religious holidays.
  (setq holiday-bahai-holidays nil)     ; Baha'i holidays.
  (setq holiday-solar-holidays nil)     ; Sun-related holidays.

  ;; Mark dates of holidays in the calendar window.
  (setq calendar-mark-holidays-flag t)

  (defun leuven-insert-current-date (prefix)
    "Insert the current date in ISO format.
  With one PREFIX argument, add day of week.  With two PREFIX arguments, add day
  of week and time."
    (interactive "P")
    (let ((format (cond ((not prefix) "%Y-%m-%d")
                        ((equal prefix '(4)) "%Y-%m-%d %a")
                        ((equal prefix '(16)) "%Y-%m-%d %a %H:%M"))))
      (insert (format-time-string format))))

  (global-set-key (kbd "C-c .") #'leuven-insert-current-date)

;;* Calendar view framework on Emacs

  ;; Calendar view framework on Emacs.
  (with-eval-after-load 'calfw

    ;; Unicode characters.
    (setq cfw:fchar-junction ?╋
          cfw:fchar-vertical-line ?┃
          cfw:fchar-horizontal-line ?━
          cfw:fchar-left-junction ?┣
          cfw:fchar-right-junction ?┫
          cfw:fchar-top-junction ?┯
          cfw:fchar-top-left-corner ?┏
          cfw:fchar-top-right-corner ?┓))

  ;; Calendar view for org-agenda.
  (with-eval-after-load 'calfw-org

    ;; Remove some strings (tags and filenames) from item summary.
    (defun cfw:org-summary-format (item)
      "Format an item (How should it be displayed?)."
      (let* ((time (cfw:org-tp item 'time))
             (time-of-day (cfw:org-tp item 'time-of-day))
             (time-str (and time-of-day
                            (format "%02i:%02i "
                                    (/ time-of-day 100)
                                    (% time-of-day 100))))
             (category (cfw:org-tp item 'org-category))
             (tags (cfw:org-tp item 'tags))
             (marker (cfw:org-tp item 'org-marker))
             (buffer (and marker (marker-buffer marker)))
             (text (cfw:org-extract-summary item))
             (props (cfw:extract-text-props item 'face 'keymap)))
        (propertize
         (concat
          (if time-str (apply 'propertize time-str props)) text " "
          ;; (and buffer (buffer-name buffer))
          )
         'keymap cfw:org-text-keymap
         ;; Delete the display property, since displaying images will break our
         ;; table layout.
         'display nil))))

)                                       ; Chapter 31 ends here.

;;* 32 (info "(emacs)Sending Mail")

(leuven--chapter leuven-load-chapter-32-sending-mail "32 Sending Mail"

  ;; Full name of this user.
  (setq user-full-name "John Doe")

  ;; Full mailing address of this user
  ;; (used in MAIL envelope FROM, and to select the default personality ID).
  (setq user-mail-address "john.doe@example.com")

  ;; Sending mail.
  (setq send-mail-function 'smtpmail-send-it)

  ;; Default SMTP server (overriden by `smtpmail-smtp-server').
  (setq smtpmail-default-smtp-server "smtp")
                                        ; SMTP process must be running
                                        ; there... and it should be Google's own
                                        ; mail server for GMail user mail
                                        ; addresses...

  ;; ;; SMTP service port number.
  ;; (setq smtpmail-smtp-service 587)

)                                       ; Chapter 32 ends here.

;;* 34 (info "(emacs)Gnus")

(leuven--chapter leuven-load-chapter-34-gnus "34 Gnus"

  (global-set-key (kbd "C-c n")
                  (lambda ()
                    (interactive)
                    (lvn--switch-or-start 'gnus "*Group*")))

  ;; Directory beneath which additional per-user Gnus-specific files are placed.
  (setq gnus-directory "~/.gnus.d/")    ; Should end with a directory separator.

  ;; A newsreader for GNU Emacs.
  (with-eval-after-load 'gnus

    ;; Package to compose an outgoing mail (Message, with Gnus paraphernalia).
    (setq mail-user-agent 'gnus-user-agent)

    ;; Reading mail with Gnus.
    (setq read-mail-command 'gnus))

)                                       ; Chapter 34 ends here.

;;* 36 (info "(emacs)Document View")

(leuven--chapter leuven-load-chapter-36-document-view "36 Document Viewing"

  ;; View PDF/PostScript/DVI files in Emacs.

)                                       ; Chapter 36 ends here.

;;* 38 Running (info "(emacs)Shell") Commands from Emacs

(leuven--chapter leuven-load-chapter-38-shell "38 Running Shell Commands from Emacs"

  ;; Transform shell names to what they really are.
  (with-eval-after-load 'sh-script

    (add-to-list 'sh-alias-alist '(sh . bash)))

  ;; ;; Use shell from Cygwin/MinGW.
  ;; (setq shell-file-name "bash")
  ;; (setenv "SHELL" "/bin/bash")
  ;; (setq explicit-bash-args '("-i")) ; --noediting added in Emacs 24.4
  ;; (setq explicit-sh-args '("-i"))

;;** 38.1 Single Shell

  (leuven--section "38.1 Single Shell")

  ;; Force interactive behavior (to get my handy shell aliases).
  ;; FIXME Fix for Zsh (zsh:1: command not found: shopt)
  ;; (defun lvn--shell-command-advice (orig-fun &rest args)
  ;;   "Advice to source .bashrc and enable aliases before running shell commands."
  ;;   (let ((command (car args)))
  ;;     (setq command (concat "source ~/.bashrc; shopt -s -q expand_aliases;\n " command))
  ;;     (apply orig-fun command (cdr args))))
  ;;
  ;; (advice-add 'shell-command :around #'lvn--shell-command-advice)

  ;; ;; For single shell commands (= "the" reference).
  ;; (setq shell-file-name                 ; Must be in the `PATH'.
  ;;       (or (ignore-errors
  ;;             (file-name-nondirectory (or (executable-find "zsh")
  ;;                                         (executable-find "bash")
  ;;                                         (executable-find "sh"))))
  ;;           (when lvn--win32-p "cmdproxy.exe")))
  ;;
  ;; ;; Use `shell-file-name' as the default shell.
  ;; (setenv "SHELL" shell-file-name)
  ;;
  ;; ;; Switch used to have the shell execute its command line argument.
  ;; (setq shell-command-switch "-c")      ; `/c' did not work with XEmacs.

  ;; Quote process arguments to ensure correct parsing on Windows.
  (setq w32-quote-process-args t)

  ;; ;; Workaround for Cygwin when 'shell-file-name' is 'bash'.
  ;; (setq null-device "/dev/null"))

;;** 38.2 Interactive Subshell

  (leuven--section "38.2 Interactive Subshell")

  ;; ;; For the interactive (sub)shell (and AUCTeX compilation?).
  ;; (setq explicit-shell-file-name shell-file-name)

;;** 38.3 Shell Mode

  (leuven--section "38.3 Shell Mode")

  ;; General command-interpreter-in-a-buffer stuff (Shell, SQLi, Lisp, R,
  ;; Python, ...).
  ;; (try-require 'comint)
  ;; (with-eval-after-load 'comint

    ;; Comint prompt is read only.
    (setq comint-prompt-read-only t)    ; Text is read-only (in ESS)?

    ;; No duplicates in command history.
    (setq-default comint-input-ignoredups t)

    ;; Input to interpreter causes windows showing the buffer to scroll
    ;; (insert at the bottom).
    (setq-default comint-scroll-to-bottom-on-input t)

    ;; Output to interpreter causes windows showing the buffer to scroll
    ;; (add output at the bottom).
    (setq-default comint-move-point-for-output t)

    ;; Maximum size in lines for Comint buffers.
    (setq comint-buffer-maximum-size (* 5 1024))
                                        ; If the function
                                        ; `comint-truncate-buffer' is added to
                                        ; `comint-output-filter-functions'.

    ;; Strip `^M' characters.
    (add-to-list 'process-coding-system-alist
                 '("sh" . (undecided-dos . undecided-unix))) ; `es' process.
    (add-to-list 'process-coding-system-alist
                 '("bash" . (undecided-dos . undecided-unix)))
    (add-to-list 'process-coding-system-alist
                 '("zsh" . (undecided-dos . undecided-unix)))

    ;; Show completion list when ambiguous.
    (setq comint-completion-autolist t)

    (defun leuven-comint-clear-buffer ()
      "Clear the Comint buffer."
      (interactive)
      (let ((comint-buffer-maximum-size 0))
        (comint-truncate-buffer)))

    (with-eval-after-load 'comint
      (define-key comint-mode-map (kbd "C-c C-k") #'leuven-comint-clear-buffer))

;; )

;;** 38.4 Shell Prompts

  (leuven--section "38.4 Shell Prompts")

  ;; Regexp to match prompts in the inferior shell.
  (setq shell-prompt-pattern "^[^#$%>\n]*[#$%>] *")

  ;; Regexp to recognize prompts in the inferior process.
;;   (setq comint-prompt-regexp shell-prompt-pattern) ; Used as well by SQLi!
                                        ;! Only used if the variable
                                        ;! `comint-use-prompt-regexp' is non-nil.

;;** 38.5 Shell Command History

  (leuven--section "38.5 Shell Command History")

  (with-eval-after-load 'comint

    ;; Rejects short commands.
    (setq comint-input-filter
          (lambda (str)
            (and (not (string-match "\\`\\s *\\'" str))
                 (> (length str) 2))))    ; Ignore '!!' and kin.

    ;; Cycle backwards/forwards through input history.
    (define-key comint-mode-map
      (kbd "C-p") #'comint-previous-input) ; Shell.
    (define-key comint-mode-map
      (kbd "<up>") #'comint-previous-input) ; Shell + RStudio.
    (define-key comint-mode-map
      (kbd "C-n") #'comint-next-input)  ; Shell.
    (define-key comint-mode-map
      (kbd "<down>") #'comint-next-input) ; Shell + RStudio.

    ;; Search backwards/forwards through input history for match for current
    ;; input.
    (define-key comint-mode-map
      (kbd "M-p") #'comint-previous-matching-input-from-input) ; Shell.
    (define-key comint-mode-map
      (kbd "<C-up>") #'comint-previous-matching-input-from-input) ; RStudio.
    (define-key comint-mode-map
      (kbd "M-n") #'comint-next-matching-input-from-input) ; Shell.
    (define-key comint-mode-map
      (kbd "<C-down>") #'comint-next-matching-input-from-input) ; RStudio.

    (with-eval-after-load 'helm-autoloads
      ;; Use Helm to search `comint' history.
      (define-key comint-mode-map
        (kbd "C-c C-l") #'helm-comint-input-ring)))

;;** 38.6 Directory Tracking

  (leuven--section "38.6 Directory Tracking")

  (defun leuven--rename-buffer-to-curdir (&optional _string)
    "Change Shell buffer's name to current directory."
    (rename-buffer (concat "*shell " default-directory "*")))

  (add-hook 'shell-mode-hook
            (lambda ()
              (leuven--rename-buffer-to-curdir)
              (add-hook 'comint-output-filter-functions
                        #'leuven--rename-buffer-to-curdir nil t)))
                                        ; Local to Shell comint.

;;** 38.7 Options

  (leuven--section "38.7 Options")

  ;; Disable command echoing.
  (setq-default comint-process-echoes t) ; for Linux (not needed for Cygwin)

  (setenv "PAGER" "/usr/bin/cat")

;;** 38.9 Term Mode

  (leuven--section "38.9 Term Mode")

  ;; Managing multiple terminal buffers in Emacs
  ;; (and fixing some troubles of `term-mode': key bindings, etc.).

  ;; (with-eval-after-load 'multi-term-autoloads
  ;;
  ;;   ;; (global-set-key (kbd "C-c t") #'multi-term-next)
  ;;   (global-set-key (kbd "C-c T") #'multi-term)) ; Create a new one.

  (with-eval-after-load 'multi-term

    (setq multi-term-program shell-file-name))

  ;; ;; Run an inferior shell, with I/O through buffer `*shell*'.
  ;; (global-set-key
  ;;   (kbd "C-c !")
  ;;   (cond (lvn--win32-p 'shell)
  ;;         (t 'term)))

  ;; Toggle to and from the `*shell*' buffer.
  (global-set-key (kbd "C-!")
                  (lambda ()
                    (interactive)
                    (lvn--switch-or-start 'shell "*shell*")))

;;** 38.10 Remote Host Shell

  (leuven--section "38.10 Remote Host Shell")

  ;; Load ssh.el file.
  (add-to-list 'same-window-regexps "^\\*ssh-.*\\*\\(\\|<[0-9]+>\\)")
  (autoload 'ssh "ssh"
    "Open a network login connection via `ssh'." t)
    ;; This is to run ESS remotely on another computer in my own Emacs, or just
    ;; plain old reading remote files.

  ;; See http://emacs.1067599.n5.nabble.com/SSH-inside-Emacs-td225528.html
  ;; - plink (with `dumb' terminal option?) as interactive shell
  ;; - ssh -t -t user@host
  ;; - Cygwin'ized Emacs
  ;; - MSYS (MinGW)

;;* Proced

  ;; ;; Start Proced in a similar manner to Dired.
  ;; (global-set-key (kbd "C-x p") #'proced) ; Conflict with Bkmp.

  (with-eval-after-load 'proced

    ;; Current sort scheme for Proced listing.
    (setq-default proced-sort 'start)

    ;; Display of Proced buffer as process tree.
    (setq-default proced-tree-flag t))

)

;;* 39 (info "(emacs)Emacs Server")

(leuven--chapter leuven-load-chapter-39-emacs-server "39 Using Emacs as a Server"

  ;; Use Emacs as a server (with the `emacsclient' program).
  (unless noninteractive
    (with-eval-after-load 'idle-require
      (idle-require 'server)))          ; After init.

  (with-eval-after-load 'server
    ;; Start the Emacs server if it's not already (definitely) running.
    (unless (equal (server-running-p) t)
      (server-start))

    ;; Save file without confirmation before returning to the client.
    (defun lvn--server-edit-save-buffer-advice (proc)
      "Save current buffer before marking it as done if modified."
      (when (and server-buffer-clients (buffer-modified-p))
        (save-buffer)))

    (advice-add 'server-edit :before #'lvn--server-edit-save-buffer-advice))

)                                       ; Chapter 39 ends here.

;;* 40 (info "(emacs)Printing")

(leuven--chapter leuven-load-chapter-40-printing "40 Printing Hard Copies"

  ;; Print Emacs buffer on line printer
  ;; for {lpr,print}-{buffer,region}.
  (with-eval-after-load 'lpr

    ;; Name of program for printing a file.
    (setq lpr-command (executable-find "enscript"))
                                    ; TODO Install `enscript'.

    ;; List of strings to pass as extra options for the printer program.
    (setq lpr-switches (list "--font=Courier8"
                             "--header-font=Courier10"
                             (format "--header=%s" (buffer-name))))

    ;; Name of a printer to which data is sent for printing.
    (setq printer-name t))

  (defun leuven-ps-print-buffer-with-faces-query ()
    "Query user before printing the buffer."
    (interactive)
    (when (y-or-n-p "Are you sure you want to print this buffer? ")
      (ps-print-buffer-with-faces)))

  ;; Generate and print a PostScript image of the buffer.
  (when lvn--win32-p
    ;; Override `Print Screen' globally used as a hotkey by Windows.
    (w32-register-hot-key (kbd "<snapshot>"))
    (global-set-key
      (kbd "<snapshot>") #'leuven-ps-print-buffer-with-faces-query))

  ;; Print text from the buffer as PostScript.
  (with-eval-after-load 'ps-print

    (defvar leuven--print-program
      (cond (lvn--win32-p (executable-find "gsprint.exe"))
            (lvn--mac-p (executable-find "lp"))
            (t (executable-find "enscript")))
      "Path to the printing program.")
    (setq ps-lpr-command leuven--print-program)

    (lvn--validate-file-executable-p leuven--print-program)

    (if (and leuven--print-program (executable-find leuven--print-program))
        (progn
          ;; Use Ghostscript for printing PostScript files.
          (setq ps-printer-name t)      ; Adjusted to run Ghostscript.
          (setq ps-lpr-command leuven--print-program) ; Set Ghostscript as the command for printing.
          (setq ps-lpr-switches '("-query"))) ; Tell Ghostscript to query which printer to use.
      (progn
        ;; Default printer settings.
        (setq ps-printer-name "//PRINT-SERVER/Brother HL-4150CDN") ; Adjust this for your setup.
        (setq ps-lpr-command "")        ; No specific command for non-Ghostscript printing.
        (setq ps-lpr-switches '("raw")))) ; Use raw printing mode.

    ;; (setq ps-error-handler-message 'system)

    ;; Size of paper to format for.
    (setq ps-paper-type 'a4)
    (setq ps-warn-paper-type nil)

    ;; Print in portrait mode.
    (setq ps-landscape-mode nil)

    ;; (setq ps-print-control-characters nil)

    ;; Number of columns.
    (setq ps-number-of-columns 1)

    (setq ps-left-margin 40)
    (setq ps-right-margin 56)
    (setq ps-bottom-margin 22)
    (setq ps-top-margin 32)

    ;; Page layout: Header [file-name     2001-06-18 Mon]
    (setq ps-print-header-frame nil)    ; No box around the header.
    ;; See http://www.emacswiki.org/emacs/PsPrintPackage-23.
    (setq ps-header-frame-alist '((fore-color . "#CCCCCC")))
    (setq ps-header-lines 1)
    (setq ps-header-font-family 'Helvetica)
    ;; (setq ps-header-font-size 11)
    (setq ps-header-title-font-size 11)
    (defun ps-time-stamp-yyyy-mm-dd-aaa ()
      "Return date as \"yyyy-MM-dd ddd\" (ISO 8601 date + day of week)."
      (format-time-string "%Y-%m-%d %a"))
    (setq ps-right-header '(ps-time-stamp-yyyy-mm-dd-aaa))

    ;; Page layout: Footer [                         n/m]
    (setq ps-footer-offset 14)
    (setq ps-footer-line-pad .50)
    (setq ps-print-footer t)
    (setq ps-print-footer-frame nil)    ; No box around the footer.
    (setq ps-footer-frame-alist '((fore-color . "#666666")))
    (setq ps-footer-lines 1)
    (setq ps-footer-font-family 'Helvetica)
    (setq ps-footer-font-size 8)
    (setq ps-left-footer nil)
    (setq ps-right-footer (list "/pagenumberstring load")) ; Page n of m.

    (setq ps-font-family 'Courier)      ; See `ps-font-info-database'.
                                        ; Legitimate values include Courier,
                                        ; Helvetica, NewCenturySchlbk, Palatino
                                        ; and Times.

    ;; Font size, in points, for ordinary text, when generating PostScript.
    (setq ps-font-size 9.1)

    ;; Specify if face background should be used.
    (setq ps-use-face-background t)

    ;; Specify line spacing, in points, for ordinary text.
    (setq ps-line-spacing 3))

)                                       ; Chapter 40 ends here.

;;* 41 (info "(emacs)Sorting") Text

(leuven--chapter leuven-load-chapter-41-sorting "41 Sorting Text"

  ;; Key binding.
  (global-set-key (kbd "C-c ^") #'sort-lines)

  (defun lvn-sort-names-by-last-name ()
    "Sort lines in the region by last name (everything after the first space)."
    (interactive)
    (save-excursion
      (let ((region-text (buffer-substring (region-beginning) (region-end)))
            (lines nil))
        (setq lines (split-string region-text "\n" t))
        (setq lines
              (sort lines
                    (lambda (a b)
                      (let* ((last-name-a (car (last (split-string a))))
                             (last-name-b (car (last (split-string b)))))
                        (string< last-name-a last-name-b)))))
        (delete-region (region-beginning) (region-end))
        (insert (mapconcat 'identity lines "\n"))
        (insert "\n"))))

)                                       ; Chapter 41 ends here.

;;* 44 (info "(emacs)Saving Emacs Sessions")

(leuven--chapter leuven-load-chapter-44-saving-emacs-sessions "44 Saving Emacs Sessions"

  ;; Remember cursor position in each file.
  (save-place-mode 1)

)                                       ; Chapter 44 ends here.

;;* 46 (info "(emacs)Hyperlinking")

(leuven--chapter leuven-load-chapter-46-hyperlinking "46 Hyperlinking and Navigation Features"

  ;; Use proxy.
  (setq url-proxy-services              ;! Emacs expects just hostname and port
                                        ;! in `url-proxy-services', NOT prefixed
                                        ;! with "http://"
        `(("http"     . ,(getenv "http_proxy"))
          ("ftp"      . ,(getenv "http_proxy"))
          ("no_proxy" . "^.*example.com")))
          ;; Disable proxy for some hosts.

;;** Pass a URL to a WWW browser.

  (leuven--section "pass a URL to a WWW browser")

  ;; Configure the default browser behavior based on the platform.
  (setq browse-url-browser-function
        (cond ((or lvn--win32-p
                   lvn--wsl-p
                   lvn--cygwin-p)
               'browse-url-default-windows-browser)
              (lvn--mac-p
               'browse-url-default-macosx-browser)
              ((not (display-graphic-p)) ; Console.
               'eww-browse-url)
              (t                        ; Linux.
               'browse-url-generic)))

  ;; Determine the name of the browser program to be used by `browse-url-generic'.
  (setq browse-url-generic-program
        (or (executable-find "xdg-open")
            (executable-find "gnome-open")))
                                        ; Defer the choice to Xdg or Gnome if
                                        ; available.

  ;; When running in WSL, configure to run the Windows browser.
  (when lvn--wsl-p
    (setq browse-url-generic-program "/mnt/c/Windows/System32/cmd.exe")
    (setq browse-url-generic-args '("/c" "start"))
    (setq browse-url-browser-function #'browse-url-generic))

  (leuven--section "FFAP")

  (unless (locate-library "helm-autoloads")

    ;; Visit a file.
    (global-set-key (kbd "<f3>") #'find-file-at-point))

;;** Web search

  (leuven--section "Web search")

  (defun leuven-google-search-active-region-or-word-at-point ()
    "Create a Google search URL and send it to your web browser.
  If `transient-mark-mode' is non-nil and the mark is active, it defaults to the
  current region, else to the word at or before point."
    (interactive)
    (let ((query
           (if (use-region-p)
               (buffer-substring-no-properties (region-beginning) (region-end))
             (find-tag-default))))      ; or (current-word) for word at point?
      (browse-url
       (concat
        "http://www.google.com/search?q="
        (url-hexify-string query)))))

  (defun leuven-duckduckgo-search-active-region-or-word-at-point ()
    "Create a DuckDuckGo search URL and send it to your web browser.
  If `transient-mark-mode' is non-nil and the mark is active, it defaults to the
  current region, else to the word at or before point."
    (interactive)
    (let ((query
           (if (use-region-p)
               (buffer-substring-no-properties (region-beginning) (region-end))
             (find-tag-default))))      ; or (current-word) for word at point?
      (browse-url
       (concat
        "https://duckduckgo.com/?q="
        (url-hexify-string query)))))

  (global-set-key (kbd "C-c g G") #'leuven-google-search-active-region-or-word-at-point)
  (global-set-key (kbd "C-c g D") #'leuven-duckduckgo-search-active-region-or-word-at-point)

  ;; Emacs interface to Google Translate.
  (with-eval-after-load 'google-translate-autoloads

    ;; Translate a text using translation directions.
    (global-set-key (kbd "C-c T") #'google-translate-smooth-translate))

  ;; Just another UI to Google.
  (with-eval-after-load 'google-translate-smooth-ui

    ;; Translation directions.
    (setq google-translate-translation-directions-alist
          '(("fr" . "en") ("en" . "fr")
            ("fr" . "nl") ("nl" . "fr")
            ("fr" . "es") ("es" . "fr"))))

)                                       ; Chapter 46 ends here.

;;* 47 Other (info "(emacs)Amusements")

(leuven--chapter leuven-load-chapter-47-amusements "47 Other Amusements"

  ;; Define a default menu bar.
  (with-eval-after-load 'menu-bar

    ;; Get rid of the Games in the Tools menu.
    (define-key menu-bar-tools-menu [games] nil))

)                                       ; Chapter 47 ends here.

;;* 49 (info "(emacs)Customization")

(leuven--chapter leuven-load-chapter-49-customization "49 Customization"

  (ignore-errors
    ;; Load custom theme "Leuven" and enable it.
    (load-theme 'leuven t))

  ;; Color sort order for `list-colors-display'.
  (setq list-colors-sort '(rgb-dist . "#FFFFFF"))

;;** 49.3 (info "(emacs)Variables")

  (leuven--section "49.3 (emacs)Variables")

  ;; File local variables specifications are obeyed, without query --
  ;; RISKY!
  (setq enable-local-variables t)

  ;; Obey `eval' variables -- RISKY!
  (setq enable-local-eval t)

  ;; Record safe values for some local variables.
  (setq safe-local-variable-values
        '(
          ;; Tell AUCTeX that the current file is the master document.
          (TeX-master . t)

          ;; Specify auto-complete sources.
          (ac-sources . (ac-source-words-in-buffer ac-source-dictionary))

          ;; Initialize packages for flycheck-mode.
          (flycheck-emacs-lisp-initialize-packages . t)

          ;; Disable flycheck-mode by default.
          (flycheck-mode . nil)

          ;; Disable flyspell-mode by default.
          (flyspell-mode . -1)

          ;; Enable flyspell-mode by default.
          (flyspell-mode . 1)

          ;; Specifiy the dictionary to use for ispell.
          (ispell-local-dictionary . "american")

          ;; Specify the dictionary to use for ispell.
          (ispell-local-dictionary . "francais")

          ;; Set the column for tags in Org mode.
          (org-tags-column . -80)

          ;; Enable outline-minor-mode.
          (outline-minor-mode)

          ;; Set whitespace style options.
          (whitespace-style face tabs spaces trailing lines
                            space-before-tab::space newline indentation::space
                            empty space-after-tab::space space-mark tab-mark
                            newline-mark)
          ))

;;** 49.4 Customizing (info "(emacs)Key Bindings")

  (leuven--section "49.4 Customizing (emacs)Key Bindings")

  ;; Print the key bindings in a tabular form.
  (defun leuven-keytable (arg)
    "Print the key bindings in a tabular form."
    (interactive "sEnter a modifier string:")
    (with-output-to-temp-buffer "*Key table*"
      (let* ((i 0)
             (keys (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l"
                         "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x"
                         "y" "z" "<RET>" "<down>" "<up>" "<right>"
                         "<left>" "<home>" "<end>" "<f1>" "<f2>" "<f3>"
                         "<f4>" "<f5>" "<f6>" "<f7>" "<f8>" "<f9>"
                         "<f10>" "<f11>" "<f12>" "1" "2" "3" "4" "5" "6"
                         "7" "8" "9" "0" "`" "~" "!" "@" "#" "$" "%" "^"
                         "&" "*" "(" ")" "-" "_" "=" "+" "\\" "|" "{" "["
                         "]" "}" ";" "'" ":" "\"" "<" ">" "," "." "/" "?"
                         ))
             (n (length keys))
             (modifiers (list "" "S-" "C-" "M-" "M-C-"))
             (k))
        (or (string= arg "") (setq modifiers (list arg)))
        (setq k (length modifiers))
        (princ (format " %-10.10s |" "Key"))
        (let ((j 0))
          (while (< j k)
            (princ (format " %-28.28s |" (nth j modifiers)))
            (setq j (1+ j))))
        (princ "\n")
        (princ (format "_%-10.10s_|" "__________"))
        (let ((j 0))
          (while (< j k)
            (princ (format "_%-28.28s_|"
                           "_______________________________"))
            (setq j (1+ j))))
        (princ "\n")
        (while (< i n)
          (princ (format " %-10.10s |" (nth i keys)))
          (let ((j 0))
            (while (< j k)
              (let* ((binding
                      (key-binding (read-kbd-macro
                                    (concat (nth j modifiers)
                                            (nth i keys)))))
                     (binding-string "_"))
                (when binding
                  (if (eq binding 'self-insert-command)
                      (setq binding-string (concat "'" (nth i keys) "'"))
                    (setq binding-string (format "%s" binding))))
                (setq binding-string
                      (substring binding-string 0
                                 (min (length binding-string) 28)))
                (princ (format " %-28.28s |" binding-string))
                (setq j (1+ j)))))
          (princ "\n")
          (setq i (1+ i)))
        (princ (format "_%-10.10s_|" "__________"))
        (let ((j 0))
          (while (< j k)
            (princ (format "_%-28.28s_|"
                           "_______________________________"))
            (setq j (1+ j))))))
    (delete-window)
    (setq truncate-lines t))

)                                       ; Chapter 49 ends here.

;;* Emacs Display

(leuven--chapter leuven-load-chapter-XX-emacs-display "XX Emacs Display"

;;** (info "(elisp)Faces")

  (leuven--section "Faces")

  (defun leuven--merge-x-resources ()
    (let ((file (file-name-nondirectory (buffer-file-name))))
      (when (or (string= file ".Xdefaults")
                (string= file ".Xresources"))
        (start-process "xrdb" nil "xrdb" "-merge" (buffer-file-name))
        (message (format "[Merged %s into X resource database]" file)))))

  (add-hook 'after-save-hook #'leuven--merge-x-resources)

  ;; allow any scalable font
  (setq scalable-fonts-allowed t)

  ;; (global-set-key (kbd "C-+")            #'text-scale-increase)
  ;; (global-set-key (kbd "C--")            #'text-scale-decrease)
  (global-set-key (kbd "<C-wheel-up>")   #'text-scale-increase)
  (global-set-key (kbd "<C-wheel-down>") #'text-scale-decrease)

  ;; For Linux.
  (global-set-key (kbd "<C-mouse-4>")    #'text-scale-increase)
  (global-set-key (kbd "<C-mouse-5>")    #'text-scale-decrease)

)

;;* App G Emacs and (info "(emacs)Microsoft Windows/MS-DOS")

(leuven--chapter leuven-load-chapter-AppG-ms-dos "Appendix G Emacs and MS-DOS"

  ;; Divide key (needed in GNU Emacs for Windows).
  (global-set-key (kbd "<kp-divide>") (kbd "/"))

)                                       ; Chapter G ends here.

;; Recovery from Problems

;;* Reporting Bugs

(leuven--chapter leuven-load-chapter-99-debugging "99 Debugging"

  ;; Get the backtrace when uncaught errors occur.
  (setq debug-on-error nil)             ; Was set to `t' at beginning of file.

  ;; Hit `C-g' while it's frozen to get an Emacs Lisp backtrace.
  (setq debug-on-quit nil)              ; Was set to `t' at beginning of file.

  (setq debug-on-entry 'user-error))

;; (use-package ert
;;   :bind ("C-c e t" . ert-run-tests-interactively))

;; Stop timestamping messages post-initialization.
(when lvn-verbose-loading
  (advice-remove 'message #'lvn--add-timestamp-to-message))

(when lvn-verbose-loading
  (message "| Chapter | Time |")
  (message "|---------+------|")
  (dolist (el (nreverse leuven--load-times-list))
    (message el))
  (message "|---------+------|")
  (message "|         | =vsum(@-I..@-II) |"))

;; Compute and display the load time.
(let ((load-time (float-time (time-subtract (current-time) emacs-leuven--load-start-time))))
  (message "[Loaded %s in %.2f s]" load-file-name load-time))
(sit-for 0.5)

;; ;; (use-package dashboard
;; ;;   :if (< (length command-line-args) 2)
;; ;;   :preface
;;   (defun my/dashboard-banner ()
;;     "Sets a dashboard banner including information on package initialization
;;      time and garbage collections."
;;     (setq dashboard-banner-logo-title
;;           (format "Emacs ready in %.2f seconds with %d garbage collections."
;;                   (float-time
;;                    (time-subtract after-init-time before-init-time)) gcs-done)))
;;   ;; :init
;;   (add-hook 'emacs-startup-hook 'dashboard-refresh-buffer)
;;   (add-hook 'dashboard-mode-hook 'my/dashboard-banner)
;;   ;; :custom
;;   ;; (dashboard-startup-banner 'logo)
;;   ;; :config
;;   (dashboard-setup-startup-hook)
;; ;; )

;; Report Emacs startup time and GC status after full initialization.
(add-hook 'emacs-startup-hook
          (lambda ()
            (let ((init-time (string-to-number (emacs-init-time))))
              (message "[Emacs startup time: %.2f s; GC done: %S]"
                       init-time gcs-done)
              (sit-for 0.5)))
          t)

  (defun lvn-update-emacs-leuven-configuration ()
    "Update the Leuven configuration for Emacs to its latest version.

This function checks for unstaged changes in the Emacs-Leuven configuration repository.
If there are unstaged changes, it recommends committing or stashing them before updating.
If updates are available, it pulls the latest changes from the repository.
If the configuration is already up-to-date, it displays a message indicating so.
After the update, it recommends restarting Emacs to complete the update.

Before using this function, make sure 'lvn--directory' points to the
directory containing 'emacs-leuven.el' or a symbolic link to the actual
Git repository directory."
    (interactive)
    (lvn-display-emacs-leuven-version)
    (let* ((el-file-path (locate-library "emacs-leuven.el"))
           (el-file-directory (file-name-directory (file-truename el-file-path)))
           (repository-directory el-file-directory)
           (unstaged-changes (shell-command-to-string "cd %s && git status --porcelain"))
           (status-buffer (generate-new-buffer "*git-status*")))
      (if (file-directory-p repository-directory)
          (progn
            (if (not (string-empty-p unstaged-changes))
                (progn
                  (warn "You have unstaged changes. Please commit or stash them before updating.")
                  (message "[Unstaged changes:\n%s]" unstaged-changes))
              (let ((status (shell-command (format "cd %s && LC_ALL=C git pull --rebase" el-file-directory))))
                (if (string-match-p "\\(up to date\\|up-to-date\\)" (buffer-string))
                    (message "[Configuration is already up-to-date]")
                  (if (= status 0)
                      (progn
                        (sit-for 1.5)
                        (message "[Configuration updated.  Please restart Emacs to complete the update]"))
                    (warn "Error: Failed to update configuration"))))))
        (message "[Error: 'emacs-leuven.el' file not found]"))
      (kill-buffer status-buffer)))

  (defun lvn-display-emacs-leuven-latest-commits ()
    "Display the latest commits in the Emacs-Leuven configuration.

This function fetches the latest changes from the remote Git repository and
displays the commits made since the current branch diverged from 'origin'. If
the configuration is already up-to-date, it indicates so in the message.

Before using this function, make sure 'lvn--directory' points to the
directory containing 'emacs-leuven.el' or a symbolic link to the actual
Git repository directory."
    (interactive)
    (lvn-display-emacs-leuven-version)
    (message "[Fetching latest changes in Emacs-Leuven...]")
    (let* ((el-file-path (locate-library "emacs-leuven.el"))
           (el-file-directory (file-name-directory (file-truename el-file-path)))
           (default-directory el-file-directory)
           (fetch-status (shell-command "LC_ALL=C git fetch --verbose"))
           (commits-buffer "*Emacs-Leuven latest commits*"))
      (if (string-match "\\(up to date\\|up-to-date\\)" (shell-command-to-string "LC_ALL=C git status"))
          (message "[Configuration already up-to-date]")
        (with-output-to-temp-buffer commits-buffer
          (shell-command "LC_ALL=C git log --pretty=format:'%h %ad %s' --date=short HEAD..origin" commits-buffer)
          (pop-to-buffer commits-buffer)))))

  (defun lvn-display-emacs-leuven-version ()
    "Display the current version of the Emacs-Leuven configuration."
    (interactive)
    (message (format "[Emacs-Leuven version %s]" lvn--emacs-version)))

(message "* --[ Loaded Emacs-Leuven %s]--" lvn--emacs-version)

(provide 'emacs-leuven)

;;; emacs-leuven.el ends here
