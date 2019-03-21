name 'br_diagnostics'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Creates node on Jenkins server'
long_description '
	- create node.properties file;
	- create node config on Jenkins master;
	- install Jenkins slave as service;
'
version '0.1.2'
chef_version '>= 12.1' if respond_to?(:chef_version)

