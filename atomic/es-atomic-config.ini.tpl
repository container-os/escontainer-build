[DEFAULT]

outputdir   =
# workdir     = 
# srcdir      = os.path.join(os.path.dirname(sys.argv[0], '..')
os_name     = {{ OSTREE_REPO_NAME }}
os_pretty_name = Easystack Atomic Host
docker_os_name = es-atomic/escore-lite-builder
tree_name   = standard
tree_file   = es-atomic-host.json
is_final    = True
arch        = {{ ARCH }}
release     = {{ ECS_VER }}
ref         = %(os_name)s/%(release)s/%(arch)s/%(tree_name)s

lorax_include_packages = escore-release ostree
lorax_exclude_packages = oscap-anaconda-addon

# Base repository
yum_baseurl = http://mirror.easystack.cn/kojifiles/repos/ecs-atomic/latest/{{ ARCH }}

# Repositories above and beyond yum_baseurl that lorax can use to compose ISO content.
# These need to be provides in a comma separated list.
lorax_additional_repos = http://escore:escore@mirror.easystack.cn/mirrors/epel/{{ CENTOS_VER }}/{{ ARCH }}

vsphere_product_name = ESCore Lite Host
vsphere_product_vendor_name = The ESCore Project
vsphere_product_version = {{ ECS_VER }}

[{{ ECS_VER }}]
