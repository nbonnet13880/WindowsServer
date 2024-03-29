#The password is added to a variable
$mdp = "Pa$$w0rd"
#The password contained in the variable is encrypted
$mdps = ConvertTo-SecureString -String $mdp -AsPlainText -Force
#The contents of the csv file is added to a variable
$users = Import-Csv -Path 'C:\ImportUsers.csv' -Delimiter ";"
#For each line in the variable, a user is created in the organizational unit (the path is given in the script). 
#Properties configured for the new account are: DisplayName, ACCOUNTPASSWORD, City, compagny, title, GivenName, Surname,	UserPrincipalName ,OfficePhone,SamAcountName
foreach ($u in $users)
{New-ADUser -name $u.DisplayName -Path "ou=ExportRH,dc=Formation,dc=local" -DisplayName $u.Displayname -AccountPassword $mdps -City $u.ville -Company $u.societe -Department $u.service -Title $u.fonction -GivenName $u.prenom -Surname $u.nom -UserPrincipalName $u.upn -OfficePhone $u.telephone -SamAccountName $u.compte -enable $true }
