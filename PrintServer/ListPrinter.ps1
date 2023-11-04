$strComputer = "serveurprint" 
 
$colprintersList = @()
 
$exportfile = "D:\backup\list-printer.csv"
 
#Liste toutes les imprimantes
$colPrinters = Get-WmiObject Win32_Printer -ComputerName $strComputer
 
#Pour chaque imprimante dans la liste
Foreach ( $Printer in $colPrinters )
{
               #Si le port de l'imprimante n'est pas un partage
               If ($Printer.PortName -notlike "*\*")
               {
                              #Lister les ports de l'imprimante
                              $Ports = get-wmiobject -class "Win32_TCPIPPrinterPort" -namespace "root\CIMV2" -Filter "name = '$($Printer.Portname)'" -computername $strComputer
                              #Pour chaque port
                              Foreach ( $port in $ports )
                              {
                                            #initialisation de l'objet imprimantes
                                            $objprinter = New-Object PSObject
                                            Add-Member -InputObject $objprinter -MemberType NoteProperty -Name Name -Value ""
                                            Add-Member -InputObject $objprinter -MemberType NoteProperty -Name Sharename -Value ""
                                            Add-Member -InputObject $objprinter -MemberType NoteProperty -Name location -Value ""
                                            Add-Member -InputObject $objprinter -MemberType NoteProperty -Name drivername -Value ""
                                            Add-Member -InputObject $objprinter -MemberType NoteProperty -Name portname -Value ""
                                            Add-Member -InputObject $objprinter -MemberType NoteProperty -Name Hostaddress -Value ""
                                            Add-Member -InputObject $objprinter -MemberType NoteProperty -Name PortType -Value ""
                                            #Remplissage de l'objet
                                            $objprinter.Name = $Printer.Name
                                            $objprinter.Sharename = $Printer.Sharename
                                            $objprinter.location = $Printer.location
                                            $objprinter.drivername = $Printer.drivername
                                            $objprinter.portname = $Printer.portname
                                             $objprinter.Hostaddress = $port.Hostaddress
                                            $objprinter.PortType = $port.Type
                                            #insertion de l'imprimante dans la liste
                                            $colprintersList += $objprinter
                                            
                              }
               }
}
 
$colprintersList | export-csv $exportfile
