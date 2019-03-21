# Cookbook:: sql_clrtypes

puts " - initializing: [sql_clrtypes::types2008.rb]"

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

packagefile = node["sql_clrtypes"]["types2008"]["packagefile"]
installname = node["sql_clrtypes"]["types2008"]["installname"]
arguments = node["sql_clrtypes"]["types2008"]["arguments"]
repo_prereqs_path = node["repo_prereqs_path"]

packagepath = File.join(Chef::Config[:file_cache_path], packagefile)
url = "#{protocol}#{host}/#{path}/#{repo_prereqs_path}/#{packagefile}"

remote_file packagepath do
	source url
	headers({ "X-JFrog-Art-Api" => "#{apikey}" })
end

windows_package installname do
  source packagepath
  installer_type :msi
  options arguments
end