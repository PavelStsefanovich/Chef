name 'java'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs/Configures Java (JDK, JRE)'

long_description '
# java
- Install java development kit (JDK)
	- add ENV:CHEF_JDKHOME
	- (optional) set ENV:JAVA_HOME to JDK installation directory (default: false)
- Install java runtime environment (JRE)
	- add ENV:CHEF_JAVAHOME
	- (optional) set ENV:JAVA_HOME to JRE installation directory (default: false)
'
	
version '0.6.2'
chef_version '>= 12.1' if respond_to?(:chef_version)
