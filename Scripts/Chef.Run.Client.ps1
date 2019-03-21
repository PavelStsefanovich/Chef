[cmdletbinding(HelpUri = "https://ewiki.athoc.com/display/BR/Chef.Run.Client.ps1")]

Param(
    [parameter()]
    [string]$Nodename,

    [parameter()]
    [string]$Environment,

    [parameter()]
    [string]$Role,

    [parameter()]
    [string]$RunList,

	[parameter()]
    [string]$AttributesFile,
		
    [parameter()]
    [string]$WorkingDir = $PSScriptRoot,

    [parameter()]
    [int]$ChefClientTimeout = 60,

    [parameter()]
    [switch]$ChefVerbose
)


#=== INITIALISATION
[int]$errorLevel = 0
$errorPref = "!!ERROR:"

$Nodename = $Nodename.ToLower()
$Environment = $Environment.ToUpper()
$Role = $Role.ToLower()
$RunList = $RunList.TrimStart("`'`"").TrimEnd("`'`"")
if ($AttributesFile) {
    $AttributesFile = (Resolve-Path $AttributesFile -ErrorAction Stop).Path
}

#- Print input params
    Write-Host "______________________________________________"
    Write-Host "INPUT PARAMETERS:`n"
    Write-Host "Nodename:`t`t$Nodename"
    if ($Environment) {Write-Host "Environment:`t`t$Environment"}
    if ($Role) {Write-Host "Role:`t`t`t$Role"}
    if ($RunList) {Write-Host "RunList:`t`t'$RunList'"}
    if ($AttributesFile) {Write-Host "AttributesFile:`t$AttributesFile"}
    Write-Host "WorkingDir:`t`t$WorkingDir"
    Write-Host " "
    Write-Host "ChefClientTimeout:`t$ChefClientTimeout minutes"
    Write-Host "ChefVerbose:`t`t$ChefVerbose"
    Write-Host "______________________________________________"


#=== BEGIN

#- construct argument line
$ChefclientArgumentsLine = ""

#- environment
if ($Environment) {
    $ChefclientArgumentsLine += (" -E " + $Environment)
}

#- run-list
if ($Role -or $RunList) {

    $ChefclientRunlist = " -r '"

    if ($Role) {
        $ChefRole = "role[$Role],"
        $ChefclientRunlist += $ChefRole
    }

    if ($RunList) {
        $ChefclientRunlist += ($RunList.Trim("`'`"") + ',')
    }
    
    $ChefclientRunlist = ($ChefclientRunlist.TrimEnd(',') + "'")
    $ChefclientArgumentsLine += $ChefclientRunlist
    Write-Host ("RUN-LIST: " + $ChefclientRunlist.Replace('-r','').Trim())
}

#- attributes-file
if ($AttributesFile) {
    $ChefclientArgumentsLine += " -j '$AttributesFile'"
}

#- verbose 
if ($ChefVerbose) {
    $ChefclientArgumentsLine += " -l debug"
}
    
Write-Verbose " Chef-client full command line command:"
Write-Verbose ("  > chef-client" + $ChefclientArgumentsLine)

#- killing any hanging ruby process
$rubyProcesses = gps ruby -ErrorAction SilentlyContinue | ?{($_.Path -like '*chef*') -or ($_.Path -like '*opscode*')}
if ($rubyProcesses) {
    Write-Verbose "Found running chef-client process"
    if ($rubyProcesses.count -eq 1) {
        $chefclientRuntime = (New-TimeSpan -Start $rubyProcesses.StartTime).Minutes
        if ($chefclientRuntime -gt $ChefClientTimeout) {
            $rubyProcesses | kill -Force
        } else {
            Write-Warning "<chef-client> appears to be running on target system for `$chefclientRuntime minutes"
            Write-Warning "Current <chef-client> timeout time is set to: $ChefClientTimeout minutes"
            Write-Warning "ABORTED"
        }
    } else {
        Write-Verbose "Killing <chef-client> ..."
        $rubyProcesses | %{kill -Force}
    }
}


#--- chef-client run
Write-Host "`nchef-client output:`n"
try {
    if ($ChefclientArgumentsLine.Length -gt 0) {
        Invoke-Expression "chef-client $ChefclientArgumentsLine" -ErrorAction Stop | Tee-Object -Variable chefclientout
    } else {
        Invoke-Expression "chef-client" -ErrorAction Stop | Tee-Object -Variable chefclientout
    }
} catch {
    Write-Error $_
    throw "$errorPref 'chef-client' FAILED"
}

if ($chefclientout -like '*================================================================================*') {
    throw "$errorPref 'chef-client' FAILED"
}

Write-Host "`nchef-client run complete"
exit 0

#=== END