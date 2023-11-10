<#
.SYNOPSIS 
This script permit to list and export into CSV file all LastLogon for all AD Computer

.DESCRIPTION 
Active Directory module is imported. After that all AD computer is listed and following properties are selected (name, lastlogon, ...). 
The results are sorted by name then all is exported.

.LINK 
https://www.inyourcloud.fr
https://www.nibonnet.fr

#>

Import-Module ActiveDirectory
Get-ADComputer -Filter * -Properties * | Select-Object -Property Name,LastLogon,whenCreated,Enabled | Sort-Object -Property Name | Export-Csv -path C:\Users\nbonnet\Desktop\file1.csv