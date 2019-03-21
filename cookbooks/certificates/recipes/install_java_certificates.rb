# Cookbook:: certificates

puts " - initializing: [certificates::install_java_certificates]"

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
javaCertificates = env_config["certificates_java"]["certificates"]
keystorePassw = env_config["certificates_java"]["keystorePassw"]

version_dir = node["certificates"]["java"]["major_version_directory"]
scriptDir = Chef::Config[:file_cache_path]
certDir = File.join(scriptDir, "Certificates/Java")

# EXECUTION
cookbook_file "#{scriptDir}/Install.Java.Certificates.ps1" do
  source 'Install.Java.Certificates.ps1'
  action :create
end

directory certDir do
  action :create
	recursive true
end

javaCertificates.each do |certfile|
  certDownloadPath = File.join(certDir, certfile['name']) 
	if repo_prereqs_path.length > 0
		url = "#{protocol}#{host}/#{path}/#{repo_prereqs_path}/#{version_dir}/#{certfile['name']}"
	else
		url = "#{protocol}#{host}/#{path}/#{version_dir}/#{certfile['name']}"
	end

	remote_file certDownloadPath do
		source url
		headers({ "#{apiHeader}" => "#{apikey}" })
		sensitive true
	end
end

powershell_script "Install Java certificates" do
  code <<-EOH
	$javaHome = [System.Environment]::GetEnvironmentVariable('CHEF_JAVAHOME','Machine').Replace('\\','/').TrimEnd('/\\')
	if ($javaHome) {
		$javaCertificatesRaw = @"
			#{javaCertificates}
"@		
		$jsonObject =  ConvertFrom-Json $javaCertificatesRaw.Replace('=>',':').Trim()		
		$certificates = @{}
		$jsonObject | %{$certificates.Add($_.name,$_.alias)}
		Write-Host "Certificates to install:"
		$certificates.GetEnumerator().name | %{Write-Host " - $_`:`t`t$($certificates.$_)"}
		& "#{scriptDir}/Install.Java.Certificates.ps1" -javaHome "$javaHome" -certificatesDir "#{certDir}" -certificates $certificates
	} else {
		throw "!!ERROR: CHEF_JAVAHOME environment variable not found"
	}
	EOH
	only_if <<-EOH
		$jreEnvVar = [System.Environment]::GetEnvironmentVariable('CHEF_JAVAHOME','Machine')
		if ($jreEnvVar) {
			return (Test-Path ($jreEnvVar))
		} else {
			return $false
		}
	EOH
  guard_interpreter :powershell_script
end

powershell_script "Install JDK certificates" do
  code <<-EOH
	$javaHome = [System.Environment]::GetEnvironmentVariable('CHEF_JDKHOME','Machine').Replace('\\','/').TrimEnd('/\\')
	if ($javaHome) {
		$javaHome += "/jre"
		$javaCertificatesRaw = @"
			#{javaCertificates}
"@		
		$jsonObject =  ConvertFrom-Json $javaCertificatesRaw.Replace('=>',':').Trim()		
		$certificates = @{}
		$jsonObject | %{$certificates.Add($_.name,$_.alias)}
		Write-Host "Certificates to install:"
		$certificates.GetEnumerator().name | %{Write-Host " - $_`:`t`t$($certificates.$_)"}
		& "#{scriptDir}/Install.Java.Certificates.ps1" -javaHome "$javaHome" -certificatesDir "#{certDir}" -certificates $certificates -castorePassw "#{keystorePassw}"
	} else {
		throw "!!ERROR: CHEF_JDKHOME environment variable not found"
	}
	EOH
	only_if <<-EOH
		$jreEnvVar = [System.Environment]::GetEnvironmentVariable('CHEF_JDKHOME','Machine')
		if ($jreEnvVar) {
			return (Test-Path ("$jreEnvVar/jre"))
		} else {
			return $false
		}
	EOH
  guard_interpreter :powershell_script
end