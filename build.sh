#!/bin/bash

export RPM_RELEASE=$1
export RPM_VERSION=1.4.1
export YUM_PATH=latest

echo "########## Starting build for version $RPM_VERSION-$RPM_RELEASE ##########"

echo "########## Clean and prepare build directory ##########"
if [ -e cfssl ]; then
  rm -rf cfssl
fi
if [ -e bin ]; then
  rm -rf bin
fi
mkdir -p bin/go/{usr/bin,etc/cfssl}

echo "########## Downoad cfssl sources ##########"
git clone https://github.com/cloudflare/cfssl.git
cd cfssl
git checkout v$RPM_VERSION
cd ..

echo "########## Build cfssl ##########"
for cmd in cfssl cfssljson; do
  echo -n "Building $cmd... "
  docker run --rm -e RPM_RELEASE=$RPM_RELEASE \
    -v $(pwd)/cfssl:/go/src/github.com/cloudflare/cfssl \
    -v $(pwd)/bin/go/usr/bin:/go/bin golang:1.13.8-stretch \
    go install github.com/cloudflare/cfssl/cmd/$cmd
  echo done.
done
cp cfssl-config.json bin/go/etc/cfssl/config.json

echo "########## Build rpm ##########"
docker run --rm -v $(pwd):/build jumperfly/rpmbuild:v4.11.3_1 \
  rpmbuild -bb --buildroot /build/bin/go \
  --define "_topdir /build/bin/rpmbuild" \
  --define "_release $RPM_RELEASE" \
  --define "_version $RPM_VERSION" \
  /build/cfssl.spec

echo "########## Generate deployment properties ##########"
envsubst < bintray-descriptor.json > bin/bintray-descriptor.json
