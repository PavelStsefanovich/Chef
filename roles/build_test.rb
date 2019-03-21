name 'build_test'
description '<<< Test role >>>'

common_run_list = [
	"recipe[wix::install_wix_3@0.1.2]"
]

run_list(common_run_list)

env_run_lists(
	"BUILD" => ["recipe[vm_config]"] + common_run_list,
	"_default" => []
)

default_attributes = []