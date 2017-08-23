ifeq (yes,$(shell test -e envrc && echo "yes" || echo "no"))
    include envrc
else
    $(warning envrc not found. help: copy envrc.example and edit it)
endif

include utils/help.mk
ifeq (yes,$(shell test -e /usr/bin/git && test -d .git && echo "yes" || echo "no"))
    include utils/packaging.mk
endif
include utils/escore.mk
include utils/atomic.mk
