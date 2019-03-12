baseBox = "debian/stretch64"
numCPUs = 2
memoryKb = 1024

Vagrant.configure("2") do |config|

	config.vm.provider "virtualbox" do |v|
		v.memory = memoryKb
		v.cpus = numCPUs
	end

	# create 1 salt master
	config.vm.define "salt-master" do |master|
		master.vm.box = baseBox
		master.vm.hostname = "salt-master"

		master.vm.network "private_network", ip: "192.168.137.100"

		# install salt master
		master.vm.provision "shell",
			inline: "apt install -y curl",
			privileged: true

		master.vm.provision "shell",
			path: "provision/install_salt_master.sh"

		master.vm.provision "file",
			source: "provision/config/master",
			destination: "~/master"

		master.vm.provision "shell",
			inline: "mv /home/vagrant/master /etc/salt/master",
			privileged: true

		# set up firewall rules for salt master
		master.vm.provision "file",
			source: "provision/config/salt.ufw",
			destination: "~/salt.ufw"

		master.vm.provision "shell",
			inline: "mv /home/vagrant/salt.ufw /etc/ufw/applications.d/salt.ufw",
			privileged: true

		master.vm.provision "shell",
			path: "provision/ufw_allow_salt_master.sh",
			privileged: true

		# install salt minion
		master.vm.provision "shell",
			path: "provision/install_salt_minion.sh"

		master.vm.provision "file",
			source: "provision/config/minion",
			destination: "~/minion"

		master.vm.provision "shell",
			inline: "mv /home/vagrant/minion /etc/salt/minion",
			privileged: true

		master.vm.provision "shell",
			inline: "systemctl restart salt-minion",
			privileged: true
	end

	# create a bunch of minions
	(1..1).each do |i|
		config.vm.define "salt-minion-#{i}" do |ubuntu|
			# base config
			ubuntu.vm.box = baseBox
			ubuntu.vm.hostname = "salt-minion-#{i}"

			# network
			if i  < 10
				ipAddress = "192.168.137.3#{i}"
			else
				raise "Too many VMs!"
			end
			ubuntu.vm.network "private_network", ip: ipAddress
			
			ubuntu.vm.provision "shell",
				inline: "apt install -y curl",
				privileged: true

			# install salt minion
			ubuntu.vm.provision "shell",
				path: "provision/install_salt_minion.sh"

			ubuntu.vm.provision "file",
				source: "provision/config/minion",
				destination: "~/minion"

			ubuntu.vm.provision "shell",
				inline: "mv /home/vagrant/minion /etc/salt/minion",
				privileged: true

			ubuntu.vm.provision "shell",
				inline: "systemctl restart salt-minion",
				privileged: true
		end
	end
end
