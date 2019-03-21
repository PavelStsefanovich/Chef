name 'windows_sdk'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures Microsoft Windows SDK'

long_description '
# windows_sdk
- Install Microsoft Windows SDK
	- add signtool.exe to ENV:PATH
	- set ENV:CHEF_CODESIGN_CERT_INSTALL to trigger codesign certificate installation
'
	
version '0.2.1'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'certificates'
