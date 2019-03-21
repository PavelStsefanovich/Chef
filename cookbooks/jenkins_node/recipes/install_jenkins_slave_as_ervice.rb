#
# Cookbook:: jenkins_node

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
jnode_secret_key = node['jnode_secret']
jnode = Chef::EncryptedDataBagItem.load(env_databag, "jnode", jnode_secret_key)
winswVersion = jnode["jnode_winswVersion"]
winswFilename = "winsw-#{winswVersion}-bin.exe"
winswDownloadPath = File.join(Chef::Config[:file_cache_path], winswFilename)
scriptDir = Chef::Config[:file_cache_path]
configTemplatesDir = File.join(scriptDir, 'Templates')
nodePropertiesFilepath = File.join(Chef::Config[:file_cache_path], 'node.properties')

cookbook_file "#{scriptDir}/Install.Jenkins.Slave.As.Service.ps1" do
  source 'Install.Jenkins.Slave.As.Service.ps1'
  action :create
end

directory configTemplatesDir do
  action :create
	recursive true
end

['tmpl_jenkins-slave.exe.config', 'tmpl_jenkins-slave.xml'].each do |templatefile|
  templateDestinationPath = File.join(configTemplatesDir, templatefile)

	cookbook_file templateDestinationPath do
		source "Templates/#{templatefile}"
		action :create
	end
end

url = "#{protocol}#{host}/#{path}/winsw/#{winswFilename}"

remote_file winswDownloadPath do
	source url
	headers({ "X-JFrog-Art-Api" => "#{apikey}" })
end

commandline = "#{scriptDir}/Install.Jenkins.Slave.As.Service.ps1 -nodePropertiesFilePath '#{nodePropertiesFilepath}'"

powershell_script "Install Jenkins slave as service" do
  code commandline
	only_if <<-EOH
		if ([System.Environment]::GetEnvironmentVariable('CHEF_JENKINS_SLAVE_REPLACE','Machine') -eq 'true') {
			return $true
		} else {
			gsv jenkinsslave | restart-service
			return $false
		}		
	EOH
  guard_interpreter :powershell_script
	notifies :run, "powershell_script[Drop CHEF_JENKINS_SLAVE_REPLACE flag]", :immediately
end

powershell_script "Drop CHEF_JENKINS_SLAVE_REPLACE flag" do
	action :nothing
	code <<-EOH
		[Environment]::SetEnvironmentVariable("CHEF_JENKINS_SLAVE_REPLACE", 'false', 'Machine')
	EOH
end
