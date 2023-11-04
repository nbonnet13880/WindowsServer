# importation du modèle AD pour pouvoir utiliser les Cmdlets AD
import-module activedirectory
# Recherche des utilisateurs dans la base AD (mofifier le chemin ldap), les comptes sont stockées dans la variable
$utilisateurs = Get-ADUser -SearchBase 'OU=MonOU,DC=Nibonnet,DC=fr' -Filter * -Properties *
# Filtre appliqué sur la variable afin de récuérer ceux dont le compte est expiré. Seules les attributs ldap aprés le select sont renvoyés, le résultat est affiché dans un fichier csv
$utilisateurs  | Where-Object {$_.AccountExpirationDate -lt (Get-Date)} | select initials,sn,givenname,title,telephonenumber,mobile,homephone,facsimiletelephonenumber,company | export-csv -Force -Path "c:\unusedaccounts.csv"  -Delimiter ";" -NoTypeInformation -Encoding UTF8