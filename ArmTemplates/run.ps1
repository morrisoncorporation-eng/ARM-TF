Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
$env:SEE_MASK_NOZONECHECKS = 1

# Set Timezone to Eastern
Set-TimeZone -Name "Eastern Standard Time"
tzutil /s "Eastern Standard Time"

# Install Telnet client
Install-WindowsFeature -name Telnet-Client


# Change DVDRom Drive to Z:
Get-WmiObject -Class Win32_volume -Filter 'DriveType=5' | Select-Object -First 1 | Set-WmiInstance -Arguments @{DriveLetter='Z:'}

# Create Firewall Logs Directory and configure settings
mkdir "C:\Firewall Logs"
Set-NetFirewallProfile -Name Domain -LogBlocked True -LogFileName "C:\Firewall Logs\pfirewall.log"
Set-NetFirewallProfile -Name Public -LogBlocked True -LogFileName "C:\Firewall Logs\pfirewall.log"
Set-NetFirewallProfile -Name Private -LogBlocked True -LogFileName "C:\Firewall Logs\pfirewall.log"

# Install Software

$acctKey = ConvertTo-SecureString -String "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\hmssoftwaredepotstdsa", $acctKey
New-PSDrive -Name Y -PSProvider FileSystem -Persist -Scope Global -Root "\\hmssoftwaredepotstdsa.file.core.windows.net\windows-software" -Credential $credential

$msifile = 'y:\Nessus Agent 7.7.0-x64\NessusAgent-7.7.0-x64.msi'
$arguments = 'NESSUS_GROUPS="HMS-WINDOWS" NESSUS_SERVER="ns-manager.itsec.harvard.edu:8834" NESSUS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx /qn'
Start-Process -file $msifile -arg $arguments -passthru | wait-process

$msifile1 = 'y:\Splunk\splunkforwarder-7.2.6-c0bf0f679ce9-x64-release.msi'
$arguments1 = 'GENRANDOMPASSWORD=1 AGREETOLICENSE=yes /quiet /l*v SplunkInstall.log'
Start-Process -file $msifile1 -arg $arguments1 -passthru | wait-process

mkdir "C:\Program Files\SplunkUniversalForwarder\etc\apps\hms_all_deploymentclient"
xcopy /e /v "y:\Splunk\hms_all_deploymentclient" "C:\Program Files\SplunkUniversalForwarder\etc\apps\hms_all_deploymentclient"

$msifile2 = 'y:\PMPAgent\PatchManagerPlusAgent.msi'
$arguments2 = 'TRANSFORMS="PatchManagerPlusAgent.mst" ENABLESILENT=yes REBOOT=ReallySuppress /lv Agentinstalllog.txt /qn'
Start-Process -file $msifile2 -arg $arguments2 -passthru | wait-process

$msifile3 = 'y:\CrowdStrike Binaries\WindowsSensor-2.exe'
$arguments3 = '/install /quiet CID=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
Start-Process -file $msifile3 -arg $arguments3 -passthru | wait-process

$msifile4 = 'y:\ESET\ESMC_Installer_x64_en_US.exe'
$arguments4 = '--silent --accepteula'
Start-Process -file $msifile4 -arg $arguments4 -passthru | wait-process


# Remove Mapped Drive
Remove-PSDrive -Name Y