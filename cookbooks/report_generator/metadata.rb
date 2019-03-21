name 'report_generator'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures ReportGenerator'
long_description '
# report_generator
- Install ReportGenerator
	- add ReportGenerator to ENV:PATH
'

version '0.2.1'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'zipfile'

