# **Welcome on my windows Server Repositories**

You can found script, step by step, etc. All the different resources made available belong to me and I make them available to everyone. 

## Script

* **UpdateToDelete.zip** : The zip file contain PS1 file and txt. The TXT file must be contain ID of the update which must be deleted on the WSUS Database. The PS1 file permit to connect to the WSUS database and delete update whose IDs are contained in the TXT file.

* **MigrateDHCP.pS1** : After retrieving the number of scope in the source DHCP, each scope is exported. The name of the export xml file is constructed with the network ID of the scope. After the export, the number of file and the number of scope are compared. If the number is the same, the import is performed, otherwise a message appears and the script is stopped. The script can be executed from the source or destination.

* **ConfigureBitlocker.pS1** : This script permit to enable aTPM is tested. If it's not present, Warning is displayed and script is stoppednd configure Bitlocker on Windows 10 computer. Operations are performed before enabling bitlocker (CodePin is converted on secure string, TPM chip has tested, volume is tested). After this operations, bitlocker is enabling and then a message appears asking if the computer should be restarted.
