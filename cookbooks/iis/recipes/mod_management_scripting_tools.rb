# Cookbook:: iis
# Recipe:: mod_management_scripting_tools

include_recipe 'iis'

windows_feature_powershell 'Web-Scripting-Tools' do
	action :install
	timeout 1200
end
