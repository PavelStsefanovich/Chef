# Cookbook:: vs_testagent

puts " - initializing: [vs_testagent::install_vs_ta_2017]"

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

version_dir = node["vs_testagent"][2017]["major_version_directory"]
packagefile = node["vs_testagent"][2017]["packagefile"]
installname = node["vs_testagent"][2017]["installname"]
arguments = node["vs_testagent"][2017]["arguments"]
envpath = node["vs_testagent"][2017]["envpath"]

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
	notifies :request_reboot, 'reboot[Reboot after Visual Studio Test Agent installed]', :delayed
end

powershell_script "Add MSTest to PATH Environment Variable" do
  code <<-EOH
		$envpath = "#{envpath}".replace('/','\\')
		$paths = [System.Environment]::GetEnvironmentVariable('Path','Machine').TrimEnd(';').Split(';')
		$pathsNew = @()
		$paths | %{if ($_.trimEnd('\\/') -ne $envpath) {$pathsNew += $_}}
		$pathsNew += $envpath
		[Environment]::SetEnvironmentVariable("Path", $pathsNew -join(';'), 'Machine')	
	EOH
  guard_interpreter :powershell_script
	not_if <<-EOH
		$envpath = "#{envpath}".replace('/','\\')
		$paths = [System.Environment]::GetEnvironmentVariable('Path','Machine').TrimEnd(';').Split(';')
		if ($envpath -in $paths) {
			return $true
		} else {
			return $false
		}
	EOH
end

reboot 'Reboot after Visual Studio Test Agent installed' do
	delay_mins reboot_delay
  action :nothing
  reason 'Reboot after Visual Studio Test Agent installed'
end

