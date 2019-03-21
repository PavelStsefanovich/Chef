# Cookbook:: sql_native_client
# Attributes:: default

default["sql_native_client"][2012]["major_version_directory"] = "SQL/NativeClient/2012"
default["sql_native_client"][2012]["packagefile"] = "sqlncli.2012.msi"
default["sql_native_client"][2012]["installname"] = "Microsoft SQL Server 2012 Native Client"
default["sql_native_client"][2012]["arguments"] = "/qn IACCEPTSQLNCLILICENSETERMS=YES ADDLOCAL=All ALLUSERS=1"