# **Welcome on my windows Server Repositories**

You can found script, step by step, etc. All the different resources made available belong to me and I make them available to everyone. 

## AD / Computer 

* **AddComputersToGroups** : The script permit to add computer present in the OU or CSV file into the AD Groups.

* **LastLogon** : Export the last logon of all AD computer with this script.

* **Groups and member** : List all members of the AD Groups

* **MigrateDHCP.pS1** : After retrieving the number of scope in the source DHCP, each scope is exported. The name of the export xml file is constructed with the network ID of the scope. After the export, the number of file and the number of scope are compared. If the number is the same, the import is performed, otherwise a message appears and the script is stopped. The script can be executed from the source or destination.

* **ConfigureBitlocker.pS1** : This script permit to enable aTPM is tested. If it's not present, Warning is displayed and script is stoppednd configure Bitlocker on Windows 10 computer. Operations are performed before enabling bitlocker (CodePin is converted on secure string, TPM chip has tested, volume is tested). After this operations, bitlocker is enabling and then a message appears asking if the computer should be restarted.
