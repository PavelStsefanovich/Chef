name 'vs_buildtools'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures Visual Studio Build Tools'

long_description '
# vs_buildtools
- Install Visual Studio Build Tools
	- add msbuild.exe to EVN:PATH
'
	
version '0.3.1'
chef_version '>= 12.1' if respond_to?(:chef_version)
