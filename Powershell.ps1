add-type -assemblyName "Microsoft.VisualBasic"
$CodePin = [Microsoft.VisualBasic.Interaction]::InputBox("Saisissez le code Pin souhaité", "Valeur")



$Codepin=ConvertTo-SecureString $Codepin -AsPlainText -force

#Test de la présence de la puce TPM
$TPMPresent=get-tpm

if ($TPMPresent.TpmPresent -eq $false)
{
Write-Host "Aucune Puce TPM présente, l'activation de Bitlocker n'est pas possible"
exit
}

#Test de l'initialisation de la puce TPM et activation de l'initialisation si besoin
$EtatTPM = Initialize-Tpm

if ($EtatTPM.TpmReady -eq $true)
{
    Write-Host 'Puce TPM activée'
}
elseif ($EtatTPM.TpmReady -eq $false)
{
    Write-Host 'Puce TPM non activée'
    Initialize-Tpm -AllowPhysicalPresence -AllowClear
    Write-Host 'Initialisation de la puce TPM effectuée, merci de procéder à un redémarrage puis de relancer le script'
    exit
}

if ($EtatTPM.RestartRequired -eq $true)
{
    Write-Host 'Un redémarrage est nécessaire'
    exit
}


if ($EtatTPM.ClearRequired -eq $true)
{
    Write-Host 'Clear de la TPM nécessaire'
    exit
}



#Test d'une partition déja bitlocker
$PartitionsurPC=get-bitlockervolume
foreach ($PartitionsurPC in $PartitionsurPC)
{
    $LectPC=$PartitionsurPC.mountpoint
    [string]$BitActif=Get-BitLockerVolume -MountPoint $lectpc | select Protectionstatus

if ($BitActif -eq '@{ProtectionStatus=On}')
{
    Write-Host "Le volume $lectpc est déja Bitlocker"
    
}
elseif ($BitActif -eq '@{ProtectionStatus=Off}' -and ($LectPC -eq "c:"))
{
    Write-Host "Activation de bitlocker sur lecteur $Lectpc"
    #Ajout du protector
    Add-BitLockerKeyProtector -MountPoint $LectPC -Pin $Codepin -TpmAndPinProtector 
    #Backup dans AD
    Add-BitLockerKeyProtector -MountPoint $LectPC -RecoveryPasswordProtector
	Backup-BitLockerKeyProtector -MountPoint $LectPC -KeyProtectorId (
    (Get-BitLockerVolume -MountPoint $LectPC).KeyProtector | Where KeyProtectorType -eq RecoveryPassword).KeyProtectorId
    manage-bde.exe -on $LectPC 
}
elseif ($BitActif -eq '@{ProtectionStatus=Off}' -and ($LectPC -eq "D:"))
{
    Write-Host "Activation de bitlocker sur lecteur $Lectpc"
    #Ajout du protector
    Add-BitLockerKeyProtector -MountPoint $LectPC -RecoveryPasswordProtector
	Enable-BitLocker $LectPC -PasswordProtector $Codepin
   
}

}
 
$Restartpc = [Microsoft.VisualBasic.Interaction]::MsgBox("il est nécessaire de redémarrer l'ordinateur. Voulez-vous procéder au redémarrage maintenant ?",'YesNoCancel,Question')
if ($Restartpc -eq "yes") 
{
	shutdown -r -t 0
} 
