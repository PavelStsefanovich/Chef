name 'nuget'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures Nuget'

long_description '
# nuget
- Install Nuget
	- add Nuget to ENV:PATH
	- create API key to access Repo
	- add Repo to Nuget sources
'

version '0.3.1'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'zipfile'
