# Script to be run on the main CMS
if (Get-NetIPAddress -AddressFamily IPv4 | Where-Object -FilterScript {$_.IPAddress -Eq '192.168.10.27'}) {
    # Server is the main cms holding the virtual IP
    Write-Host "This server is the main server holding the virtual IP address, continuing..."
    # Robocopy Task for Synchronization
    $source = "C:\ViewBoston_CMS\web"
    $destination = "\\192.168.10.26\ViewBoston_CMS\web"
    #/E recursive
    # /PURGE remove file in destination not present in source
    # /Z restartable
    # /MT:32 use 32 threads to speedup copying
    $robocopyOptions = "/E /PURGE /Z /MT:32" 
    Write-Host "executing: robocopy $source $destination $robocopyOptions.split(' ')"
    robocopy $source $destination $robocopyOptions.split(' ')
} else {
    Write-Host "This server is not the main server holding the virtual IP address, exiting..."
}