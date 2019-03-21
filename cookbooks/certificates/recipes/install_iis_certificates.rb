# Cookbook:: certificates

puts " - initializing: [certificates::install_iis_certificates]"

# CONFIGURATION
env_databag = node['env_databag']

repo_secret_key = node['repo_secret']
repo = Chef::EncryptedDataBagItem.load(env_databag, "repo", repo_secret_key)
host = repo["host"]
path = repo["path"]
apiHeader = repo["apiHeader"]
apikey = repo["apikey"]
repo_prereqs_path = repo["repo_prereqs_path"]

case repo["secure"]
when 0
  protocol = "http://"
when 1
  protocol = "https://"
else
  protocol = "Invalid protocol://"
end

env_config_secret_key = node['env_config_secret']
env_config = Chef::EncryptedDataBagItem.load(env_databag, "env_config", env_config_secret_key)
domainName = env_config["certificates_iis"]["certificates"]["domain"]
certificate_iis = env_config["certificates_iis"]["certificates"]["iis"]
certificate_rootCA = env_config["certificates_iis"]["certificates"]["rootCA"]

scriptDir = Chef::Config[:file_cache_path]
certDir = File.join(scriptDir, "Certificates/IIS")

# EXECUTION
cookbook_file "#{scriptDir}/SSL.Cert.Binding.IIS.ps1" do
  source 'SSL.Cert.Binding.IIS.ps1'
  action :create
end

directory certDir do
  action :create
	recursive true
end

version_dir = node["certificates"]["iis"]["major_version_directory"]
certDownloadPath_iis = File.join(certDir, certificate_iis['name'])
url = "#{protocol}#{host}/#{path}/#{version_dir}/#{certificate_iis['name']}"
remote_file certDownloadPath_iis do
	source url
	headers({ "#{apiHeader}" => "#{apikey}" })
	sensitive true
end

version_dir = node["certificates"]["rootCA"]["major_version_directory"]
certDownloadPath_rootCA = File.join(certDir, certificate_rootCA['name'])
url = "#{protocol}#{host}/#{path}/#{version_dir}/#{certificate_rootCA['name']}"
remote_file certDownloadPath_rootCA do
	source url
	headers({ "#{apiHeader}" => "#{apikey}" })
	sensitive true
end

powershell_script "Install IIS certificates" do
	code <<-EOH
		Write-Verbose " >> Calling: & `"#{scriptDir}/SSL.Cert.Binding.IIS.ps1`" -Certfile `"#{certDownloadPath_iis}`" -CertPassw `"*******`" -CaCertFile `"#{certDownloadPath_rootCA}`" -DomainName `"#{domainName}`" -WORKSPACE `"#{scriptDir}`""
		& "#{scriptDir}/SSL.Cert.Binding.IIS.ps1" -Certfile "#{certDownloadPath_iis}" -CertPassw "#{certificate_iis['password']}" -CaCertFile "#{certDownloadPath_rootCA}" -DomainName "#{domainName}" -WORKSPACE "#{scriptDir}"
	EOH
  guard_interpreter :powershell_script
end
