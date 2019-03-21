name 'visualcpp_build_tools'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures Microsoft Visual C++ Build Tools'

long_description '
# visualcpp_build_tools
- Install Microsoft Visual C++ Build Tools
	- add signtool.exe to ENV:PATH
	- set ENV:CHEF_CODESIGN_CERT_INSTALL to trigger codesign certificate installation
'

version '0.3.2'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'certificates'
