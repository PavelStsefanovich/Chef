name 'build_dotnetcore_1-0-4'
description '<<< .NET Framework v.4.7 and .Net Core 1.0.4 >>>
	Currently included tasks:
	- install java development kit: (8u161);
	- install java runtime environment (8u161);
	- install java certificates;
	- install code signing certificates;
	- install Microsoft ASP.NET MVC 4;
	- install Microsoft Visual C++ Build Tools (14.0);
	- install Visual Studio BuildTools (2017);
	- install Visual Studio Test Agent (2017);
	- install SQL Oledb Driver and Command Line Utilities: (13);
	- install .NET 4.5.1 SDK;
	- install .NET 4.6.1 SDK;
	- install .NET 4.7 SDK;
	- install .NET Core 1.0.4;
	- install Windows SDK 10;
	- install NuGet 4.6.2
	- install WebApplications 14.0;
	- install Gradle: (4.6);
	- install ReportGenerator (3.1.1.0);
	- install Open Cover(4.6.519)
'

common_run_list = [
	"recipe[java::install_jdk_8@0.6.1]",
	"recipe[java::install_jre_8@0.6.1]",
	"recipe[certificates::install_java_certificates@0.8.0]",
	"recipe[certificates::install_codesign_certificates@0.8.0]",
	"recipe[mvc::install_mvc_4@0.1.1]",
	"recipe[sql_management_objects::install_management_objects_2012@0.1.0]",
	"recipe[visualcpp_build_tools::install_visualcpp_bt_14@0.3.1]",
	"recipe[build_tools::install_bt_2015@0.3.1]",
	"recipe[vs_testagent::install_vs_ta_2017@0.3.0]",
	"recipe[sql_cmdlnutils::install_mssqlcmdlnutils_13@0.3.0]",
	"recipe[dotnet_sdk::install_dotnetsdk_451@0.1.1]",
	"recipe[dotnet_sdk::install_dotnetsdk_461@0.1.1]",
	"recipe[dotnet_sdk::install_dotnetsdk_47@0.1.1]",
	"recipe[dotnet_core_sdk::install_dotnetcore_sdk_104@0.1.1]",
	"recipe[windows_sdk::install_winsdk_8@0.2.0]",
	"recipe[nuget::install_nuget_462@0.3.0]",
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