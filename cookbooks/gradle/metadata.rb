name 'gradle'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures Gradle'

long_description '
# gradle
- Install Gradle
	- add Gradle to ENV:PATH
'

version '0.5.1'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'zipfile'
