name 'sql_management_objects'
maintainer 'bR'
maintainer_email 'BR@athoc.com'
description 'Installs and configures Microsoft SQL Server Management Objects'
long_description '
# sql_management_objects
- Install Microsoft SQL Server Management Objects
- Install PowerShell Extensions for Microsoft SQL Server
'
version '0.1.2'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'sql_clrtypes', '>= 0.2.2'
