# Cookbook:: br_test

puts " - initializing: jenkins_node::default.rb"

Chef::Recipe.send(:include, BR_TEST::WIN_FEATURE)
Chef::Resource.send(:include, BR_TEST::WIN_FEATURE)

ruby_block 'Installing features' do
	block do
		fruits = ['apples', 'oranges', 'pears', 'apricots']
		fruits.each do |fruit|
			WIN_FEATURE(fruit,false)
		end
	end
end

puts "test, test, test!"
puts "more tests"





# env_databag = node['env_databag']
# jnode_secret_key = node['jnode_secret']
# jnode = Chef::EncryptedDataBagItem.load(env_databag, "jnode", jnode_secret_key)
# nodeName = jnode["jnode_nodeName"]
# if nodeName.length > 0
	# nodeName = nodeName.downcase
# else
	# nodeName = node['hostname'].downcase
# end
# labels = node["jenkins_node"]["product"] + "-" + node.environment()
# javaHome = "@@javaHome@@"
# downloadFolder = Chef::Config[:file_cache_path]
# nodePropertiesFilepath = File.join(Chef::Config[:file_cache_path], 'node.properties')

# template nodePropertiesFilepath do
	# source 'node.properties.erb'
	# sensitive true
	# variables(
		# :jenkinsUrl => jnode["jnode_jenkinsUrl"],
		# :user => jnode["jnode_user"],
		# :apiToken => jnode["jnode_apiToken"],
		# :nodeName => nodeName,
		# :labels => labels,
		# :numberOfExecutors => jnode["jnode_numberOfExecutors"],
		# :usageMode => jnode["jnode_usageMode"],
		# :jenkinsFolder => jnode["jnode_jenkinsFolder"],
		# :javaHome => javaHome,
		# :winswVersion => jnode["jnode_winswVersion"],
		# :serviceDomain => jnode["jnode_serviceDomain"],
		# :serviceUser => jnode["jnode_serviceUser"],
		# :servicePassw => jnode["jnode_servicePassw"],
		# :downloadFolder => downloadFolder,
# )
# end

# powershell_script "Read javaHome from environment variable" do
	# code <<-EOH
	# $javaHome = [System.Environment]::GetEnvironmentVariable('CHEF_JDKHOME','Machine').Replace('\\','/').TrimEnd('/\\')
	# if ($javaHome) {
		# $javaHome += "/jre"
	# } else {
		# Write-Host "CHEF_JDKHOME environment variable not found. Looking for CHEF_JAVAHOME environment variable ..."
		# $javaHome = [System.Environment]::GetEnvironmentVariable('CHEF_JAVAHOME','Machine').Replace('\\','/').TrimEnd('/\\')
	# }
	
	# if ($javaHome) {
		# write-host "Updating file: #{nodePropertiesFilepath} ..."
		# write-host "javaHome = $javaHome"
		# (cat "#{nodePropertiesFilepath}").Replace('@@javaHome@@',$javaHome) | Out-File "#{nodePropertiesFilepath}" -Force -Encoding ascii
	# } else {
		# throw "!!ERROR: CHEF_JAVAHOME environment variable not found"
	# }
	# EOH
	# guard_interpreter :powershell_script
# end

# include_recipe 'jenkins_node::create_node_on_jenkins'
# include_recipe 'jenkins_node::install_jenkins_slave_as_ervice'
