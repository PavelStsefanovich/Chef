name 'athoc_iws'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs/Configures BlackBerry AtHoc Crisis Communications System'

long_description '
# athoc_iws
- Install IWS
	- run .msi package to install/upgrade IWS Application Server, Database Server, or both.
'
	
version '0.1.10'
chef_version '>= 12.1' if respond_to?(:chef_version)