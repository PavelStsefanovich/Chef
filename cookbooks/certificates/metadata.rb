name 'certificates'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Operations with certificates'

long_description '
# certificates
- Install SSL certificate (IIS)
	- import wildcard certificate to IIS
	- install root certificate into Windows certificates store
	- create HTTPS binding on port 443
- Install wildcard certificates to Java keystore
	- read ENV:CHEF_JAVAHOME and ENV:CHEF_JDKHOME to determine target JRE and JDK installations
- Install code signing certificate to CurrentUser Personal keystore
	- read CHEF_CODESIGN_CERT_INSTALL to determine if certificate must be installed
	- set ENV:CHEF_CODESIGN_CERT_INSTALL to false when certificate is installed
'

version '0.9.3'
chef_version '>= 12.1' if respond_to?(:chef_version)
