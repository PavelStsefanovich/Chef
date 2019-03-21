# Cookbook:: athoc_iws
# Attributes:: default

default["athoc_iws"]["debug"] = "false"
default["athoc_iws"]["msi_logs_directory"] = "C:/MSI/Logs"

default["athoc_iws"]["PRODUCT_NAME"] = "not_set"
default["athoc_iws"]["REPOSITORY"] = "not_set"
default["athoc_iws"]["REPOSITORY_LAYOUT"] = "not_set"
default["athoc_iws"]["BRANCH"] = "not_set"
default["athoc_iws"]["BUILD_NUMBER"] = "not_set"
default["athoc_iws"]["PATCH_LEVEL"] = "0"
default["athoc_iws"]["PREVIOUS_BUILD_NUMBER"] = "not_set"
default["athoc_iws"]["FEATURES"] = "not_set"
default["athoc_iws"]["PRODUCT_CONFIGURATION"] = "not_set"

default["athoc_iws"]["PACKAGE_REPOSITORY_LAYOUTS"] = {
	"daily_build" => "",
	"daily_build_2.0" => "@url@/Builds/@majorVersion@_@minorVersion@_0_0/MSI/@product_name@/@majorVersion@.@minorVersion@.@build_number@.@build_number@/@msi_name@",
	"released_la" => "",
	"released_ga" => ""
}
default["athoc_iws"]["PACKAGE_NAME_LAYOUTS"] = {
	"daily_build" => "",
	"daily_build_2.0" => "@product_name@-@majorVersion@.@minorVersion@.@build_number@.@build_number@.msi",
	"released_la" => "",
	"released_ga" => ""
}