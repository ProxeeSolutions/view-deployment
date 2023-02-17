# Script to be run on the backup CMS
if (Get-NetIPAddress -AddressFamily IPv4 | Where-Object -FilterScript {$_.IPAddress -Eq '192.168.10.27'}) {
    Write-Host "This server is the active server holding the virtual IP address"
    Write-Host "Running the script would overwrite potentially newer files, exiting..."
} else {
    # Server is the main cms holding the virtual IP
    Write-Host "This server is not the active server holding the virtual IP address,"
    Write-Host "The script can be run safely, continuing..."

    # Robocopy Task for Synchronization
    $source = "\\192.168.10.26\ViewBoston_CMS\web"
    $destination = "C:\ViewBoston_CMS\web"
    #/E recursive
    # /PURGE remove file in destination not present in source
    # /Z restartable
    # /MT:32 use 32 threads to speedup copying
    $robocopyOptions = "/E /PURGE /Z /MT:32" 
    Write-Host "executing: robocopy $source $destination $robocopyOptions.split(' ')"
    robocopy $source $destination $robocopyOptions.split(' ')
}