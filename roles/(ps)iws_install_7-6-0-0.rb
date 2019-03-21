name 'iws_install_7-6-0-0'
description '<<< IWS 7.6.0.0 Install >>>
	Runs IWS 7.6.x.x MSI in installation mode
'

common_run_list = [
	"recipe[athoc_iws::msi_install.rb@0.1.0]"
]

run_list(common_run_list)

env_run_lists(
	"QA" => ["recipe[vm_config]"] + common_run_list,
	"_default" => []
)

default_attributes = []