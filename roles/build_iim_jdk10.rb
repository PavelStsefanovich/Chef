name 'build_iim_jdk10'
description '<<< Java Development Kit 10 >>>
	Currently included tasks:
	- install java development kit: (10.0.1);
	- install java runtime environment (10.0.1);
	- install java certificates;
	- install Microsoft ASP.NET MVC 4;
	- install Microsoft Visual C++ Build Tools (14.0);
	- install Visual Studio BuildTools (2017);
	- install .NET 4.6.1 SDK;
	- install Gradle: (4.6);
'

common_run_list = [
	"recipe[java::install_jdk_10@0.6.1]",
	"recipe[java::install_jre_10@0.6.1]",
	"recipe[certificates::install_java_certificates@0.8.0]",
	"recipe[mvc::install_mvc_4@0.1.1]",
	"recipe[visualcpp_build_tools::install_visualcpp_bt_14@0.3.1]",
	"recipe[vs_buildtools::install_vs_bt_2017@0.3.0]",
	"recipe[dotnet_sdk::install_dotnetsdk_461@0.1.1]",
	"recipe[gradle::install_gradle_46@0.5.0]",
]
					
run_list(common_run_list)

env_run_lists(
	"BUILD" => ["recipe[vm_config]"] + common_run_list,
	"_default" => []
)

default_attributes = []