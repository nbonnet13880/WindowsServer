########################################################################################################
#  Nicolas BONNET                                                                                      #
#  Delete Windows.old on Windows 10 computer                                                           #
########################################################################################################
$Resultat= @()
$PATHLOG="\\SRV\Partage\RemoveLogs.csv"

$TPATH=Test-path -Path "c:\Windows.old"
If ($TPATH -eq $False)
{ 
    break
 
} 


########################################################################################################
#  Takeown Windows.old                                                                                 #
########################################################################################################
takeown.exe /F "c:\Windows.old" /A /R /D N

########################################################################################################
#  Add ACLs for Administrators                                                                         #
########################################################################################################
ICACLS.exe "c:\Windows.old" /T /grant :r Administrateurs:F

########################################################################################################
#  Delete Windows.old                                                                                  #
########################################################################################################
Remove-Item "c:\Windows.old"

########################################################################################################
#  Test du dossier Windows 10                                                                          #
########################################################################################################
$TPATH=Test-path -Path "c:\Windows.old"
If ($TPATH -eq $True)
{ 
    $Resultat += [pscustomobject] @{
    'Resultat'= "Dossier Windows.old non supprim�e"
    'Machine' = $env:COMPUTERNAME}
    

} 
Else
{ 
    $Resultat += [pscustomobject] @{
    'Resultat'= "Dossier Windows.old supprim�e"
    'Machine' = $env:COMPUTERNAME}

}

$Resultat | Export-Csv -Path $PATHLOG -Delimiter "," -NoTypeInformation