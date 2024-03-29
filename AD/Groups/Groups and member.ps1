<#
.SYNOPSIS 
This script permit to list the AD groups and all members.

.DESCRIPTION 
The powershell variable permit to configure the path and the name of the CSV file. After that the name of the group and all member are listed and imported into the 
variable $Groups. The value is converted into string to permit export in the CSV file.

.LINK 
https://www.inyourcloud.fr
https://www.nibonnet.fr

#>

## Import Active Directory Module
import-module activeDirectory

## Path and name of OutFile
$ResultFileName = "C:\TEST.csv"


#Get the name and member of the ad group in organisational unit
$Groups =(Get-ADGroup -Properties * -Filter * -SearchBase "OU=Groups,OU=MonOU,DC=Domaine,DC=local" | select cn,member)

foreach ($Group in $Groups){
# Retrieving attributes and transsformation in string loop to limit
$Members=$Group.Member
$Members= [string[]]$Members

#For each value in the table, the name is recovered and then transformation of the value chain
	for ($ind = 0 ;$ind -le $Members.getupperbound(0);$ind++)
	{
 		$UserNMTEMP = [string]$Group.member[$ind]
		$UserNMTEMP = (Get-ADObject $UserNMTEMP|select name)
		$UserNMTEMP = [string]$UserNMTEMP.name
		$Group.member[$ind]=[string]$UserNMTEMP
	}
$Group.member = [string]$Group.member
}

#Export a csv file content of the $ Groups
$Groups | Export-csv -path $ResultFileName  -Delimiter ";" -NoTypeInformation -Encoding UTF8