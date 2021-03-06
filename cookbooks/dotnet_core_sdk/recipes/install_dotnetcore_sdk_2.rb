# Cookbook:: dotnet_core_sdk

puts " - initializing: [dotnet_core_sdk::install_dotnetcore_sdk_2]"

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
reboot_delay = env_config["reboot_delay"]

version_dir = node["dotnet_core_sdk"][2]["major_version_directory"]
packagefile = node["dotnet_core_sdk"][2]["packagefile"]
installname = node["dotnet_core_sdk"][2]["installname"]
arguments = node["dotnet_core_sdk"][2]["arguments"]

packagepath = File.join(Chef::Config[:file_cache_path], packagefile)

if repo_prereqs_path.length > 0
	url = "#{protocol}#{host}/#{path}/#{repo_prereqs_path}/#{version_dir}/#{packagefile}"
else
	url = "#{protocol}#{host}/#{path}/#{version_dir}/#{packagefile}"
end

# EXECUTION
remote_file packagepath do
	source url
	headers({ "#{apiHeader}" => "#{apikey}" })
end

windows_package installname do
  source packagepath
  installer_type :custom
  options arguments
	timeout 1200
	returns [0,1641,3010]
	notifies :request_reboot, 'reboot[Reboot after DotNet Core installed]', :delayed
end

reboot 'Reboot after DotNet Core installed' do
	delay_mins reboot_delay
  action :nothing
  reason 'Reboot after DotNet Core installed'
end
