# Cookbook:: sql_cmdlnutils

puts " - initializing: [sql_cmdlnutils::install_mssqlcmdlnutils_13]"

include_recipe 'sql_cmdlnutils::install_msodbcsql_13'

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

version_dir = node["sql_cmdlnutils"][13]["mssqlcmdlnutils"]["major_version_directory"]
packagefile = node["sql_cmdlnutils"][13]["mssqlcmdlnutils"]["packagefile"]
installname = node["sql_cmdlnutils"][13]["mssqlcmdlnutils"]["installname"]
arguments = node["sql_cmdlnutils"][13]["mssqlcmdlnutils"]["arguments"]

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
end
