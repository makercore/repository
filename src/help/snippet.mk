################################################################################
# Static user variables
################################################################################

#+ target documentation marker
HELP_MARKER_TARGET ?= \#=
#+ variable documentation marker
HELP_MARKER_VAR ?= \#+

################################################################################
# Internal variables
################################################################################
HELP_FS := $(shell printf "\034")

################################################################################
# Phony rules
################################################################################
help-targets: #= show target help
	@grep -hE "^\S+:.*$(HELP_MARKER_TARGET)" $(MAKEFILE_LIST) | sed -e 's/\\$$//' | sed -e 's/:.*$(HELP_MARKER_TARGET)[ ]*/$(HELP_FS)/' | column -c2 -t -s$(HELP_FS)

help-variables: #= show variable help
	@grep -A 1 -hE "^#\+" $(MAKEFILE_LIST) | \
		awk '\
		BEGIN{RS="\n--\n";FS=""} \
		/.*\n.*\?=.*/ {$$0 = gensub(/^#\+[ ]*([^\n]*)\n(\w+)[ ]*\?=[ ]*([^\r\n]*)/,"\\2$(HELP_FS)\\1 (default \"\\3\")", "g", $$0);print}\
		' | column -c2 -t -s$(HELP_FS)
