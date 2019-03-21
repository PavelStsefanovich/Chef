# Cookbook:: nuget

puts " - initializing: [nuget::install_nuget_462]"

# Add 'SeAssignPrimaryTokenPrivilege' for the user
Chef::ReservedNames::Win32::Security.add_account_right('athocdevo\\bbot', 'SeAssignPrimaryTokenPrivilege')

# Check if the user has 'SeAssignPrimaryTokenPrivilege' rights
Chef::ReservedNames::Win32::Security.get_account_right('athocdevo\\bbot').include?('SeAssignPrimaryTokenPrivilege')

# CONFIGURATION
env_databag = node['env_databag']

repo_secret_key = node['repo_secret']
repo = Chef::EncryptedDataBagItem.load(env_databag, "repo", repo_secret_key)
host = repo["host"]
path = repo["path"]
apiHeader = repo["apiHeader"]
apikey = repo["apikey"]
repo_prereqs_path = repo["repo_prereqs_path"]
nugetSourceConfig = repo["nugetsource"]

case repo["secure"]
when 0
  protocol = "http://"
when 1
  protocol = "https://"
else
  protocol = "Invalid protocol://"
end
nugetUrl = "#{protocol}#{host}/#{nugetSourceConfig['path']}"

env_config_secret_key = node['env_config_secret']
env_config = Chef::EncryptedDataBagItem.load(env_databag, "env_config", env_config_secret_key)
install_disk = env_config["install_disk"]
reboot_delay = env_config["reboot_delay"]
winrmUser = env_config["winrm"]["winrmuser"]
winrmPasw = env_config["winrm"]["winrmpassw"]

if install_disk.nil?
	install_disk = "C:"
end

version_dir = node["nuget"][462]["major_version_directory"]
packagefile = node["nuget"][462]["packagefile"]
installdir = "#{install_disk}/#{node["nuget"][462]["installdir"]}"
envpath = "#{install_disk}/#{node["nuget"][462]["envpath"]}"
ifReplace = node["nuget"][462]["replace"]

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

powershell_script "Install Nuget" do
  code <<-EOH
		$envpath = "#{envpath}".replace('/','\\')
		$paths = [System.Environment]::GetEnvironmentVariable('Path','Machine').TrimEnd(';').Split(';')
		$pathsNew = @()
		if ("#{ifReplace}" -eq 'true') {
			$paths | %{
				if ($_ -like '*nuget*') {
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
	EOH
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
  guard_interpreter :powershell_script
end

#ruby
zipfile packagepath do
  into installdir
	overwrite true
	action :nothing
end

powershell_script "Update Nuget sources" do
	elevated true
  user winrmUser
  password winrmPasw
  code <<-EOH
		$sourcesList = & "#{envpath}/nuget.exe" sources
    if ($sourcesList -like '*#{nugetUrl}*') {
      & "#{envpath}/nuget.exe" sources remove -name "#{nugetSourceConfig['name']}"
    }
		& "#{envpath}/nuget.exe" sources Add -Name "#{nugetSourceConfig['name']}" -Source "#{nugetUrl}"
		& "#{envpath}/nuget.exe" setapikey "#{nugetSourceConfig['username']}:#{nugetSourceConfig['password']}" -Source "#{nugetSourceConfig['name']}"
		& "#{envpath}/nuget.exe" sources update -Name "#{nugetSourceConfig['name']}" -UserName "#{nugetSourceConfig['username']}" -Password "#{nugetSourceConfig['password']}"
    & "#{envpath}/nuget.exe" sources
	EOH
end



