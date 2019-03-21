name 'build_dotnet47_java10'
description '<<< .NET Framework v.4.7 and Java 10 >>>
	Currently included tasks:
	- install java development kit (10);
	- install java runtime environment (10);
	- install java certificates;
	- install code signing certificates;
	- install Microsoft ASP.NET MVC 4;
	- install Microsoft Visual C++ Build Tools (14.0);
	- install Microsoft BuildTools: (2015);
	- install Visual Studio Test Agent (2017);
	- install SQL Oledb Driver and Command Line Utilities: (13);
	- install .NET 4.5.1 SDK;
	- install .NET 4.6.1 SDK;
	- install .NET 4.7 SDK;
	- install WebApplications 14.0;
	- install Gradle: (4.6);
	- install ReportGenerator (3.1.1.0);
	- install Open Cover(4.6.519)
'

common_run_list = [
	"recipe[java::install_jdk_10@0.6.1]",
	"recipe[java::install_jre_10@0.6.1]",
	"recipe[certificates::install_java_certificates@0.8.0]",
	"recipe[certificates::install_codesign_certificates@0.8.0]",
	"recipe[mvc::install_mvc_4@0.1.1]",
	"recipe[visualcpp_build_tools::install_visualcpp_bt_14@0.3.1]",
	"recipe[build_tools::install_bt_2015@0.3.1]",
	"recipe[vs_testagent::install_vs_ta_2017@0.3.0]",
	"recipe[sql_cmdlnutils::install_mssqlcmdlnutils_13@0.3.0]",
	"recipe[sql_management_objects::install_management_objects_2012@0.1.1]",
	"recipe[dotnet_sdk::install_dotnetsdk_451@0.1.1]",
	"recipe[dotnet_sdk::install_dotnetsdk_461@0.1.1]",
	"recipe[dotnet_sdk::install_dotnetsdk_47@0.1.1]",
	"recipe[web_applications::install_wa_14@0.2.0]",
	"recipe[gradle::install_gradle_46@0.5.0]",
	"recipe[open_cover::install_oc_46@0.2.0]",
	"recipe[report_generator::install_rg_31@0.2.0]"
]

run_list(common_run_list)

env_run_lists(
	"BUILD" => ["recipe[vm_config]"] + common_run_list,
	"_default" => []
)

default_attributes = []
