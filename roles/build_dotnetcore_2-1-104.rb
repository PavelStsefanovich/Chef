name 'build_dotnetcore_2-1-104'
description '<<< .NET Framework v.4.7 and .Net Core 2.1.104 >>>   
	Currently included tasks:
	- install java development kit: (8u161);
	- install java runtime environment (8u161);
	- install java certificates;
	- install code signing certificates;
	- install Microsoft ASP.NET MVC 4;
	- install Microsoft Visual C++ Build Tools (14.0);
	- install Visual Studio BuildTools (2017);
	- install Visual Studio Test Agent (2017);
	- install ASP .Net MVC 4;
	- install SQL Oledb Driver and Command Line Utilities: (13);
	- install .NET 4.5.1 SDK;
	- install .NET 4.6.1 SDK;
	- install .NET 4.7 SDK;
	- install .NET Core;
	- install Windows SDK 10;
	- install NuGet 4.6.2
	- install WebApplications 14.0;
	- install Gradle: (4.6);
	- install ReportGenerator (3.1.1.0);
	- install Open Cover(4.6.519)
'

common_run_list = [
	"recipe[java::install_jdk@0.5.3]",
	"recipe[java::install_jre@0.5.3]",
	"recipe[certificates::install_java_certificates@0.7.4]",
	"recipe[certificates::install_codesign_certificates@0.7.4]",
	"recipe[mvc4@0.2.1]",
	"recipe[sql_management_objects::install_management_objects_2012]",
	"recipe[visualcpp_build_tools@0.2.1]",
	"recipe[vs_testagent@0.2.2]",
	"recipe[vs_buildtools@0.2.1]",
	"recipe[sql_cmdlnutils@0.2.1]",
	"recipe[dotnet451sdk@0.1.1]",
	"recipe[dotnet461sdk@0.1.1]",
	"recipe[dotnet47sdk@0.1.1]",
	"recipe[dotnet_core@0.1.1]",
	"recipe[windows_sdk@0.1.2]",
	"recipe[nuget@0.2.1]",
	"recipe[web_applications@0.1.1]",
	"recipe[gradle@0.4.2]",
	"recipe[open_cover@0.1.1]",
	"recipe[report_generator@0.1.1]"
]
					
run_list(common_run_list)

env_run_lists(
	"BUILD" => ["recipe[vm_config]"] + common_run_list,
	"_default" => []
)

default_attributes	"repo_prereqs_path" => "BuildMachine/PreReqs",
		"jdk" => {
		"packagefile" => "jdk-8u161-windows-x64.exe",
		"installname" => "Java SE Development Kit 8 Update 161 (64-bit)",
		"arguments" => "/s ADDLOCAL=\"ToolsFeature,SourceFeature\""
	},
	"java" => {
		"packagefile" => "jre-8u161-windows-x64.exe",
		"installname" => "Java 8 Update 161 (64-bit)",
		"arguments" => "/s"
	},
	"mvc4" => {
		"packagefile" => "AspNetMVC4Setup.exe",
		"installname" => "Microsoft ASP.NET MVC 4",
		"arguments" => "/q"
	},
	"visualcpp_build_tools" => {
		"packagefile" => "visualcppbuildtools_full.exe",
		"installname" => "Microsoft Build Tools 14.0 (amd64)",
		"arguments" => "/q",
		"signtoolPath" => "C:/Program Files (x86)/Windows Kits/8.1/bin/x64"
	},
	"vs_buildtools" => {
		"packagefile" => "vs_buildtools_2017.exe",
		"installname" => "Visual Studio Build Tools 2017",
		"registryKeyName" => "VsBuildTools",
		"arguments" => "--add Microsoft.VisualStudio.Workload.NetCoreBuildTools --wait --norestart -q",
		"envpath" => "C:/Program Files (x86)/Microsoft Visual Studio/2017/BuildTools/MSBuild/15.0/Bin"
	},
	"vs_testagent" => {
		"packagefile" => "vs_testagent__1882320520.1513289542.exe",
		"installname" => "IntelliTraceProfilerProxy",
		"arguments" => "--all --wait --norestart -q",
		"envpath" => "C:/Program Files (x86)/Microsoft Visual Studio/2017/TestAgent/Common7/IDE"
	},
	"sql_cmdlnutils" => {
		"msodbcsql" => {
			"packagefile" => "msodbcsql.msi",
			"installname" => "Microsoft ODBC Driver 13 for SQL Server",
			"arguments" => "/qn IACCEPTMSODBCSQLLICENSETERMS=YES ADDLOCAL=ALL"
		},
		"mssqlcmdlnutils" => {
			"packagefile" => "MsSqlCmdLnUtils.msi",
			"installname" => "Microsoft Command Line Utilities 13 for SQL Server",
			"arguments" => "/qn IACCEPTMSSQLCMDLNUTILSLICENSETERMS=YES"
		}
	},
	"dotnet451sdk" => {
		"packagefile" => "NDP451-KB2861696-x86-x64-DevPack.exe",
		"installname" => "Microsoft .NET Framework 4.5.1 Multi-Targeting Pack",
		"arguments" => "/q /norestart"
	},
	"dotnet461sdk" => {
		"packagefile" => "NDP461-DevPack-KB3105179-ENU.exe",
		"installname" => "Microsoft .NET Framework 4.6.1 SDK",
		"arguments" => "/q /norestart"
	},
	"dotnet47sdk" => {
		"packagefile" => "NDP47-DevPack-KB3186612-ENU.exe",
		"installname" => "Microsoft .NET Framework 4.7 SDK",
		"arguments" => "/q /norestart"
	},
	"dotnet_core" => {
		"packagefile" => "dotnet-sdk-2.1.104-win-x64.exe",
		"installname" => "Microsoft .NET Core SDK - 2.1.104 (x64)",
		"arguments" => "/q /norestart"
	},
	"windows_sdk" => {
		"packagefile" => "sdksetup.exe",
		"installname" => "Windows Software Development Kit",
		"arguments" => "/q /norestart",
		"signtoolPath" => "C:/Program Files (x86)/Windows Kits/8.0/bin/x64"
	},
	"nuget" => {
		"packagefile" => "nuget-4.6.2.zip",
		"installdir" => "C:/nuget",
		"envpath" => "C:/nuget/nuget-4.6.2",
		"replace" => "true"
	},
	"web_applications" => {
		"packagefile" => "WebApplications.14.0.zip",
		"installdir" => "C:/Program Files (x86)/MSBuild",
		"replace" => "false"
	},
	"gradle" => {
		"packagefile" => "gradle-4.6-bin.zip",
		"installdir" => "C:/gradle",
		"envpath" => "C:/gradle/gradle-4.6/bin",
		"replace" => "true"
	},
	"open_cover" => {
		"packagefile" => "OpenCover.4.6.519.zip",
		"installdir" => "C:/OpenCover",
		"envpath" => "C:/OpenCover/OpenCover.4.6.519",
		"replace" => "false"
	},
	"report_generator" => {
		"packagefile" => "ReportGenerator_3.1.1.0.zip",
		"installdir" => "C:/ReportGenerator",
		"envpath" => "C:/ReportGenerator/ReportGenerator_3.1.1.0",
		"replace" => "false"
	}
