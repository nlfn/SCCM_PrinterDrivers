function Get-TimeStamp {
    
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}

try 
{
    $driverlog = "C:\LOGS\printerz-drivers.log"
    $installed = "C:\Windows\system32\printerz-drivers.120.txt"

    If (Test-Path $installed) { Remove-Item $installed }

    $driverfile = "mps4-drivers.txt"
    $driverfile_location = Split-Path -Path $MyInvocation.MyCommand.Path
    $driverfile_path = Join-Path -Path $driverfile_location -ChildPath $driverfile

    $drivererrors=0

    "$(Get-TimeStamp) SCRIPT RUN BEGINS: running as $env:username" >> $driverlog

    foreach ($printqueue in Get-Content $driverfile_path) {
        if ($printqueue.substring(0,1) -eq '#')
        { 
        } else { 
           $printqueue_array = $printqueue.Split("`t")
           $printer = $printqueue_array[0]
           $printerdriver_name = $printqueue_array[1]
	       Add-Printer -ConnectionName $printqueue_array[0]
           if($?) {
              "$(Get-TimeStamp) SUCCESS: Added driver from $printer for $printerdriver_name" >> $driverlog
           } else {
              "$(Get-TimeStamp) FAILED: Unable to add driver from $printer for $printerdriver_name" >> $driverlog
              $drivererrors++
           }
        }
    }
}

catch
{
    [System.Environment]::Exit(1)
}

if ($drivererrors -ne 0) {
    "$(Get-TimeStamp) SCRIPT RUN COMPLETE: Unable to install $drivererrors print drivers." >> $driverlog
    [System.Environment]::Exit(1)
} else {
    "$(Get-TimeStamp) SCRIPT RUN COMPLETE: Able to install all print drivers." >> $driverlog
    Out-File -FilePath $installed
           if($?) {
 	      "$(Get-TimeStamp) SCRIPT RUN COMPLETE: Wrote $installed file for detection." >> $driverlog
           } else {
 	      "$(Get-TimeStamp) ERROR: unable to write $installed file for detection." >> $driverlog
           }
    [System.Environment]::Exit(0)
}

