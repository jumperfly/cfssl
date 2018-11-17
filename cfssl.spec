%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Name:           cfssl
Version:        1.3.2
Release:        1%{?dist}
Summary:        cfssl

License:	BSD 2-Clause "Simplified" License
URL:            https://github.com/jumperfly/cfssl-rpm

%description
cfssl RPM wrapper - https://github.com/cloudflare/cfssl

%files
/usr/bin/cfssl
/usr/bin/cfssljson
