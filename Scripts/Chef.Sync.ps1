[cmdletbinding(HelpUri = "https://ewiki.athoc.com/display/BR/Chef.Sync.ps1")]

Param(
    [parameter()]
    [string]$WorkingDir = (Resolve-Path "$PSScriptRoot\.."),

    [parameter()]
    [switch]$Force
)


function Run-Process ([string]$processName,[string]$arguments,[string]$processWorkingDirectory) {

    [hashtable]$output = @{}

    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = "$processName"
    $pinfo.RedirectStandardError = $true
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $pinfo.Arguments = "$arguments"
    if ($processWorkingDirectory) {
      $pinfo.WorkingDirectory = $processWorkingDirectory
    }
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    Try {$p.Start()}
    Catch {throw $_}
    $stdout = $p.StandardOutput.ReadToEnd()
    $stderr = $p.StandardError.ReadToEnd()
    $p.WaitForExit()

    $output.stdout = $stdout
    $output.stderr = $stderr
    $output.errcode = $p.ExitCode

    Write-Verbose ("stdout: " +$stdout)
    Write-Verbose ("stderr: " +$stderr)
    Write-Verbose ("errcode: " +$p.ExitCode)

    return $output
}


#=== INITIALISATION

$ErrorActionPreference = 'Stop'
[int]$errorLevel = 0
$errorPref = "!!ERROR:"

$knifePath = where.exe knife.bat

#- Print input params
    Write-Host "______________________________________________"
    Write-Host "WorkingDir:`t`t$WorkingDir"
		if ($Force) {
			Write-Host "Force:`t`t`tTrue"
		}
    Write-Host "______________________________________________"


#=== BEGIN

#- find path to knife.bat
$knifePath = (Get-Command knife.bat).Path
Write-Verbose "<knifePath> : '$knifePath'"

#- sync
Write-Host " >> Syncing ... "
$arguments = "upload /roles/* /cookbooks/* /environments/* --freeze --repo-mode static"
if ($Force) {
	$arguments += " --force"
}

$proc = Run-Process $knifePath -arguments $arguments -processWorkingDirectory $WorkingDir

write-host $proc.stdout
write-host $proc.stderr

if ($proc.errcode -eq 0) {
    if (!$proc.stdout) {
        Write-Warning "knife did not detect any changes, nothing uploaded"
    }
} else {
    Write-Warning "knife finished with exit code: $($proc.errcode)"
    throw "$errorPref $($proc.stderr)"
}
