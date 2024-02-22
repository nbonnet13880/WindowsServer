<#
.SYNOPSIS
    List Folder and Subfolder ACLs for a target directory
.DESCRIPTION
    The script begin by an inventory of folder and subfolders (only level 2) and for each directory inventoried, the CmdLets Get-ACl is executed. The result is added on the csv file.
.EXAMPLE
    For inventory the folders and subfolders in the drive N, modify the line 15 ($PathFolders = Get-ChildItem  -Path "N:\"). 
    If we begin the inventory from the folder Script, you need modify the line like this ($PathFolders = Get-ChildItem  -Path "N:\")
.NOTES
    Script created by Nicolas BONNET 21-02-2024.
#>

########### The variable Chemin contain the Path of the file which contains the path to folders and subfolders ###########
########### Name is added on the file (name of the column), after that all folders in the drive N are inventoried. ###########
$Chemin = "C:\Folders.txt"
Add-Content -Path $Chemin "Name"
$PathFolders = Get-ChildItem  -Path "N:\" | ?{ $_.PSIsContainer } | Select-Object FullName

########### Each folder and path are stored in the txt file. ###########
Foreach ($PathFolder in $PathFolders){
Add-Content -Path $Chemin $PathFolder.FullName
}

########### The path and name of the folder in the txt file are used to bring the list of subfolders. It's added on the same file ###########
$SubFolders = import-csv -path $Chemin
Foreach ($SubFolder in $SubFolders){
    $PathSub = Get-ChildItem  -Path $SubFolder.Name | ?{ $_.PSIsContainer } | Select-Object FullName
    Add-Content -Path $Chemin $PathSub.FullName
}

########### The txt file is imported to have all folders and subfolders in the variable ###########
########### The command Get-Acl is executed and the result stored in the Array. ###########
########### All information in the Array are exported in the Result.txt file ###########

$PathAllFolders = import-csv -path $Chemin

foreach ($PathAllFolder in $PathAllFolders)
{

    $Directory=Get-Acl -Path $PathAllFolder.name
    ForEach($Dir in $Directory.Access)
    {
        [PSCustomObject]@{
           Path = $PathAllFolder.name
           Group = $Dir.IdentityReference
           AccessType = $Dir.AccessControlType
           Rights = $Dir.FileSystemRights
                                                               
        }
                
      $ResultFile = "C:\Result.txt"
      $Result = $PathAllFolder.name + "," + $Dir.IdentityReference + "," + $Dir.AccessControlType + "," + $Dir.FileSystemRights                      
      Add-Content -Path $ResultFile $Result

    }
}
