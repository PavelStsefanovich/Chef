# Cookbook:: br_diagnostics

puts " Cookbook default recipe is called: [br_diagnostics::default]"

env_databag = node['env_databag']
winrm_secret_key = node['winrm_secret']
winrmCredentials = Chef::EncryptedDataBagItem.load(env_databag, "winrm", winrm_secret_key)
winrmUser = winrmCredentials["winrmuser"]
winrmPassword = winrmCredentials["winrmpassw"]

powershell_script "Get Current User info" do
	code <<-EOH
		$whoami = whoami
		write-host "Whoami:`t`t$whoami"
		write-host "User:`t`t$env:USERNAME"
		write-host "Domain:`t`t$env:USERDNSDOMAIN"
		[System.Security.Principal.WindowsIdentity]::GetCurrent()
	EOH
	guard_interpreter :powershell_script
end

powershell_script "Get Chef Process Owner info" do
	code <<-EOH
		$processOwner = (Get-WmiObject win32_process) | ?{$_.processname -eq 'ruby.exe'} | %{$_.getowner()}
		write-host "User:`t`t$($processOwner.user)"
		write-host "Domain:`t`t$($processOwner.domain)"
	EOH
	guard_interpreter :powershell_script
end
