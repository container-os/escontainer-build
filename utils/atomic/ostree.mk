##@atomic please run ostree related commands with sudo
##@atomic_prepare those commands would called by make <ostree> (For DEBUG)

atomic_env_check:  ##@atomic_prepare check current package version
ifneq (0,$(UID))
	$(error Please run ostree related commands as root)
endif
ifeq (no,$(RPM_OSTREE_TOOLBOX_INSTALLED))
	$(warning rpm-ostree-toolbox is not installed, only can create ostree repo)
endif
ifeq (no,$(OSTREE_INSTALLED))
	@make atomic_env_prepare
endif

atomic_generate_tpl:  ##@atomic_prepare use envtpl.py to generate files
	@find atomic/ -name *.tpl -exec ./utils/envtpl.py --keep-template {} \;

atomic_env_prepare: atomic_generate_tpl  ##@atomic_prepare install ostree related packages
	yum install -y yum-utils
	yum-config-manager --add-repo http://buildlogs.centos.org/centos/7/atomic/x86_64/Packages
	yum-config-manager --add-repo http://cbs.centos.org/repos/atomic7-testing/x86_64/os
	yum-config-manager --disable cbs.centos.org_repos_atomic7-testing_x86_64_os_
	yum install -y rpm-ostree
	yum install -y rpm-ostree-toolbox --enablerepo=cbs.centos.org_repos_atomic7-testing_x86_64_os_ --nogpgcheck

atomic_repo_init: atomic_env_check  ##@atomic_prepare repo_init
ifeq (no,$(OSTREE_REPO_CREATED))
	@mkdir -p ${OSTREE_REPO}
	ostree --repo=${OSTREE_REPO}/${OSTREE_REPO_NAME} init --mode=archive-z2
endif
ifneq (0,$(SUDO_UID))
	@chown $(SUDO_UID):$(SUDO_GID) $(OSTREE_REPO)
endif

$(JSON_FILE): $(OSTREE_BUILD_SCRIPTS_DIR)/es-default.json
	mkdir -p $(OSTREE_IMGDIR)/seed
ifneq ($(DEFAULT_OSTREE_REPO_REF),$(OSTREE_REPO_REF))
	@python -c 'import json; old=json.load(open("$(OSTREE_BUILD_SCRIPTS_DIR)/es-default.json")); old["ref"]="${OSTREE_REPO_REF}"; print(json.dumps(old, indent=2, sort_keys=True))' > $(JSON_FILE)
	@echo repo_ref: $(OSTREE_REPO_REF)
else
	@cp $(OSTREE_BUILD_SCRIPTS_DIR)/es-default.json $(JSON_FILE)
endif
ifneq (0,$(SUDO_UID))
	@chown -R $(SUDO_UID):$(SUDO_GID) $(OSTREE_IMGDIR)/seed
endif
	@echo repo_json: $(JSON_FILE)
	@cd $(OSTREE_BUILD_SCRIPTS_DIR); ln -s -f $(JSON_FILE) es-atomic-host.json

atomic_httpd: atomic_env_check  ##@atomic_prepare httpd
ifeq (yes,$(OSTREE_REPO_SERVICE_IS_LOCAL))
ifeq (no,$(OSTREE_REPO_SERVICE_STARTED))
	/usr/libexec/libostree/ostree-trivial-httpd -P ${OSTREE_SERV_PORT} ${OSTREE_REPO}/${OSTREE_REPO_NAME} & echo "$$!" > ${OSTREE_REPO}/trivial-httpd.pid
else
	$(warning ostree service started)
endif
endif
ifeq (no,$(OSTREE_REPO_SERVICE_IS_LOCAL))
ifeq (no,$(OSTREE_REPO_SERVICE_STARTED))
	$(error remote ostree service does not started)
else
	$(warning remote ostree service started)
endif
endif

atomic_httpd_stop: atomic_env_check  ##@atomic_prepare stop httpd
	@kill -9 `cat ${OSTREE_REPO}/trivial-httpd.pid`
	@rm ${OSTREE_REPO}/trivial-httpd.pid

atomic_compose: atomic_generate_tpl $(JSON_FILE) atomic_repo_init ##@atomic compose repo
	@cd $(OSTREE_BUILD_SCRIPTS_DIR); rpm-ostree compose tree --repo ${OSTREE_REPO}/${OSTREE_REPO_NAME} es-atomic-host.json $(ARGS)
	ostree gpg-sign --gpg-homedir=${OSTREE_GPG_HOMEDIR} --repo=${OSTREE_REPO}/${OSTREE_REPO_NAME} $(OSTREE_REPO_REF) $(OSTREE_SIGN_UID)
	ostree summary -u --repo=${OSTREE_REPO}/${OSTREE_REPO_NAME} $(OSTREE_REPO_REF)

atomic_call:
	echo "ostree summary -u --repo=${OSTREE_REPO}/${OSTREE_REPO_NAME} $(OSTREE_REPO_REF)"

atomic_summary:
	ostree summary -u --repo=${OSTREE_REPO}/${OSTREE_REPO_NAME} $(OSTREE_REPO_REF)

atomic_image: atomic_generate_tpl atomic_repo_init atomic_httpd  ##@atomic create image
ifeq (00,$(LAST_BUILD_NUM))
	$(error make atomic_prepare_image_dir first)
endif
ifeq (yes,$(shell test -e ${OSTREE_IMGDIR}/images && echo "yes" || echo "no"))
	$(error image existed, make atomic_prepare_image_dir)
endif
	make -s $(JSON_FILE)
ifneq (no,$(FORCE_COMPOSE))
	make -s atomic_compose
endif
ifeq (yes,$(OSTREE_REPO_SERVICE_IS_LOCAL))
	cd /tmp; rpm-ostree-toolbox imagefactory -c ${OSTREE_BUILD_SCRIPTS_DIR}/es-atomic-config.ini -k ${OSTREE_BUILD_SCRIPTS_DIR}/es-atomic-host-7.ks --tdl ${OSTREE_BUILD_SCRIPTS_DIR}/es-atomic-host-7.tdl -i kvm --ostreerepo ${OSTREE_REPO}/${OSTREE_REPO_NAME} -o ${OSTREE_IMGDIR} --no-compression --overwrite
ifeq (no,$(OSTREE_REPO_SERVICE_STARTED))
	make -s atomic_httpd_stop
endif
else
	cd /tmp; rpm-ostree-toolbox imagefactory -c ${OSTREE_BUILD_SCRIPTS_DIR}/es-atomic-config.ini -k ${OSTREE_BUILD_SCRIPTS_DIR}/es-atomic-host-7.ks --tdl ${OSTREE_BUILD_SCRIPTS_DIR}/es-atomic-host-7.tdl -i kvm --ostreerepo http://${OSTREE_SERV_HOST}:${OSTREE_SERV_PORT} -o ${OSTREE_IMGDIR} --no-compression --overwrite
endif
	@echo OSTREE_IMGDIR: ${OSTREE_IMGDIR}
ifneq (0,$(SUDO_UID))
	@chown -R $(SUDO_UID):$(SUDO_GID) $(OSTREE_IMGDIR)
endif
	@echo "glance image-create --name es-atomic-host-7_$(DATE)-$(NEXT_BUILD_NUM) --visibility public --disk-format qcow2 --container-format bare < $(OSTREE_IMGDIR)/images/es-atomic-host-7.qcow2"

atomic_glance:
	@echo "glance image-create --name es-atomic-host-7_$(DATE)-$(NEXT_BUILD_NUM) --visibility public --disk-format qcow2 < $(OSTREE_IMGDIR)/images/es-atomic-host-7.qcow2"

atomic_image_gz: atomic_env_check  ##@atomic create image gz file, need run after make image
ifeq (00,$(LAST_BUILD_NUM))
	$(error can not found built image, please run make image to create it)
endif
	gzip ${OSTREE_IMGDIR}/images/*.qcow2
	cd ${OSTREE_IMGDIR}/images/; /bin/sh -c "find .  -type f | grep -v '.*SUMS$'' | xargs sha256sum" > SHA256SUMS

atomic_sign: GPGKEY?=00
atomic_sign:  ##@atomic sign, GPGKEY=<> make atomic_sign
ifeq (00,$(GPGKEY))
	$(error can not found gpg key)
endif
	ostree gpg-sign --repo ${OSTREE_REPO}/${OSTREE_REPO_NAME} es-atomic-host/7/x86_64/standard $(GPGKEY)
