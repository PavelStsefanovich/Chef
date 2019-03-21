# Cookbook:: sql_management_objects
# Attributes:: default

default["sql_management_objects"][2012]["management_objects"]["major_version_directory"] = "SQL/SharedManagementObjects/2012"
default["sql_management_objects"][2012]["management_objects"]["packagefile"] = "SharedManagementObjects.msi"
default["sql_management_objects"][2012]["management_objects"]["installname"] = "Microsoft SQL Server 2012 Management Objects  (x64)"
default["sql_management_objects"][2012]["management_objects"]["arguments"] = "/qn /norestart ALLUSERS=1"

default["sql_management_objects"][2012]["powershell_tools"]["major_version_directory"] = "SQL/PowerShellTools/2012"
default["sql_management_objects"][2012]["powershell_tools"]["packagefile"] = "PowerShellTools.MSI"
default["sql_management_objects"][2012]["powershell_tools"]["installname"] = "Windows PowerShell Extensions for SQL Server 2012"
default["sql_management_objects"][2012]["powershell_tools"]["arguments"] = "/qn /norestart ALLUSERS=1"