# Cookbook:: vm_config

puts " - initializing: [vm_config::default]"

powershell_script 'Disable FSutil' do
  code <<-EOH
    $osVersion = [Environment]::OSVersion.Version.Major + [Environment]::OSVersion.Version.Minor * 0.1
    if ($osVersion -ge 10) {
      fsutil behavior set DisableDeleteNotify NTFS 1
      fsutil behavior set DisableDeleteNotify ReFS 1
    } elseif ($osVersion -ge 6.2) {
      fsutil behavior set DisableDeleteNotify 1
    }
  EOH
end

powershell_script 'Disable FipsPolicy' do
  code <<-EOH
    Set-ItemProperty HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Lsa\\FipsAlgorithmPolicy\\ -Name Enabled -Value 0
  EOH
end
