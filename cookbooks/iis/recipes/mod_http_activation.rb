# Cookbook:: iis
# Recipe:: mod_http_activation

include_recipe 'iis'

windows_feature_powershell 'NET-HTTP-Activation' do
	action :install
end

windows_feature_powershell 'NET-WCF-HTTP-Activation45' do
	action :install
	timeout 1200
end
