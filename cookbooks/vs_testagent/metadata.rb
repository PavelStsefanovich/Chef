name 'vs_testagent'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures Visual Studio Test Agent'

long_description '
# vs_testagent
- Install Visual Studio Test Agent
	- add mstest.exe to EVN:PATH
'
	
version '0.3.1'
chef_version '>= 12.1' if respond_to?(:chef_version)
