;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((cperl-mode
  (eval . (progn
	    (make-local-variable 'compilation-environment)
	    (add-to-list 'compilation-environment (concat "PERL5LIB=" (expand-file-name "lib" (repository-root default-directory))))))))
				 
