# view-deployment
Deployement Scripts for Windows Remote setup

### Enable running PowerShell Scripts

In Powershell as Administrator:

	SetExecution-Policy Unrestricted

### Download and run script in Powershell

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ProxeeSolutions/view-deployment/main/view-win-host-setup.ps1"
$file = "$env:temp\view-win-host-setup.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file


### Test in Ansible

On the Ansible client host:
		
	ansible all -i 192.168.236.218, --user vagrant --ask-pass -m win_ping -c winrm -e "ansible_winrm_server_cert_validation=ignore"

It should return:

	192.168.236.218 | SUCCESS => {
    		"changed": false,
    		"ping": "pong"
	}


