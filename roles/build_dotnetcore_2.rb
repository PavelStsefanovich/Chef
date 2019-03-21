name 'build_dotnetcore_2'
description '<<< .NET Framework v.4.7.2 and .Net Core 2 >>>
	Currently included tasks:
	- install java development kit 8;
	- install java runtime environment 8;
	- install java certificates;
	- install code signing certificates;
	- install Microsoft ASP.NET MVC 4;
	- install .NET 4.7 SDK;
	- install .NET 4.7.2 SDK;
	- install Visual Studio BuildTools 2017;
	- install Visual Studio Test Agent 2017;
	- install .NET Core SDK 2;
	- install Windows SDK 8;
	- install NuGet 4.6;
	- install WebApplications 14.0;
	- install Gradle 4.6;
	- install Open Cover 4.6;
	- install ReportGenerator 3.1;
'

common_run_list = [
	"recipe[java::install_jdk_8]",
	"recipe[java::install_jre_8]",
	"recipe[certificates::install_java_certificates]",
	"recipe[certificates::install_codesign_certificates]",
	"recipe[mvc::install_mvc_4]",
	"recipe[dotnet_sdk::install_dotnetsdk_47]",
	"recipe[dotnet_sdk::install_dotnetsdk_472]",
	"recipe[dotnet_core_sdk::install_dotnetcore_sdk_2]",
	"recipe[vs_buildtools::install_vs_bt_2017]",
	"recipe[vs_testagent::install_vs_ta_2017]",
	"recipe[windows_sdk::install_winsdk_8]",
	"recipe[nuget::install_nuget_462]",
	"recipe[web_applications::install_wa_14]",
	"recipe[gradle::install_gradle_46]",
	"recipe[open_cover::install_oc_46]",
	"recipe[report_generator::install_rg_31]"
]

run_list(common_run_list)

env_run_lists(
	"BUILD" => [
		"recipe[vm_config]",
		"recipe[notepad_pp::install_npp_756]"
		] + common_run_list,
	"_default" => []
)

default_attributes = []
