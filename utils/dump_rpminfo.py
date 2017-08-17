#!/usr/bin/python
import json
import shutil
import tempfile

import yum

tags = ['os', 'atomic']
release = '7.3.1611'
arch = 'x86_64'
baseurl = "http://mirror.easystack.io/ESCL/"
fn = 'escore/rpms.json'


def setup_repo(repoid, cache=None):
    url = "{}/{}/{}/{}".format(baseurl, release, repoid, arch)

    newrepo = yum.yumRepo.YumRepository(repoid)
    newrepo.name = repoid
    newrepo.baseurl = [url]
    if cache:
        newrepo.basecachedir = cache
    return newrepo


def fetch_rpms(repo):
    specs = []
    yb = yum.YumBase()
    yb.repos.disableRepo('*')
    yb.repos.add(repo)
    yb.repos.enableRepo(repo.name)
    yb.doRepoSetup(thisrepo=repo.name)
    for pkg in yb.pkgSack.returnPackages():
        spkg = pkg.sourcerpm.split('-{}-'.format(pkg.version))[0]
        spec = {
            'package': str(pkg),
            'name': pkg.name,
            'base_package_name': pkg.base_package_name,
            'dist': repo.name,
            'release': release,
            'srpm': pkg.sourcerpm,
            'version': pkg.version,
            'epoch': pkg.epoch
        }
        if spec not in specs:
            specs.append(spec)
    return specs

specs = []
for tag in tags:
    cache = tempfile.mkdtemp()
    repo = setup_repo(tag, cache)
    specs.extend(fetch_rpms(repo))
    shutil.rmtree(cache)

with open(fn, 'w') as outfile:
    json.dump(specs, outfile, indent=2)
