name 'iws_prereqs_7-6-0-0'
description '<<< IWS 7.6.0.0 Prerequisites >>>
	- Winodws Features:
		-- IIS ASP.NET,
		-- IIS ASP.NET 4.5,
		-- IIS ASP,
		-- IIS Management Console,
		-- IIS Management Scripts and Tools,
		-- IIS 6 Management Compatibility,
		-- IIS Basic,Authentication,
		-- IIS Windows Authentication,
		-- IIS HTTP Tracing,
		-- IIS Http Dynamic Compression,
		-- IIS Http Static Compression,
		-- IIS Message Queuing (MSMQ),
		-- IIS Http Request Monitor,
		-- HTTP Activation,
		-- Application Initialization;
	- SSL binding and certificates on port 443
	- ASP.NET AJAX (1.0);
	- ASP.NET MVC (4);
	- Microsoft .NET Core - Windows Server Hosting (2.1.0);
	- SQL Oledb Driver and Command Line Utilities (13);
	- Microsoft SQL Server CLR Types (2008);
	- Microsoft SQL Server CLR Types (2012);
	- Windows Server AppFabric (1.0.0.0);
	- Microsoft URL Rewrite Module for IIS (x64) (2.0);
	- Microsoft® SQL Server® 2012 Native Client	(2012);
	- install .NET 4.7 SDK;
	- Gradle: (4.6);
'

common_run_list = [
	"recipe[iis::mod_aspnet]",
	"recipe[iis::mod_aspnet45]",
	"recipe[iis::mod_asp]",
	"recipe[iis::mod_management]",
	"recipe[iis::mod_management_scripting_tools]",
	"recipe[iis::mod_iis6_metabase_compat]",
	"recipe[iis::mod_auth_basic]",
	"recipe[iis::mod_auth_windows]",
	"recipe[iis::mod_tracing]",
	"recipe[iis::mod_compress_dynamic]",
	"recipe[iis::mod_compress_static]",
	"recipe[iis::mod_msmq]",
	"recipe[iis::mod_requestmonitor]",
	"recipe[iis::mod_http_activation]",
	"recipe[iis::mod_application_initialization]",
	"recipe[certificates::install_iis_certificates]",
	"recipe[ajax::install_ajax_1]",
	"recipe[mvc::install_mvc_4]",
	"recipe[windows_server_hosting::install_server_hosting_210]",
	"recipe[sql_cmdlnutils::install_mssqlcmdlnutils_13]",
	"recipe[sql_clrtypes::install_clrtypes_2008]",
	"recipe[sql_clrtypes::install_clrtypes_2012]",
	"recipe[sql_native_client::install_nc_2012]",
	"recipe[appfabric::install_appfabric_1]",
	"recipe[url_rewrite::install_urlrewrite_2]",
	"recipe[dotnet_sdk::install_dotnetsdk_47]",
	"recipe[gradle::install_gradle_46]"
]

run_list(common_run_list)

env_run_lists(
	"DEV" => ["recipe[vm_config]"] + common_run_list,
	"QA" => ["recipe[vm_config]"] + common_run_list,
	"_default" => []
)

default_attributes = []
