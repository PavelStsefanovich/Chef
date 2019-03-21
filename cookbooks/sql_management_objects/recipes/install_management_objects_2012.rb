# Cookbook:: sql_management_objects

puts " - initializing: [sql_management_objects::install_management_objects_2012]"

# dependencies
include_recipe 'sql_clrtypes::install_clrtypes_x64_2012'

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

version_dir = node["sql_management_objects"][2012]["management_objects"]["major_version_directory"]
packagefile = node["sql_management_objects"][2012]["management_objects"]["packagefile"]
installname = node["sql_management_objects"][2012]["management_objects"]["installname"]
arguments = node["sql_management_objects"][2012]["management_objects"]["arguments"]

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
  installer_type :msi
  options arguments
	returns [0,1641,3010]
end

include_recipe 'sql_management_objects::install_powershell_tools_2012'
