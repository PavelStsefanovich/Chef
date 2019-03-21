# Cookbook:: visualcpp_build_tools

puts " - initializing: [visualcpp_build_tools::install_visualcpp_bt_14]"

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
install_disk = env_config["install_disk"]
reboot_delay = env_config["reboot_delay"]

if install_disk.nil?
	install_disk = "C:"
end

version_dir = node["visualcpp_build_tools"][14]["major_version_directory"]
packagefile = node["visualcpp_build_tools"][14]["packagefile"]
installname = node["visualcpp_build_tools"][14]["installname"]
arguments = node["visualcpp_build_tools"][14]["arguments"]
signtoolPath = "#{install_disk}/#{node["visualcpp_build_tools"][14]["signtoolPath"]}"

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
	notifies :run, 'powershell_script[Add Signtool to PATH environment variable]', :immediately
	notifies :run, 'powershell_script[Set CHEF_CODESIGN_CERT_INSTALL flag]', :immediately
end

powershell_script "Add Signtool to PATH environment variable" do
	action :nothing
  code <<-EOH
		$signtoolPath = "#{signtoolPath}"
		$path = [System.Environment]::GetEnvironmentVariable('PATH','Machine').TrimEnd(';')
		$path += ";$signtoolPath"
		[System.Environment]::SetEnvironmentVariable('PATH',$path,'Machine')
	EOH
	not_if <<-EOH
		$signtoolPath = "#{signtoolPath}"
		$path = [System.Environment]::GetEnvironmentVariable('PATH','Machine').TrimEnd(';').Split(';')
		if ($signtoolPath -in $path) {
			return $true
		} else {
			return $false
		}
	EOH
  guard_interpreter :powershell_script
end

powershell_script "Set CHEF_CODESIGN_CERT_INSTALL flag" do
	action :nothing
	code <<-EOH
		[Environment]::SetEnvironmentVariable("CHEF_CODESIGN_CERT_INSTALL", 'true', 'Machine')
	EOH
end

include_recipe 'certificates::install_codesign_certificates'
