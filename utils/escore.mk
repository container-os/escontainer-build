##@escore The iso build process is based on lorax to build escore iso/repo

ESCORE_BASE_DIR = escore
COMMON_CFG = $(ESCORE_BASE_DIR)/common.sh

$(COMMON_CFG):
	cd $(ESCORE_BASE_DIR); ./setup.sh

escore_iso: $(COMMON_CFG)  ##@escore Build ESCore iso image.
	cd $(ESCORE_BASE_DIR); ./build_iso.sh

escore_repos: $(COMMON_CFG)  ##@escore Create easystack repository for mock / installer / iso environment. One must migrate the result repos to the server for the httpd services.
	cd $(ESCORE_BASE_DIR); ./make_repos.sh

escore_clean:  ##@escore cleanup mock cache and all the stuff we created.
	cd $(ESCORE_BASE_DIR); ./clean.sh

escore_shell: $(COMMON_CFG)  ##@escore Enter mock environment if one would like to try some commands.
	cd $(ESCORE_BASE_DIR); ./shell.sh
