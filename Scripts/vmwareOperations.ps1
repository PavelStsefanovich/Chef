
[cmdletbinding()]

Param()


#=== INITIALISATION ===

#--- script attributes
$scriptFullPath = $PSCommandPath
$scriptDirectory = $PWD
$scriptName = $scriptFullPath | Split-Path -Leaf
$themeColor = "DarkGreen"
Write-Verbose "%scriptFullPath% $scriptFullPath"
Write-Verbose "%scriptDirectory% $scriptDirectory"
Write-Verbose "%scriptName% $scriptName"

#--- vmWare PowerCLI
$vmwareScriptsDirectory = "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts"
$vmwarePowercliIni = "Initialize-PowerCLIEnvironment.ps1"
cd $vmwareScriptsDirectory
#Start-Process powershell -ArgumentList ".\$vmwarePowercliIni" -NoNewWindow -PassThru -Wait -WorkingDirectory $vmwareScriptsDirectory
& ".\$vmwarePowercliIni"
cd $scriptDirectory

#--- input parameters



#=== BEGIN ===

Connect-VIServer -Server engvcenter5.athocdevo.com -User "athocdevo\stsefanovich" -Password Zaebali123$
$vmList = Get-VM