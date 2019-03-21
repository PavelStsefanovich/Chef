#
# Cookbook:: jenkins_node

scriptDir = Chef::Config[:file_cache_path]
nodePropertiesFilepath = File.join(Chef::Config[:file_cache_path], 'node.properties')

cookbook_file "#{scriptDir}/Create.Node.On.Jenkins.ps1" do
  source 'Create.Node.On.Jenkins.ps1'
end

commandline = "#{scriptDir}/Create.Node.On.Jenkins.ps1 -nodePropertiesFilePath '#{nodePropertiesFilepath}' -forceNodeRecreate"

powershell_script "Create node on Jenkins" do
  code commandline
  guard_interpreter :powershell_script
end

