<#
.SYNOPSIS 
This script permit to add users on a lot of AD groups. All groups are listed in a CSV file with a column "valide" to permit to add or not the user in the group. 
Type 1 to add the user (after the ; in the csv file).
.DESCRIPTION 
The powershell variable permit to select the user that must be added on the groups. The script list all value in the CSV file. Two column are on this file.
- The name of the group and thecolumn valide. If Valide is equal to 1, the script add the user on the group. The column name is the name of the groups.

.LINK 
https://www.inyourcloud.fr
https://www.nibonnet.fr

#>
#Name of the user
$user = "nbonnet"

#Import the CSV file
$Groups = Import-Csv -Path "C:\Temp\Groups.csv" -Delimiter ";"

#Add the user on the group
Foreach ($Group in $Groups){

    if ($Group.valide -eq "1"){

        Add-ADGroupMember -Members $user -identity $Group.Name

    }

}