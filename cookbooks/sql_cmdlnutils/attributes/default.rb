# Cookbook:: sql_cmdlnutils
# Attributes:: default

default["sql_cmdlnutils"][13]["msodbcsql"]["major_version_directory"] = "SQL/Sqlcmdlnutils/13"
default["sql_cmdlnutils"][13]["msodbcsql"]["packagefile"] = "msodbcsql.msi"
default["sql_cmdlnutils"][13]["msodbcsql"]["installname"] = "Microsoft ODBC Driver 13 for SQL Server"
default["sql_cmdlnutils"][13]["msodbcsql"]["arguments"] = "/qn IACCEPTMSODBCSQLLICENSETERMS=YES ADDLOCAL=ALL"

default["sql_cmdlnutils"][13]["mssqlcmdlnutils"]["major_version_directory"] = "SQL/Sqlcmdlnutils/13"
default["sql_cmdlnutils"][13]["mssqlcmdlnutils"]["packagefile"] = "MsSqlCmdLnUtils.msi"
default["sql_cmdlnutils"][13]["mssqlcmdlnutils"]["installname"] = "Microsoft Command Line Utilities 13 for SQL Server"
default["sql_cmdlnutils"][13]["mssqlcmdlnutils"]["arguments"] = "/qn IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES"