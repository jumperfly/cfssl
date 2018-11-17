#!/bin/bash

IFS='_' read -r -a fullver <<< $1
export RPM_RELEASE=${fullver[1]}
export RPM_VERSION=${fullver[0]}
export YUM_PATH=stable

echo "########## Starting promote for version $RPM_VERSION-$RPM_RELEASE ##########"
mkdir -p bin/rpmbuild/RPMS/x86_64
cd bin/rpmbuild/RPMS/x86_64
curl -LO https://dl.bintray.com/jumperfly/yum/cfssl/latest/cfssl-$RPM_VERSION-$RPM_RELEASE.el7.x86_64.rpm
cd ../../../..
envsubst < bintray-descriptor.json > bin/bintray-descriptor.json
