Name:           cfssl
Version:        %{_version}
Release:        %{_release}%{?dist}
Summary:        cfssl

License:	BSD 2-Clause "Simplified" License
URL:            https://github.com/jumperfly/cfssl-rpm

%define __requires_exclude ^libc.so.*$

%description
cfssl RPM wrapper - https://github.com/cloudflare/cfssl

%files
/usr/bin/cfssl
/usr/bin/cfssljson
%config(noreplace) /etc/cfssl/config.json
