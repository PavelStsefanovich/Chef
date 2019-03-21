name 'open_cover'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures OpenCover'

long_description '
# open_cover
- Install OpenCover
	- add OpenCover to ENV:PATH
'

version '0.2.1'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'zipfile'
