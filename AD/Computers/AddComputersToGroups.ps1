<#
.SYNOPSIS 
This script permit to add on the groups all computer present in the CSV file and on one specified OU.

.DESCRIPTION 
Following powershell variable are used. $GroupName permit do configure the DN of the group. The value of this LDAP attributes (Distinguished Name) is on Active Directory. 
It's the same for $OUName that contains the DN of the OU who the AD object is present. The CSVFile permit to configure the path and the file used for add computer on the groups. 
He contain all computer that you need add. $LogFile permit to configure the file used for verify witch computer account has added.
The name and the DN of the object present in the OU are added in the $OrdiAD powershell variable. After that the ForEach permit to add all objects in the group.
The CSV file is imported in the variable and the ForEach permit to added the object in the group.

.LINK 
https://www.inyourcloud.fr
https://www.nibonnet.fr

#>

#Variable used for the script
$GroupName="CN=G_Test_Script,OU=AD,OU=Groups,OU=Formation,DC=Formation,DC=local"
$OUName="OU=Workstation,OU=Formation,DC=Formation,DC=local"
$CSVFile='C:\Users\Administrator\Desktop\AddComputersToGroups.csv'
$LogFile='C:\Temp\LogAddComputers.txt'

#List all objet in the OU and add this objects in the groups. The log file permit to verify if the computer has been added.
$OrdiAD=Get-ADObject -Filter * -SearchBase $OUName | Select-Object name, DistinguishedName
$ComputeraddedGroups=""
Foreach ($ordAD in $OrdiAD) 
{
    Get-ADComputer $ordAD.Name -Properties MemberOf | %{if ($_.MemberOf -like $GroupName) {$ComputeraddedGroups="1"} }
    If ($ComputeraddedGroups -ne 1)
    {
        add-ADGroupMember -Identity $GroupName -Members $ordAD.DistinguishedName
        $Message="The computer" + $ordAD.Name + " is added to the group the $(get-date)" 
        Add-Content -Path $LogFile $Message
        
    }
    $ComputeraddedGroups=""
     
}

#List all objet in the CSV File and add this objects in the groups. The log file permit to verify if the computer has been added.
#Example for the CSV file : 
   #Name;DistinguishedName
   #CLW10;CN=CLW10,OU=Hybridation,OU=Workstation,OU=Formation,DC=Formation,DC=local
   
$ComputerCSV=Import-CSV -Path $CSVFile -Delimiter ";"
Foreach ($ordAD in $ordiAD) 
{
    add-ADGroupMember -Identity $GroupName -Members $ordAD.DistinguishedName
    echo $ordAD.name
    echo $ordAD.DistinguishedName
     
}
