# Cookbook:: athoc_iws

puts " - initializing: [athoc_iws::msi_install]"

# CONFIGURATION and PARAMETERS EVALUATION
env_databag = node['env_databag']

# data bags
repositories_secret_key = node['repositories_secret']
repositories = Chef::EncryptedDataBagItem.load(env_databag, "repositories", repositories_secret_key)

# attributes
DEBUG = node["athoc_iws"]["debug"]
MSI_LOGS_DIRECTORY = node["athoc_iws"]["msi_logs_directory"]

MSI_REPOSITORY = node["athoc_iws"]["REPOSITORY"]
MSI_REPOSITORY_LAYOUT = node["athoc_iws"]["REPOSITORY_LAYOUT"]
MSI_PRODUCT_NAME = node["athoc_iws"]["PRODUCT_NAME"]
MSI_BRANCH = node["athoc_iws"]["BRANCH"]
MSI_BUILD_NUMBER = node["athoc_iws"]["BUILD_NUMBER"]
MSI_PATCH_LEVEL = node["athoc_iws"]["PATCH_LEVEL"]
MSI_PREVIOUS_BUILD_NUMBER = node["athoc_iws"]["PREVIOUS_BUILD_NUMBER"]
MSI_FEATURES = node["athoc_iws"]["FEATURES"]
MSI_PRODUCT_CONFIGURATION = node["athoc_iws"]["PRODUCT_CONFIGURATION"]

puts "________________________________________________________________________________"
puts " MSI Parameters:"
puts " "
puts " MSI_PRODUCT_NAME\t\t#{MSI_PRODUCT_NAME}"
puts " MSI_REPOSITORY\t\t#{MSI_REPOSITORY}"
puts " MSI_REPOSITORY_LAYOUT\t\t#{MSI_REPOSITORY_LAYOUT}"
puts " MSI_BRANCH\t\t\t#{MSI_BRANCH}"
puts " MSI_BUILD_NUMBER\t\t#{MSI_BUILD_NUMBER}"
puts " MSI_PATCH_LEVEL\t\t#{MSI_PATCH_LEVEL}"
puts " MSI_FEATURES\t\t\t#{MSI_FEATURES}"
if MSI_PRODUCT_CONFIGURATION == 'not_set'
	puts " MSI_PRODUCT_CONFIGURATION\t#{MSI_PRODUCT_CONFIGURATION}"
else
	puts " MSI_PRODUCT_CONFIGURATION\t{ ***** Secure content }"
end
puts "________________________________________________________________________________"

if MSI_PRODUCT_NAME == 'not_set' ||
		MSI_REPOSITORY == 'not_set' ||
		MSI_REPOSITORY_LAYOUT == 'not_set' ||
		MSI_BRANCH == 'not_set' ||
		MSI_BUILD_NUMBER == 'not_set' ||
		MSI_PATCH_LEVEL == 'not_set' ||
		MSI_FEATURES == 'not_set' ||
		MSI_PRODUCT_CONFIGURATION == 'not_set'
	
	raise "Some MSI_ attributes are not set! Make sure that MSI configuration file is provided, i.e. 'chef-clint -j <configFileName>.json'"
end	

# constructed parameters
MSI_MAJOR_VERSION = MSI_BRANCH.split('.')[0]
MSI_MINOR_VERSION = MSI_BRANCH.split('.')[1]

msi_name = node["athoc_iws"]["PACKAGE_NAME_LAYOUTS"]["#{MSI_REPOSITORY_LAYOUT}"]
msi_name = msi_name.gsub('@product_name@',MSI_PRODUCT_NAME)
msi_name = msi_name.gsub('@majorVersion@',MSI_MAJOR_VERSION)
msi_name = msi_name.gsub('@minorVersion@',MSI_MINOR_VERSION)
msi_name = msi_name.gsub('@patch_level@',MSI_PATCH_LEVEL)
msi_name = msi_name.gsub('@build_number@',MSI_BUILD_NUMBER)
MSI_NAME = msi_name

msi_url = node["athoc_iws"]["PACKAGE_REPOSITORY_LAYOUTS"]["#{MSI_REPOSITORY_LAYOUT}"]
msi_url = msi_url.gsub('@url@',repositories["#{MSI_REPOSITORY}"]["url"])
msi_url = msi_url.gsub('@product_name@',MSI_PRODUCT_NAME)
msi_url = msi_url.gsub('@majorVersion@',MSI_MAJOR_VERSION)
msi_url = msi_url.gsub('@minorVersion@',MSI_MINOR_VERSION)
msi_url = msi_url.gsub('@build_number@',MSI_BUILD_NUMBER)
msi_url = msi_url.gsub('@msi_name@',MSI_NAME)
MSI_URL = msi_url

apiHeader = repositories["#{MSI_REPOSITORY}"]["apiHeader"]
apikey = repositories["#{MSI_REPOSITORY}"]["apikey"]
packagepath = File.join(Chef::Config[:file_cache_path], MSI_NAME)

puts " MSI_NAME\t\t\t#{MSI_NAME}"
puts " MSI_URL\t\t\t#{MSI_URL}"
puts "________________________________________________________________________________"

# EXECUTION

remote_file packagepath do
	source MSI_URL
	headers({ "#{apiHeader}" => "#{apikey}" })
end

powershell_script "Run #{MSI_NAME}" do
	cwd Chef::Config[:file_cache_path]
	code <<-EOH
		$DEBUG = if ("#{DEBUG}" -eq 'true') {$true} else {$false}
		$PACKAGENAME = "#{MSI_NAME}"
		$MSI_FEATURES = ConvertFrom-StringData ('#{node["athoc_iws"]["FEATURES"]}' -replace ('[{}"]','')).Replace('=>','=').Replace(',',"`n")
		$MSI_PRODUCT_CONFIGURATION = ConvertFrom-StringData ('#{node["athoc_iws"]["PRODUCT_CONFIGURATION"]}' -replace ('[{}"]','')).Replace('=>','=').Replace(',',"`n")
		if (($MSI_FEATURES.INSTALL_APP -eq '1') -and ($MSI_FEATURES.INSTALL_DB -eq '')) {	#(ps:empty string) this must be corrected to use '0' instead of empty string in upcoming release
			$logFeature = "_APP_"
		} elseif (($MSI_FEATURES.INSTALL_APP -eq '') -and ($MSI_FEATURES.INSTALL_DB -eq '1')) {		#(ps:empty string)
			$logFeature = "_DB_"
		} else {
			$errorMessage = @"

!!ERROR: Invalid MSI_FEATURES configuration.
"@
			throw $errorMessage
		}
		$LOGPATH = "#{MSI_LOGS_DIRECTORY}/" + $PACKAGENAME.Replace('.msi',$logFeature)  + (Get-Date -Format yyyy-MM-ddTHH-mm-ss).ToString() + ".log"

		# msiexec arguments
		$MSI_ARGUMENTLIST = "/qn /i $PACKAGENAME /l*v `"$LOGPATH`""
		$MSI_ARGUMENTLIST += " INSTALL_APP=`"$($MSI_FEATURES.INSTALL_APP)`""
		$MSI_ARGUMENTLIST += " INSTALL_DB=`"$($MSI_FEATURES.INSTALL_DB)`""

		if ($MSI_FEATURES.INSTALL_APP -eq '1') {
			$MSI_ARGUMENTLIST += " ADDLOCAL=`"AppFeature`""
			$MSI_ARGUMENTLIST += " SYSTEM_URL=`"$($MSI_PRODUCT_CONFIGURATION.SYSTEM_URL)`""
			$MSI_ARGUMENTLIST += " APP_DIR=`"$($MSI_PRODUCT_CONFIGURATION.APP_DIR)`""
		}
		
		if ($MSI_FEATURES.INSTALL_DB -eq '1') {
			$MSI_ARGUMENTLIST += " ADDLOCAL=`"DBFeature`""
			$MSI_ARGUMENTLIST += " DB_DIR=`"$($MSI_PRODUCT_CONFIGURATION.DB_DIR)`""
			$MSI_ARGUMENTLIST += " DB_LOG_DIR=`"$($MSI_PRODUCT_CONFIGURATION.DB_LOG_DIR)`""
			$MSI_ARGUMENTLIST += " DB_ARCHIVE_DIR=`"$($MSI_PRODUCT_CONFIGURATION.DB_ARCHIVE_DIR)`""
		}

		$MSI_ARGUMENTLIST += " SQL_SERVER_INSTANCE=`"$($MSI_PRODUCT_CONFIGURATION.SQL_SERVER_INSTANCE)`""	# (ps)here we might need to implement logic for default instance
		$MSI_ARGUMENTLIST += " IS_SQL_AUTH=`"$($MSI_PRODUCT_CONFIGURATION.IS_SQL_AUTH)`""
		$MSI_ARGUMENTLIST += " USE_DEF_VAL=`"$($MSI_PRODUCT_CONFIGURATION.USE_DEF_VAL)`""
		
		if ($MSI_PRODUCT_CONFIGURATION.IS_SQL_AUTH -eq '1') {
			$MSI_ARGUMENTLIST += " SQL_LOGIN_NAME=`"$($MSI_PRODUCT_CONFIGURATION.SQL_LOGIN_NAME)`""
			$MSI_ARGUMENTLIST += " SQL_LOGIN_PASSWORD=`"$($MSI_PRODUCT_CONFIGURATION.SQL_LOGIN_PASSWORD)`""
		}

		if ($MSI_PRODUCT_CONFIGURATION.USE_DEF_VAL -eq '0') {
			$MSI_ARGUMENTLIST += " NGAD_PASSWORD=`"$($MSI_PRODUCT_CONFIGURATION.NGAD_PASSWORD)`""
		}		
		
		# verbose output for debugging
		if ($DEBUG) {
			Write-Host "(DEBUG) PACKAGENAME: $PACKAGENAME"
			Write-Host "(DEBUG) LOGPATH: $LOGPATH"
			Write-Host "(DEBUG) MSI_FEATURES:"
			$MSI_FEATURES
			Write-Host "(DEBUG) MSI_PRODUCT_CONFIGURATION:"
			$MSI_PRODUCT_CONFIGURATION
			Write-Host "(DEBUG) arguments: $MSI_ARGUMENTLIST"
		}

		Write-Host " >> Creating Logs directory, if does not exist: #{MSI_LOGS_DIRECTORY} ..."
		mkdir "#{MSI_LOGS_DIRECTORY}" -Force -ErrorAction Stop | Out-Null

		Write-Host " >> Invoking MSI: $PACKAGENAME ..."
		$MSI_Run_Result = (Start-Process msiexec -NoNewWindow -Wait -PassThru -ArgumentList $MSI_ARGUMENTLIST).ExitCode
		
		if ($MSI_Run_Result -ne 0) {
			$errorMessage = @"

MSI invokation failed with exit code: $MSI_Run_Result
Please refer to the log file for details: $LOGPATH
"@
			throw $errorMessage
		}
	EOH
	guard_interpreter :powershell_script
end
