[cmdletbinding(HelpUri = "https://ewiki.athoc.com/display/BR/Chef.Bootstrap.ps1")]

Param(
    [parameter(Mandatory = $true)]
    [string]$Nodename,

    [parameter()]
    [string]$DomainName,

    [parameter()]
    [string]$WinrmUser,

    [parameter()]
    [string]$WinrmPassw,

    [parameter()]
    [string]$WinrmSecretkeyFile,

    [parameter()]
    [string]$Environment,

    [parameter()]
    [string]$Role,

    [parameter()]
    [string]$RunList,

    [parameter()]
    [string]$WorkingDir = $PSScriptRoot,

    [parameter()]
    [switch]$ChefNodeReplace,

    [parameter()]
    [switch]$BootstrapVerbose
)


#=== INITIALISATION
$ErrorActionPreference = "Stop"
[int]$errorLevel = 0
$errorPref = "!!ERROR:"
#- check if winrm credentials provided
if (!(($WinrmUser -and $WinrmPassw) -or $WinrmSecretkeyFile)) {
    throw "$errorPref Winrm credentials or Winrm secrect key must be provided."
}
#- get WinRM credentials for environment from Chef
if ($WinrmSecretkeyFile) {
    $WinrmCredentials = ConvertFrom-Json (((knife data bag show ($Environment.ToLower()) winrm --secret-file "$WinrmSecretkeyFile" -F json) -replace('Encrypted.*','')) -join("`n"))
    $WinrmUser = $WinrmCredentials.winrmuser
    $WinrmPassw = $WinrmCredentials.winrmpassw
}
$Nodename = $Nodename.ToLower()
$Environment = $Environment.ToUpper()
$Role = $Role.ToLower()
$RunList = $RunList.TrimStart("`'`"").TrimEnd("`'`"")

#- Print input params
    Write-Host "______________________________________________"
    Write-Host "INPUT PARAMETERS:`n"
    Write-Host "Nodename:`t`t$Nodename"
    if ($WinrmSecretkeyFile) {Write-Verbose "`t%WinrmSecretkeyFile%:`t$WinrmSecretkeyFile"}
    if ($WinrmUser.Length -gt 0) { Write-Host "WinrmUser:`t`t$WinrmUser"} else {throw "$errorPref No Winrm User provided."}
    if ($WinrmPassw.Length -gt 0) {Write-Host "WinrmPassw:`t`t*****"} else {throw "$errorPref No Winrm Password provided."}
    if ($Environment) {Write-Host "Environment:`t`t$Environment"}
    if ($Role) {Write-Host "Role:`t`t`t$Role"}
    if ($RunList) {Write-Host "RunList:`t`t$RunList"}
    Write-Host "WorkingDir:`t`t$WorkingDir"
    Write-Host "ChefNodeReplace:`t$ChefNodeReplace"
    Write-Host "BootstrapVerbose:`t$BootstrapVerbose"
    Write-Host "______________________________________________"

#=== BEGIN

#- (ps) check if node WinRM is accessible

#- clean up
if ($ChefNodeReplace) {
    $chefClientList = knife client list
    $chefNodeList = knife node list
    
    if ($Nodename -in $chefClientList) {
        Write-Host "Existing Chef client found: '$Nodename', replacing ..."
        knife client delete $Nodename -y
    }
    if ($Nodename -in $chefNodeList) {
        Write-Host "Existing Chef node found: '$Nodename', replacing ..."
        knife node delete $Nodename -y
    }
}

#- construct knife argument line
if ($DomainName) {
    $NodenameFQDN = $Nodename + "." + $DomainName
} else {
    $NodenameFQDN = $Nodename + "." + (Get-WmiObject win32_computersystem).Domain
}
$BootstrapArgumentsLine = "bootstrap windows winrm $NodenameFQDN --winrm-user $WinrmUser --winrm-password '$WinrmPassw' --auth-timeout 1 --node-name $Nodename --node-ssl-verify-mode none --yes"

#- environment
if ($Environment) {
    $BootstrapArgumentsLine += " -E $Environment"
    Write-Host "ENVIRONMENT: $Environment"
} else {
    Write-Host "!! No Environment specified, the node will be bootstrapped in default Environment."
}

#- run-list
if ($Role -or $RunList) {
    $bootRunlist = " -r '"

    if ($Role) {
        $ChefRole = "role[$Role],"
        $bootRunlist += $ChefRole
    }

    if ($RunList) {
        $bootRunlist += ($RunList.Trim("`'`"") + ',')
    }
    
    $bootRunlist = ($bootRunlist.TrimEnd(',') + "'")
    $BootstrapArgumentsLine += $bootRunlist
    Write-Host ("RUN-LIST: " + $bootRunlist.Replace('-r','').Trim())
} else {
    Write-Host "!! No Role or Runlist specified, the node will be bootstrapped with empty run-list."
}

#- verbose 
if ($BootstrapVerbose) {
    $BootstrapArgumentsLine += " -VV"
}
    
Write-Verbose "`tKnife full command line command:"
Write-Verbose ("`t > knife " + ($BootstrapArgumentsLine -Replace('--winrm-password.*--node-name','--winrm-password ***** --node-name')) + "`n")

#--- bootstrap
rm "$WorkingDir/bootstraperror.txt" -Force -ErrorAction SilentlyContinue
start knife -ArgumentList $BootstrapArgumentsLine -NoNewWindow -PassThru -Wait -RedirectStandardError "$WorkingDir/bootstraperror.txt" | Out-Null
$bootstrapError = cat "$WorkingDir/bootstraperror.txt" -Raw
if ($bootstrapError -clike '*ERROR:*') {
	if ($bootstrapError -notlike '*Bootstrap command returned 35*') {
    Write-Host $bootstrapError
    throw "'knife bootstrap' FAILED."
	}
}

Write-Host "Restarting Jenkins slave, if installed ..."
$securedWinrmPassw = ConvertTo-SecureString $WinrmPassw -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $WinrmUser, $securedWinrmPassw
Invoke-Command -ComputerName $NodenameFQDN -Credential $Credential -ScriptBlock { Get-Service 'jenkinsslave' -ErrorAction SilentlyContinue | Restart-Service } -ErrorAction Continue

#=== END