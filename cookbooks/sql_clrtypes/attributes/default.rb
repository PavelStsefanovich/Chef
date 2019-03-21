# Cookbook:: sql_clrtypes
# Attributes:: default

default["sql_clrtypes"][2008]["major_version_directory"] = "SQL/ClrTypes/2008"
default["sql_clrtypes"][2008]["packagefile"] = "SQLSysClrTypes.2008.msi"
default["sql_clrtypes"][2008]["installname"] = "Microsoft SQL Server System CLR Types"
default["sql_clrtypes"][2008]["arguments"] = "/qn ALLUSERS=1"

default["sql_clrtypes"][2012]["major_version_directory"] = "SQL/ClrTypes/2012"
default["sql_clrtypes"][2012]["packagefile"] = "SQLSysClrTypes.2012.msi"
default["sql_clrtypes"][2012]["installname"] = "Microsoft System CLR Types for SQL Server 2012"
default["sql_clrtypes"][2012]["arguments"] = "/qn ALLUSERS=1"

default["sql_clrtypes_x64"][2012]["major_version_directory"] = "SQL/ClrTypes/2012"
default["sql_clrtypes_x64"][2012]["packagefile"] = "SQLSysClrTypes.x64.2012.msi"
default["sql_clrtypes_x64"][2012]["installname"] = "Microsoft System CLR Types for SQL Server 2012 (x64)"
default["sql_clrtypes_x64"][2012]["arguments"] = "/qn ALLUSERS=1"