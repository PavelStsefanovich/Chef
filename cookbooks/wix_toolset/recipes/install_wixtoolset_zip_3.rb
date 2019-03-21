# Cookbook:: wix_toolset

puts " - initializing: [wix_toolset::install_wixtoolset_zip_3]"

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

version_dir = node["wix_toolset"]["zip"][3]["major_version_directory"]
packagefile = node["wix_toolset"]["zip"][3]["packagefile"]
installdir = "#{install_disk}/#{node["wix_toolset"]["zip"][3]["installdir"]}"
envpath = "#{install_disk}/#{node["wix_toolset"]["zip"][3]["envpath"]}"
ifReplace = node["wix_toolset"]["zip"][3]["replace"]

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

powershell_script "Install WiX Toolset" do
  code <<-EOH
		$envpath = "#{envpath}".replace('/','\\')
		$paths = [System.Environment]::GetEnvironmentVariable('Path','Machine').TrimEnd(';').Split(';')
		$pathsNew = @()
		if ("#{ifReplace}" -eq 'true') {
			$paths | %{
				if ($_ -like '*wix*') {
					 get-item (Split-Path $_) -ErrorAction SilentlyContinue | rm -Force -Recurse -ErrorAction SilentlyContinue
				} else {
					$pathsNew += $_
				}
			}
		} else {
			$paths | %{if ($_.trimEnd('\\/') -ne $envpath) {$pathsNew += $_}}
		}
		$pathsNew += $envpath
		[Environment]::SetEnvironmentVariable("Path", $pathsNew -join(';'), 'Machine')
    #mkdir "#{installdir}" -Force | out-null
    write-host "(ps)packagepath: #{packagepath}"
    write-host "(ps)installdir: #{installdir}"
	EOH
  guard_interpreter :powershell_script
	not_if <<-EOH
		if ($ifReplace) {return $false}
		$envpath = "#{envpath}".replace('/','\\')
		$paths = [System.Environment]::GetEnvironmentVariable('Path','Machine').TrimEnd(';').Split(';')
		$paths | %{if ($_.trimEnd('\\/') -eq $envpath) {$installPath = $_}}
		if ($installPath) {
			return (Test-Path $installPath)
		} else {
			return $false
		}
	EOH
	notifies :extract, "zipfile[#{packagepath}]", :immediately
	notifies :request_reboot, 'reboot[Reboot after Wix Toolset installed]', :delayed
end

#ruby
zipfile packagepath do
  into installdir
	overwrite true
	action :nothing
end

reboot 'Reboot after Wix Toolset installed' do
	delay_mins 1
  action :nothing
  reason 'Reboot after Wix Toolset installed'
end
