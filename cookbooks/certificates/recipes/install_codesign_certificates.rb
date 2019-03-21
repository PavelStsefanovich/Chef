# Cookbook:: certificates

puts " - initializing: [certificates::install_codesign_certificates]"

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
codesignCertificate = env_config["certificates_codesign"]
version_dir = node["certificates"]["codesign"]["major_version_directory"]
certDir = File.join(Chef::Config[:file_cache_path], "Certificates/Codesign")
certDownloadPath = File.join(certDir, codesignCertificate['name'])

if repo_prereqs_path.length > 0
	url = "#{protocol}#{host}/#{path}/#{repo_prereqs_path}/#{version_dir}/#{codesignCertificate['name']}"
else
	url = "#{protocol}#{host}/#{path}/#{version_dir}/#{codesignCertificate['name']}"
end

# EXECUTION

directory certDir do
  action :create
	recursive true
end

remote_file certDownloadPath do
	source url
	headers({ "#{apiHeader}" => "#{apikey}" })
	sensitive true
end

powershell_script "Install Codesign certificate" do
  code <<-EOH
		New-ItemProperty HKLM:/SOFTWARE/Microsoft/Cryptography/Protect/Providers/df9d8cd0-1501-11d1-8c7a-00c04fc297eb/ -Name ProtectionPolicy -Value 1 -PropertyType 'DWord' -ErrorAction SilentlyContinue | Out-Null
		# this is fix for win update 3000850 issue as statet here:
		# https://support.microsoft.com/en-ca/help/3000850/november-2014-update-rollup-for-windows-rt-8-1-windows-8-1-and-windows

		$securePassw = ConvertTo-SecureString "#{codesignCertificate['passw']}" -AsPlainText -Force
		try {
			write-host "Powershell Import-PfxCertificate:"
			Import-PfxCertificate -FilePath "#{certDownloadPath}" -CertStoreLocation Cert:/CurrentUser/My/ -Password $securePassw -ErrorAction Stop | Out-Null
			write-host "certutil.exe:"
			certutil -f -p "#{codesignCertificate['passw']}" -importPFX MY "#{certDownloadPath}"
		} catch {
			throw "!!ERROR: Codesign certificate installation failed."
		}
		[Environment]::SetEnvironmentVariable("CHEF_CODESIGN_CERT_INSTALL", 'true', 'Machine')
	EOH
	not_if "[System.Environment]::GetEnvironmentVariable('CHEF_CODESIGN_CERT_INSTALL','Machine') -eq 'true'"
  guard_interpreter :powershell_script
end
