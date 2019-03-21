[cmdletbinding(HelpUri = "https://ewiki.athoc.com/display/BR/Chef.List.Resources.ps1")]

Param(
    [parameter()]
    [string]$NodeListFilename = 'nodelist.txt',

    [parameter()]
    [string]$RoleListFilename = 'rolelist.txt',

    [parameter()]
    [string]$WorkingDir = $PSScriptRoot
)


#=== INITIALISATION
$ErrorActionPreference = "Stop"
[int]$errorLevel = 0
$errorPref = "!!ERROR:"

#=== BEGIN

#- nodelist
Write-Host " >> Getting list of NODES from Chef Server ..."
$knifeOutNodelist = knife node list -F json
try {
    [string]$knifeOutNodelist | ConvertFrom-Json | Tee-Object -FilePath "$WorkingDir\$NodeListFilename"
} catch {
    throw "$errorPref $knifeOutNodelist"
}

#- rolelist
Write-Host " >> Getting list of ROLES from Chef Server ..."
$knifeOutRolelist = knife role list -F json
try {
    [string]$knifeOutRolelist | ConvertFrom-Json | Tee-Object -FilePath "$WorkingDir\$RoleListFilename"
} catch {
    throw "$errorPref $knifeOutRolelist"
}

