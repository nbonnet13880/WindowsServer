#######################################################################################################################################
# Nicolas BONNET - 24 Janvier 2021                                                                                                    #
# Enable Bitlocker                                                                                                                    #
#######################################################################################################################################

#Windows for enter Pin Code. This Pin Code is stored on Powershell variable
#CodePin variable is converted on secure string.

add-type -assemblyName "Microsoft.VisualBasic"
$CodePin = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the desired Pin Code", "Valeur")
$Codepin=ConvertTo-SecureString $Codepin -AsPlainText -force

#TPM is tested. If it's not present, Warning is displayed and script is stopped
$TPMPresent=get-tpm

if ($TPMPresent.TpmPresent -eq $false)
{
Write-Host "No TPM chip present, Bitlocker activation is not possible"
exit
}

#TPM chip has tested. If it's been initialized, message appear. Else it's initialized. If restart is required, computer is restarted.
$EtatTPM = Initialize-Tpm

if ($EtatTPM.TpmReady -eq $true)
{
    Write-Host 'TPM Chip activated'
}
elseif ($EtatTPM.TpmReady -eq $false)
{
    Write-Host 'TPM chip not activated'
    Initialize-Tpm -AllowPhysicalPresence -AllowClear
    Write-Host 'Initialization of the TPM chip done, please proceed to a reboot and then restart the script.'
    exit
}

if ($EtatTPM.RestartRequired -eq $true)
{
    Write-Host 'A reboot is required'
    exit
}


if ($EtatTPM.ClearRequired -eq $true)
{
    Write-Host 'Clear the TPM chip is required'
    exit
}


#The script test if volume is already protected or not. If it's not enable, Bitlocker is enabled.
$PartitionsurPC=get-bitlockervolume
foreach ($PartitionsurPC in $PartitionsurPC)
{
    $LectPC=$PartitionsurPC.mountpoint
    [string]$BitActif=Get-BitLockerVolume -MountPoint $lectpc | select Protectionstatus

if ($BitActif -eq '@{ProtectionStatus=On}')
{
    Write-Host "The volume $lectpc is already Bitlocker"
    
}
elseif ($BitActif -eq '@{ProtectionStatus=Off}' -and ($LectPC -eq "c:"))
{
    Write-Host "Enable bitlocker on volume $Lectpc"
    #Add protector
    Add-BitLockerKeyProtector -MountPoint $LectPC -Pin $Codepin -TpmAndPinProtector 
    #Recovery key on AD
    Add-BitLockerKeyProtector -MountPoint $LectPC -RecoveryPasswordProtector
	Backup-BitLockerKeyProtector -MountPoint $LectPC -KeyProtectorId (
    (Get-BitLockerVolume -MountPoint $LectPC).KeyProtector | Where KeyProtectorType -eq RecoveryPassword).KeyProtectorId
    manage-bde.exe -on $LectPC 
}
elseif ($BitActif -eq '@{ProtectionStatus=Off}' -and ($LectPC -eq "D:"))
{
    Write-Host "Activation de bitlocker sur lecteur $Lectpc"
    #Add protector
    Add-BitLockerKeyProtector -MountPoint $LectPC -RecoveryPasswordProtector
	Enable-BitLocker $LectPC -PasswordProtector $Codepin
   
}

}
 
#Restart  computer                                                                                                                                         
$Restartpc = [Microsoft.VisualBasic.Interaction]::MsgBox("It is necessary to restart the computer. Do you want to restart now ?",'YesNoCancel,Question')
if ($Restartpc -eq "yes") 
{
	shutdown -r -t 0
} 
