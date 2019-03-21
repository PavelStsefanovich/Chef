# Cookbook:: web_applications

puts " - initializing: [web_applications::install_wa_14]"

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

if install_disk.nil?
	install_disk = "C:"
end

version_dir = node["web_applications"][14]["major_version_directory"]
packagefile = node["web_applications"][14]["packagefile"]
installdir = "#{install_disk}/#{node["web_applications"][14]["installdir"]}"
ifReplace = node["web_applications"][14]["replace"]

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

powershell_script "Install WebApplication" do
  code <<-EOH
		Write-Host "WebApplications not found. Copying from package '#{packagefile}' ..."
	EOH
  guard_interpreter :powershell_script
	not_if <<-EOH
		$WebApplicationsPath = "#{installdir}/Microsoft/VisualStudio/v14.0/WebApplications"
		$WebApplicationsFiles = @('Microsoft.WebApplication.Build.Tasks.Dll','Microsoft.WebApplication.targets')
		if (Test-Path $WebApplicationsPath) {
			$WebApplicationsFiles | %{
				if (!(gi "$WebApplicationsPath/$_" -ErrorAction SilentlyContinue)) {
					return $false
				}
			}
			
			return $true
			
		} else {
			return $false
		}
	EOH
	notifies :extract, "zipfile[#{packagepath}]", :immediately
end

#ruby
zipfile packagepath do
  into installdir
	overwrite true
	action :nothing
end

