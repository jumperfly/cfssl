#!/bin/bash

RPM_RELEASE=$1
echo "########## Starting build for release $RPM_RELEASE ##########"

echo "########## Clean and prepare build directory ##########"
if [ -e cfssl ]; then
  rm -rf cfssl
fi
if [ -e bin ]; then
  rm -rf bin
fi
mkdir -p bin/go/usr/bin

echo "########## Downoad cfssl sources ##########"
git clone https://github.com/cloudflare/cfssl.git
cd cfssl
git checkout 1.3.2
cd ..

echo "########## Build cfssl ##########"
for cmd in cfssl cfssljson; do
  echo -n "Building $cmd... "
  docker run --rm -e RPM_RELEASE=$RPM_RELEASE \
    -v $(pwd)/cfssl:/go/src/github.com/cloudflare/cfssl \
    -v $(pwd)/bin/go/usr/bin:/go/bin golang:1.11.2 \
    go install github.com/cloudflare/cfssl/cmd/$cmd
  echo done.
done

echo "########## Build rpm ##########"
docker run --rm -v $(pwd):/build jumperfly/rpmbuild:v4.11.3_1 \
  rpmbuild -bb --buildroot /build/bin/go \
  --define "_topdir /build/bin/rpmbuild" \
  --define "_release $RPM_RELEASE" \
  /build/cfssl.spec
