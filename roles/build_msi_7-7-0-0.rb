name 'build_msi_7-7-0-0'
description '<<< BUILD SERVER FOR MSI 7.7.0.0 >>>
	Currently included tasks:
	- install java development kit (8u161);
	- install java runtime environment (8u161);
	- install java certificates;
	- install code signing certificates;
	- install Microsoft Visual C++ Build Tools (14.0);
	- install Microsoft BuildTools: (2015);
	- install SQL Oledb Driver and Command Line Utilities: (13);
	- install .NET 4.7 SDK;
	- install .NET 4.7.2 SDK;
	- install Gradle: (4.6);
	- install WiX Toolset (3.14.0);
'

common_run_list = [
	"recipe[java::install_jdk_8]",
	"recipe[java::install_jre_8]",
	"recipe[certificates::install_java_certificates]",
	"recipe[certificates::install_codesign_certificates]",
	"recipe[visualcpp_build_tools::install_visualcpp_bt_14]",
	"recipe[build_tools::install_bt_2015]",
	"recipe[sql_cmdlnutils::install_mssqlcmdlnutils_13]",
	"recipe[dotnet_sdk::install_dotnetsdk_47]",
	"recipe[dotnet_sdk::install_dotnetsdk_472]",
	"recipe[gradle::install_gradle_46]",
	"recipe[wix_toolset::install_wixtoolset_zip_3]",
]

run_list(common_run_list)

env_run_lists(
	"BUILD" => ["recipe[vm_config]"] + common_run_list,
	"_default" => []
)

default_attributes = []
