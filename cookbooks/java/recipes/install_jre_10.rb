# Cookbook:: java

puts " - initializing: [java::install_jre_10]"

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

version_dir = node["java"][10]["jre"]["major_version_directory"]
packagefile = node["java"][10]["jre"]["packagefile"]
installname = node["java"][10]["jre"]["installname"]
arguments = node["java"][10]["jre"]["arguments"]
setJavaHome = node["java"][10]["jre"]["setJavaHome"]

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
	notifies :run, 'powershell_script[Set CHEF_JENKINS_SLAVE_REPLACE flag]', :immediately
	notifies :request_reboot, 'reboot[Reboot after JRE installed]', :delayed
end

powershell_script "Set CHEF_JAVAHOME Environment Variable" do
  code <<-EOH
    $uninstallKey = 'HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/Uninstall'
    $installedSoftware = gp (ls $uninstallKey).name.Replace('HKEY_LOCAL_MACHINE','HKLM:')
    $jreInstallation = $installedSoftware | ?{$_.displayname -eq "#{installname}"}
    if ($jreInstallation) {
			$javaHome = $jreInstallation.InstallLocation.Replace('\\','/').TrimEnd('/\\')
			[Environment]::SetEnvironmentVariable("CHEF_JAVAHOME", $javaHome, 'Machine')
			if ("#{setJavaHome}" -eq 'true') {
				[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, 'Machine')
			}
    } else {
      throw "!!ERROR: Target JRE version is not installed: #{installname}"
    }
	EOH
  guard_interpreter :powershell_script
end

powershell_script "Set CHEF_JENKINS_SLAVE_REPLACE flag" do
	action :nothing
	code <<-EOH
		[Environment]::SetEnvironmentVariable("CHEF_JENKINS_SLAVE_REPLACE", 'true', 'Machine')
	EOH
end

reboot 'Reboot after JRE installed' do
	delay_mins reboot_delay
  action :nothing
  reason 'Reboot after JRE installed'
end
