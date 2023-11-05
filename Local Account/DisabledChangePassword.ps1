#####################################################################################################################################
# Nicolas BONNET                                                                                                                    #
# 21/07/2021                                                                                                                        #
# Verify if registry key exist. If exist the script is stopped                                                                      #
# If not exist, the properties Change password at next logon is tested. If equal at 1 (option enabled), the script disable option   #
# Dword is created                                                                                                                  #
#####################################################################################################################################
$NewCleRegistre = "HKLM:Software\"
$CleRegistre = "HKLM:Software\LocalAdmin"
$Test=Test-path $CleRegistre

if ($Test -eq $true)
{
  exit 
}
$user = [ADSI]"WinNT://$env:ComputerName/LocalADmin,user"
$user.PasswordExpired

if ($user.PasswordExpired -eq "1")
{
$user.PasswordExpired = 0
$user.SetInfo()
New-Item "$NewCleRegistre" -Name "LocalAdmin" 
}
