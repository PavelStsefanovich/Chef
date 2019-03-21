# Cookbook:: java

puts " - initializing: [java::install_jre.rb]"

env_databag = node['env_databag']
repo_secret_key = node['repo_secret']
repo = Chef::EncryptedDataBagItem.load(env_databag, "repo", repo_secret_key)
host = repo["host"]
path = repo["path"]
apikey = repo["apikey"]
case repo["secure"]
when 0
  protocol = "http://"
when 1
  protocol = "https://"
else
  protocol = "Invalid protocol://"
end

packagefile = node["java"]["packagefile"]
installname = node["java"]["installname"]
arguments = node["java"]["arguments"]
setJavaHome = node["java"]["javahome"]
repo_prereqs_path = node["repo_prereqs_path"]

packagepath = File.join(Chef::Config[:file_cache_path], packagefile)
url = "#{protocol}#{host}/#{path}/#{repo_prereqs_path}/#{packagefile}"

remote_file packagepath do
	source url
	headers({ "X-JFrog-Art-Api" => "#{apikey}" })
end

windows_package installname do
  source packagepath
  installer_type :custom
  options arguments
	notifies :run, 'powershell_script[Set CHEF_JENKINS_SLAVE_REPLACE flag]', :immediately
	notifies :request_reboot, 'reboot[Reboot after Java installed]', :delayed
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

reboot 'Reboot after Java installed' do
	delay_mins 1
  action :nothing
  reason 'Reboot after Java installed'
end
