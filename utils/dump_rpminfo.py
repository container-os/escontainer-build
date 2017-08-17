#!/usr/bin/python
import argparse
import json
import shutil
import tempfile

import yum

release = '7.3.1611'
arch = 'x86_64'
baseurl = "http://mirror.easystack.io/ESCL/"


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

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument('tags', metavar='repo', nargs='*',
                        default=['os', 'atomic'], 
                        help='repo tag to dump rpms data')
    parser.add_argument('--cache',  help='cache dir')
    parser.add_argument('--output', '-o', default='escore/rpms.json')
    args = parser.parse_args()

    specs = []
    for tag in args.tags:
        if args.cache:
            cache = args.cache
        else:
            cache = tempfile.mkdtemp()
        repo = setup_repo(tag, cache)
        specs.extend(fetch_rpms(repo))
        if not args.cache:
            shutil.rmtree(cache)

    with open(args.output, 'w') as outfile:
        json.dump(specs, outfile, indent=2)
