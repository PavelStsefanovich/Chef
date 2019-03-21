name 'wix'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures WiX'

long_description '
# wix
- Install WiX
'

version '0.1.3'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'iis'
