Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

#start ssh service
Start-Service sshd

#enable service
Set-Service -Name "sshd" -StartupType Automatic

Enable-PSRemoting

#Ansible automated Powershell remoting setup
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file

#List WinRM Listeners
winrm enumerate winrm/config/Listener
