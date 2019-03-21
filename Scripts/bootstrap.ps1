
[cmdletbinding()]
Param(
    [parameter()]
    [string]$nodeName,

    [parameter()]
    [switch]$checkChefdkInstall

)


#=== INITIALISATION ===
[int]$errorLevel = 0
$scriptFullPath = $PSCommandPath
$scriptDirectory = $scriptFullPath | Split-Path
$scriptName = $scriptFullPath | Split-Path -Leaf
#$chefDirectory = "$scriptDirectory\.chef"

if (!$nodeName) {throw "Parameter <nodeName> not set"}
$nodeFQDN = "$nodeName.athocdevo.com"

#--- Chef
if ($checkChefdkInstall) {
    Write-Output "`nChecking Chef version on build machine..."
    Try {
        chef --version
    }
    Catch {
        throw $_
    }
}

#=== BEGIN ===

#--- clean up
Write-Output "`nChecking if Chef node/client exists..."
$chefClientList = knife client list
$chefNodeList = knife node list

Try {
    $chefClientList | %{if ($_ -eq $nodeName) {Write-Output "`tdeleting client: $nodeName"; knife client delete $nodeName -y}}
    $chefNodeList | %{if ($_ -eq $nodeName) {Write-Output "`tdeleting node: $nodeName"; knife node delete $nodeName -y}}
}
Catch {
    throw $_
}

#--- bootstrap
Try {
    knife bootstrap windows winrm $nodeFQDN --winrm-user athocdevo\bbot --winrm-password 'F0r3Fr0nt!' --node-name $nodeName --node-ssl-verify-mode none --yes # --run-list 'recipe[learn_chef_iis]'
}
Catch {
    throw $_
}

#--- apply config? (ps)




#=== END
Write-Output " "
exit $errorLevel
