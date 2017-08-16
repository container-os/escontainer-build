ifeq (yes,$(shell test -e envrc && echo "yes" || echo "no"))
    include envrc
    export
else
    $(warning envrc not found. help: copy envrc.example and edit it)
endif

include utils/help.mk
include utils/packaging.mk
include utils/escore.mk
include utils/atomic.mk
