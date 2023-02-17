# view-deployment

Deployement Scripts for Windows Remote setup

## Setup



### Enable running PowerShell Scripts

In Powershell as Administrator:

	SetExecution-Policy Unrestricted

### Download and run setup script in Powershell

```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ProxeeSolutions/view-deployment/main/view-win-host-setup.ps1"
$file = "$env:temp\view-win-host-setup.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file
```

### Test in Ansible

On the Ansible client host:

    ansible all -i 192.168.236.218, --user vagrant --ask-pass -m win_ping -c winrm -e "ansible_winrm_server_cert_validation=ignore"

It should return:

```
192.168.236.218 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
````

## Usage

### Target groups in inventory

- lobby
- poster
- interactive
- cms
- storage
- finale
- elevator
- viewer
- tactile

### Secrets

Secret passwords and token are store in an encrypted vault under the `groups_vars/all` directory

### Running Ad-Hoc command

To issue on-demand command, use the `ansible` command. the `-m win_shell` option will be used to send shell commands to windows machines. The target can be one or multiople machines separated by comas and a trailing coma, or a group defined in the `inventory` file.

    ansible -m win_shell -a '<windows shell command>' <target>

#### Ad-Hoc Examples

##### PM2 restart on poster machines

    ansible -m win_shell -a 'pm2 restart all' poster

##### Reboot poster Computers

    ansible -m ansible.windows.win_reboot poster





### Running playbooks

Running playbooks is the automated way of executing every actions on the machines. It can be run many times and will only process the required tasks to bring the machines to the desired state.

Actions can be filtered by hosts or groups using the `--limit` option like the adphoc command's target option. If unspecified, all hosts in the inventory will be targeted, including the servers.

Actions for the whole site can be found in the `site.yml` playbook, which imports specific sub-playbooks for every group. Tags can also be used to only execute tasks which have been tagged with a particular identifier.

Variables for groups and hosts are specified in the group files (*.yml) under the `group_vars` directory

The command is:

    ansible-playbook <playbook.yml> (optional: --tags: <list of comma-separated tags>) (optional: --limit <comma-separated groups or hosts>)

#### Playbook Examples

Run the playbook for the whole site, setting the proper configuration on every machine:

    ansible-playbook site.yml

Run the playbook only on a specific group:

    ansible-playbook site.yml --limit tactile

Only synchronize files in the `ViewBoston/` directory from the storage server:

    ansible-playbook site.yml --tags sync

Set audio volumes everywhere (volume variable take nfrom the `group_vars` files)

    ansible-playbook site.yml --tags audio
