name 'dotnet_sdk'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures .NET SDK'

long_description '
# dotnet_sdk
- Install .NET SDK
	- schedule system restart in the end of successfull chef-client run
'

version '0.1.3'
chef_version '>= 12.1' if respond_to?(:chef_version)
