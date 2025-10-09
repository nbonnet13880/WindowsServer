Import-Module Servermanager
#Install the DFS name space role
Add-WindowsFeature FS-DFS-Namespace -restart

#Install the mmc console to manage the DFS Namespace
install-WindowsFeature RSAT-DFS-Mgmt-Con

#Adds space integrated names AD, configured with the 2008 Mode ABE options ... are automatically configured by the script
#It is necessary to create the share (\\ srvad \ DFS in our example)
New-DfsnRoot -TargetPath \\srvad\DFS -Type domainv2 -EnableSiteCosting $true -EnableInsiteReferrals $false -EnableAccessBasedEnumeration $true -EnableRootScalability $true -EnableTargetFailback $true -State online -TimeToLiveSec 900 -GrantAdminAccounts "nibonnnet\admins du domaine" -TargetState online -ReferralPriorityClass SiteCostNormal -Path \\formation.local\DFS -Confirm

#Configures the necessary variables to create the folder targets

#$DFSUNCname the DFS path to access directories (exemple \\formation.local\NameDFS\Folder)
$DFSUNCname = "C:\temp\dfsunc.txt"

#$UNCname the UNC path to access directories (exemple \\SRVAD\Folder)
$UNCname = "C:\temp\unc.txt"

#Creating tables to retrieve the values ​​of two text files
$TableauPath = @()
$TableauTargetPath = @()

#first for each loop for the recovery of the first text fileforeach ($Cible in (get-content $DFSUNCname))  
{    
	$TableauPath+=$Cible     
}  
#first for each loop for the recovery of the second text file
foreach ($Cible2 in (get-content $UNCname)) 
{    
	$TableauTargetPath+=$Cible2 
} 
#Creating folder targets. The shares must exist ...The values ​​are retrieved from the two tables. To navigate it, a variable is used then incremented (variable i)
for ($i=0;$i -lt $TableauPath.Length;$i++)
{    
	New-DfsnFolder -Path $TableauPath[$i] -TargetPath $TableauTargetPath[$i] -EnableInsiteReferrals $false -EnableTargetFailback $true -State online   
}      






