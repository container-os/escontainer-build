##@ostree please run ostree related commands with sudo
##@ostree_prepare those commands would called by make <ostree> (For DEBUG)

# Common variable

OSTREE_REPO ?= /srv/ostree
OSTREE_REPO_NAME ?= es-atomic-host
OSTREE_BUILD_SCRIPTS_DIR ?= /srv/escore-build/atomic
OSTREE_REPO_REF ?= $(DEFAULT_OSTREE_REPO_REF)
OSTREE_SERV_HOST ?= 192.168.122.1
OSTREE_SERV_PORT ?= 11887

FORCE_COMPOSE ?= no

DATE = $(shell date +%y%m%d)
ifneq ($(wildcard ${OSTREE_REPO}/disk_${DATE}-[0-9][0-9]),)
LAST_BUILD_NUM = $(shell ls -d ${OSTREE_REPO}/disk_${DATE}-[0-9][0-9] | sort -rn |head -n 1 | cut -d'-' -f 2)
else
LAST_BUILD_NUM = 00
endif
NEXT_BUILD_NUM = $(shell printf %02d `expr ${LAST_BUILD_NUM} + 1`)


# Status
OSTREE_INSTALLED = $(shell ostree --help > /dev/null 2>&1  && echo "yes" || echo "no")
ifeq (yes,$(OSTREE_INSTALLED))
RPM_OSTREE_INSTALLED = $(shell rpm-ostree --help > /dev/null 2>&1  && echo "yes" || echo "no")
RPM_OSTREE_TOOLBOX_INSTALLED = $(shell rpm-ostree-toolbox > /dev/null 2>&1  && echo "yes" || echo "no")

OSTREE_REPO_CREATED = $(shell test -e ${OSTREE_REPO} && echo "yes" || echo "no")
OSTREE_REPO_SERVICE_PORT_USED = $(shell utils/check_port.py --host ${OSTREE_SERV_HOST} --port ${OSTREE_SERV_PORT})
OSTREE_REPO_SERVICE_STARTED = $(shell utils/check_port.py --host ${OSTREE_SERV_HOST} --port ${OSTREE_SERV_PORT})
endif


JSON_FILE = $(SEED)/es_${DATE}-${NEXT_BUILD_NUM}.json


env_check:	##@ostree_prepare check current package version
ifneq (0,$(UID))
	$(error Please run ostree related commands as root)
endif
ifeq (no,$(RPM_OSTREE_TOOLBOX_INSTALLED))
	$(warning rpm-ostree-toolbox is not installed, only can create ostree repo)
endif
ifeq (no,$(OSTREE_INSTALLED))
	@make env_prepare
endif

env_prepare:  ##@ostree_prepare install ostree related packages
	yum install -y yum-utils
	yum-config-manager --add-repo http://buildlogs.centos.org/centos/7/atomic/x86_64/Packages
	yum-config-manager --add-repo http://cbs.centos.org/repos/atomic7-testing/x86_64/os
	yum-config-manager --disable cbs.centos.org_repos_atomic7-testing_x86_64_os_
	yum install -y rpm-ostree
	yum install -y rpm-ostree-toolbox --enablerepo=cbs.centos.org_repos_atomic7-testing_x86_64_os_ --nogpgcheck

repo_init: env_check  ##@ostree_prepare repo_init
ifeq (no,$(OSTREE_REPO_CREATED))
	@mkdir -p ${OSTREE_REPO}
	ostree --repo=${OSTREE_REPO}/${OSTREE_REPO_NAME} init --mode=archive-z2
endif
ifneq (0,$(SUDO_UID))
	@chown $(SUDO_UID):$(SUDO_GID) $(OSTREE_REPO)
endif

$(JSON_FILE): $(SEED)
ifneq ($(DEFAULT_OSTREE_REPO_REF),$(OSTREE_REPO_REF))
	@python -c 'import json; old=json.load(open("$(OSTREE_BUILD_SCRIPTS_DIR)/es-default.json")); old["ref"]="${OSTREE_REPO_REF}"; print(json.dumps(old, indent=2, sort_keys=True))' > $(JSON_FILE)
	@echo repo_ref: $(OSTREE_REPO_REF)
else
	@cp $(OSTREE_BUILD_SCRIPTS_DIR)/es-default.json $(JSON_FILE)
endif
ifneq (0,$(SUDO_UID))
	@chown -R $(SUDO_UID):$(SUDO_GID) $(JSON_FILE)
endif
	@echo repo_json: $(JSON_FILE)
	@cd $(OSTREE_BUILD_SCRIPTS_DIR); ln -s -f ../$(JSON_FILE) es-atomic-host.json

json:  ##@ostree_prepare force generate json
	rm -f $(JSON_FILE)
	make $(JSON_FILE)

http_service: env_check  ##@ostree_prepare httpd
ifeq (no,$(OSTREE_REPO_SERVICE_STARTED))
	ostree trivial-httpd -P ${OSTREE_SERV_PORT} ${OSTREE_REPO}/${OSTREE_REPO_NAME} & echo "$$!" > ${OSTREE_REPO}/trivial-httpd.pid
else
	$(warning ostree service started)
endif

http_service_stop: env_check  ##@ostree_prepare stop httpd
	@kill -9 `cat ${OSTREE_REPO}/trivial-httpd.pid`
	@rm ${OSTREE_REPO}/trivial-httpd.pid

compose: $(JSON_FILE) repo_init ##@ostree compose repo
	@cd $(OSTREE_BUILD_SCRIPTS_DIR); rpm-ostree compose tree --repo ${OSTREE_REPO}/${OSTREE_REPO_NAME} es-atomic-host.json $(ARGS)

image: IMGDIR=${OSTREE_REPO}/disk_${DATE}-${NEXT_BUILD_NUM}
image: $(JSON_FILE) repo_init http_service  ##@ostree create image, IMGDIR is for identify output dir. exmaple: IMGDIR=/tmp/abc sudo make image)
ifneq (no,$(FORCE_COMPOSE))
	make -s compose
endif
	make -s http_service
	cd /tmp; rpm-ostree-toolbox imagefactory -c ${OSTREE_BUILD_SCRIPTS_DIR}/es-atomic-config.ini -i kvm --ostreerepo ${OSTREE_REPO}/${OSTREE_REPO_NAME} -o ${IMGDIR} --no-compression
	make -s http_service_stop
	@echo IMGDIR: ${IMGDIR}
ifneq (0,$(SUDO_UID))
	@chown -R $(SUDO_UID):$(SUDO_GID) $(IMGDIR)
endif

image_gz: IMGDIR=${OSTREE_REPO}/disk_${DATE}-${LAST_BUILD_NUM}
image_gz: env_check  ##@ostree create image gz file, need run after make image
ifeq (00,$(LAST_BUILD_NUM))
	$(error can not found built image, please run make image to create it)
endif
	gzip ${IMGDIR}/images/*.qcow2
	cd ${IMGDIR}/images/; /bin/sh -c "find .  -type f | grep -v '.*SUMS$'' | xargs sha256sum" > SHA256SUMS

sign: GPGKEY?=00
sign:  ##@ostree sign, GPGKEY=<> make sign
ifeq (00,$(GPGKEY))
	$(error can not found gpg key)
endif
	ostree gpg-sign --repo ${OSTREE_REPO}/${OSTREE_REPO_NAME} es-atomic-host/7/x86_64/standard $(GPGKEY)
