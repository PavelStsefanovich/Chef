# Cookbook:: iis
# Recipe:: mod_asp

include_recipe 'iis'
include_recipe 'iis::mod_isapi'

windows_feature_powershell 'Web-ASP' do
	action :install
	timeout 1200
end