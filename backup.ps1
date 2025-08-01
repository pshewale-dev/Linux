# Directory to store registry backups
$backupDir = "C:\RegBackup_CBS"
New-Item -Path $backupDir -ItemType Directory -Force | Out-Null

# Base registry path for CBS packages
$baseRegPath = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages"

# List of 58 package names to export
$packageKeys = @(
    "Microsoft-RemoteFileSystems-DfsMgmt~31bf3856ad364e35~amd64~~10.0.20348.1787",
    "Microsoft-Windows-CCFFilter-Package~31bf3856ad364e35~amd64~~10.0.20348.643",
    "Microsoft-Windows-DiskIo-QoS-Package~31bf3856ad364e35~amd64~~10.0.20348.380",
    "Microsoft-Windows-PeerDist-Hash-Package~31bf3856ad364e35~amd64~~10.0.20348.946",
    "Microsoft-Windows-RemoteFS-PNRP-Provider~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-DataCenterBridging-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-File-Services~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-FSRM-Mgmt~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-FSRM~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-FSRM-TUI~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-OfflineFiles~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-RemoteFS-Mgmt~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-RemoteFS~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-SMBWitness~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-RSAT-VSSMgmt~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-SMI-ADS-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-Storage-BusCache~31bf3856ad364e35~amd64~~10.0.20348.1726",
    "Microsoft-Windows-Storage-ClusterRebalance-Package~31bf3856ad364e35~amd64~~10.0.20348.1461",
    "Microsoft-Windows-Storage-Fsrm-Api~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-Storage-Fsrm-Provider-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-Storage-Fsrm~31bf3856ad364e35~amd64~~10.0.20348.1850",
    "Microsoft-Windows-Storage-NetCmdlets~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-Storage-QoS-Cmdlets~31bf3856ad364e35~amd64~~10.0.20348.1850",
    "Microsoft-Windows-Storage-QoS-PolicyManager-Cmdlets~31bf3856ad364e35~amd64~~10.0.20348.1850",
    "Microsoft-Windows-Storage-QoS~31bf3856ad364e35~amd64~~10.0.20348.1726",
    "Microsoft-Windows-Storage-Replica-AdminPack-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-Storage-Replica-Client-Package~31bf3856ad364e35~amd64~~10.0.20348.1787",
    "Microsoft-Windows-Storage-Replica-Package~31bf3856ad364e35~amd64~~10.0.20348.1787",
    "Microsoft-Windows-Storage-WMIProvider~31bf3856ad364e35~amd64~~10.0.20348.1726",
    "Microsoft-Windows-StorPort-Devices-Emmc~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-StorPort-Devices-Fua~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-StorPort-Devices-Scsi~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-SystemRestore-DataProtection-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-SystemRestore-FsFilter-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-VSS-Admin-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-VSS-IDL-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-VSS-VssApi-Package~31bf3856ad364e35~amd64~~10.0.20348.1787",
    "Microsoft-Windows-VSS-VssPs-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-VSS-VssService-Package~31bf3856ad364e35~amd64~~10.0.20348.380",
    "Microsoft-Windows-VSS-VssVue-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-VSSAdmin-UI-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-VssTools-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-VssTools-UI-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-VssVue-UI-Package~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-WmiEp-Pkg~31bf3856ad364e35~amd64~~10.0.20348.1461",
    "Microsoft-Windows-WmiFilter-Package~31bf3856ad364e35~amd64~~10.0.20348.1071",
    "Microsoft-Windows-WmiProvider-Package~31bf3856ad364e35~amd64~~10.0.20348.1071",
    "Microsoft-Windows-WmiTools-Package~31bf3856ad364e35~amd64~~10.0.20348.1071",
    "Microsoft-Windows-WUSA-UI-Package~31bf3856ad364e35~amd64~~10.0.20348.1071",
    "Microsoft-Windows-ZTI-WDS-SetupProvider~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-ZTI-WDSClient~31bf3856ad364e35~amd64~~10.0.20348.1787",
    "Microsoft-Windows-ZTI-WDSTools~31bf3856ad364e35~amd64~~10.0.20348.1",
    "Microsoft-Windows-ZTI-WDSUI~31bf3856ad364e35~amd64~~10.0.20348.1"
)

# Loop through each key and export it
foreach ($pkg in $packageKeys) {
    $regPath = "$baseRegPath\$pkg"
    $safeName = $pkg -replace '[\\\/:*?"<>|]', '_' # sanitize filename
    $backupFile = Join-Path $backupDir "$safeName.reg"

    try {
        reg export "$regPath" "$backupFile" /y
        Write-Output "✅ Exported: $pkg"
    }
    catch {
        Write-Warning "⚠️ Failed to export: $pkg. Error: $_"
    }
}

Write-Host "`n🗂️ All registry keys exported to: $backupDir"