#######################################################
# Fonction qui permet de creer l'imprimante en fournissant le nom du serveur, le nom du Driver, le nom du port, le nom du partage, nom de la localisation, le commentaire
function CreatePrinter 
{
               #Recuperation du nom du serveur
               $server = $args[0]
               #Creation de l objet correspondant au port impression
               $print = ([WMICLASS]”\\$server\ROOT\cimv2:Win32_Printer”).createInstance()
               #Recuperaation du driver pour l imprimante
               $print.drivername = $args[1]
               #Recuperation du port
               $print.PortName = $args[2]
               #Partager l imprimante
               $print.Shared = $true
               #Nom du partage
               $print.Sharename = $args[3]
               #Localisation de l imprimante
               $print.Location = $args[4]
               #Commentaire
               $print.Comment = $args[5]
               #Nom de l imprimante
               $print.DeviceID = $args[6]
               #Creation de l imprimante
               $print.Put()
 
}
#######################################################
# Fonction qui permet de creer le port de l imprimante en fournissant le nom du serveur, le nom du port et l IP de l imprimante
function CreatePrinterPort
{
               #Recuperation du nom du serveur
               $server = $args[0]
               #Creation de l objet correspondant au port impression
               $port = ([WMICLASS]”\\$server\ROOT\cimv2:Win32_TCPIPPrinterPort”).createInstance()
               #Recuperation du nom du port
               $port.Name= $args[1]
               #Desactivation de SNMP
               $port.SNMPEnabled=$false
               #Selection du protocol TCP/IP
               $port.Protocol=1
               #Adresse IP de l imprimante
               $port.HostAddress= $args[2]
               #Creation du port
               $port.Put()
               
}
#Serveur source
$srvSource = "serveursrc"
#Serveur de destination
$srvDest = "serveurdst"
#Récupération de la liste des imprimantes sur le serveur source
$printers = Get-WMIObject -class Win32_Printer -computer $srvSource | Select Name,DriverName,PortName,sharename,location,comment
 
#Pour chaque imprimante se trouvant dans la liste
foreach ($printer in $printers) 
{
               #Verifier que l imprimante n'exite pas
               
               #Récupération de l adresse IP du port à partir du nom du port
               $printerIP = $printer.Portname.tostring()
               #Création du port
               CreatePrinterPort $srvDest $printer.PortName $printerIP
               #Création de l'imprimante
               CreatePrinter $srvDest $printer.DriverName $printer.Portname $printer.Sharename $printer.Location $printer.Comment $printer.Name
}
 
