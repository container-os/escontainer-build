# Common variable

DEFAULT_OSTREE_REPO_REF = es-atomic-host/7/x86_64/standard
DEFAULT_HOST = es-atomic-host

OSTREE_REPO ?= /srv/ostree
OSTREE_REPO_NAME ?= es-atomic-host
OSTREE_BUILD_SCRIPTS_DIR ?= $(shell pwd)/atomic
OSTREE_REPO_REF ?= $(DEFAULT_OSTREE_REPO_REF)
OSTREE_SERV_HOST ?= 192.168.122.1
OSTREE_SERV_PORT ?= 11887
ESCLOUD_VER ?= 7.4.1708
ANACONDA_LIVECD ?= http://escore:escore@mirror.easystack.io/ESCL/7.4.1708/atomic/atomic-anaconda/
FORCE_COMPOSE ?= no

export

OSTREE_BASE_IMGDIR = $(OSTREE_REPO)/$(OSTREE_REPO_NAME)/images

DATE = $(shell date +%y%m%d)
ifneq ($(wildcard ${OSTREE_BASE_IMGDIR}/disk_${DATE}-[0-9][0-9]),)
LAST_BUILD_NUM = $(shell ls -d ${OSTREE_BASE_IMGDIR}/disk_${DATE}-[0-9][0-9] | sort -rn |head -n 1 | xargs basename | cut -d'-' -f 2)
else
LAST_BUILD_NUM = 00
endif
NEXT_BUILD_NUM = $(shell printf %02d `expr ${LAST_BUILD_NUM} + 1`)

OSTREE_IMGDIR = $(OSTREE_BASE_IMGDIR)/disk_$(DATE)-$(LAST_BUILD_NUM)
OSTREE_NEXT_IMGDIR = $(OSTREE_BASE_IMGDIR)/disk_$(DATE)-$(NEXT_BUILD_NUM)

# Status
OSTREE_INSTALLED = $(shell ostree --help > /dev/null 2>&1  && echo "yes" || echo "no")
ifeq (yes,$(OSTREE_INSTALLED))
RPM_OSTREE_INSTALLED = $(shell rpm-ostree --help > /dev/null 2>&1  && echo "yes" || echo "no")
RPM_OSTREE_TOOLBOX_INSTALLED = $(shell rpm-ostree-toolbox > /dev/null 2>&1  && echo "yes" || echo "no")

OSTREE_REPO_CREATED = $(shell test -e ${OSTREE_REPO}/${OSTREE_REPO_NAME} && echo "yes" || echo "no")
OSTREE_REPO_SERVICE_PORT_USED = $(shell utils/check_port.py --host ${OSTREE_SERV_HOST} --port ${OSTREE_SERV_PORT})
OSTREE_REPO_SERVICE_STARTED = $(shell utils/check_port.py --host ${OSTREE_SERV_HOST} --port ${OSTREE_SERV_PORT})
OSTREE_REPO_SERVICE_IS_LOCAL = $(shell utils/check_ip.py --host ${OSTREE_SERV_HOST})
endif

JSON_FILE = $(OSTREE_IMGDIR)/seed/atomic.json

include utils/atomic/ostree.mk
include utils/atomic/vm.mk

atomic_json:  ##@atomic_debug force generate json
	rm -f $(JSON_FILE)
	make $(JSON_FILE)

atomic_seed:  ##@atomic_debug force generate seed
	rm -f $(SEED_ISO) $(USER_DATA) $(META_DATA)
	make $(SEED_ISO)
