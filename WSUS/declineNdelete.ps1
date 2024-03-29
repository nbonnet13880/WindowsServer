cls
# Chargement de la bibliothèque d'administration WSUS
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | Out-Null
# Initialisation de l'acces au serveur WSUS
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer() 
# Chemin complet vers le fichiers contenant les GUID des mises à jour à traiter
$filename = "C:\temp\updatesToDelete.txt"
# Initialisation du compteur
$traite = 0

#On passe en revue chacun des GUID fourni dans le fichier, 1 GUID par ligne
foreach ($guid in (get-content $filename))
 {
   # 
   Write-Host "Traitement de la mise à jour avec le guid : " $guid
   # Chargement de la mise à jour dans la variable $maj
   $maj = $wsus.getupdate([guid] $guid)

   # Si la mise à jour est approuvée, on la refuse pour pouvoir la supprimer du catalogue
   if ($maj.isapproved) { $maj.decline() } 
   # Suppression de la mise à jour
   $wsus.deleteupdate($maj.id.updateid.tostring())
   # Incrémentation du compteur de traitement
   $traite++
 }

# Affichage du nombre de mises à jour traitées (dans notre cas, il est attendu de traiter 52 mises à jour)
Write-Host "Nombre de mises à jour traitées : " $traite