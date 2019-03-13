# Test Environment for DevOps Work

This repo contains stuff needed to get a test environment
for trying out devops related things up and running.

## Vagrant

### Installing vagrant

Download [vagrant](https://www.vagrantup.com/downloads.html) and install using the procedures appropriate for your OS.

Make sure you have VirtualBox or a similar hypervisor installed.

### Bring up vagrant boxes

```bash
vagrant up
```

## Saltstack

### Connect minions to master

First, ssh into the salt-master:

```bash
vagrant ssh salt-master
```

Then, discover all minions by using:

```bash
sudo salt-key --list-all
```

Then, accept the minions by using:

```bash
sudo salt-key --accept-all
```

### Fix shared folder permissions

Salt won't recognise the states in `/vagrant`, unless `root`
has ownership over them. 

```bash
sudo chown -R root:root /vagrant
sudo systemctl restart salt-master
```

### Run with longer timeout

Sometimes, when executing long-running jobs, the salt CLI will time out
before retrieving data from the minions (Message: Minion did not return. [No response]).
You may increase this timeout by passing the `-t` flag to salt:

```bash
salt -t 60 '*' test.ping  # waits for 60 seconds
```

### Check order of execution

To display a dependency tree for a certain salt state, use the following command (this will also find syntax errors):

```bash
salt '*' state.show_sls <name>
```

### Dry run

```bash
salt '*' state.apply <name> test=True
```

## Tips & Tricks

### Shutting down Vagrant Boxes if the Vagrantfile has changed

When using VirtualBox as hypervisor:

```bash
VBoxManage list runningvms
VBoxManage controlvm <name|uuid> acpipowerbutton
```

If the box is unresponsive, you may force a poweroff (_may cause data loss in the VM guest!_):

```bash
VBoxManage list runningvms
VBoxManage controlvm <name|uuid> poweroff
```

### Removing orphaned Vagrant VMs

When using VirtualBox as hypervisor:

```bash
VBoxManage list vms
VBoxManage unregistervm <name|uuid> --delete
```

If you like to live dangerously (_removes ALL VirtualBox VMs!_):

```bash
for vmId in $( VBoxManage list vms | sed 's/\s\+/\t/' | cut -f2 | sed 's/[{}]//g' ); do
	VBoxManage unregistervm "$vmId" --delete
done
```