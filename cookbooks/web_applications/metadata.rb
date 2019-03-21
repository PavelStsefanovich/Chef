name 'web_applications'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures Web Applications'

long_description '
# web_applications
- Install Web Applications
'

version '0.2.1'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'zipfile'
