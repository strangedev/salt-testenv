Vagrant.configure("2") do |config|

	# create 1 salt master
	config.vm.define "salt-master" do |master|
		master.vm.box = "bento/ubuntu-18.04"
		master.vm.hostname = "salt-master"

		master.vm.network "private_network", ip: "192.168.137.100"

		if ARGV.length >= 1 and ARGV[0] == '--salt-bootstrap' # TODO: this is broken
			master.vm.provision "shell",
				path: "provision/install_salt_master.sh"
		end

		master.vm.provision "file",
			source: "provision/config/master",
			destination: "~/master"

		master.vm.provision "shell",
			inline: "mv /home/vagrant/master /etc/salt/master",
			privileged: true	
		
		master.vm.provision "file",
			source: "dipf-devops-saltstack/states/.",
			destination: "~/salt"

		master.vm.provision "file",
			source: "dipf-devops-saltstack/data.example/scripts/.",
			destination: "~/salt/scripts"

		master.vm.provision "file",
			source: "dipf-devops-saltstack/data.example/ssh-keys/.",
			destination: "~/salt/ssh-keys"

		master.vm.provision "file",
			source: "dipf-devops-saltstack/data.example/config/.",
			destination: "~/salt/config"

		master.vm.provision "shell",
			inline: "rsync --remove-source-files -a -v /home/vagrant/salt /srv",
			privileged: true	

		master.vm.provision "file",
			source: "dipf-devops-saltstack/pillar.example/.",
			destination: "~/pillar"

		master.vm.provision "shell",
			inline: "rsync --remove-source-files -a -v /home/vagrant/pillar /srv",
			privileged: true		

		master.vm.provision "file",
			source: "provision/config/salt.ufw",
			destination: "~/salt.ufw"

		master.vm.provision "shell",
			inline: "mv /home/vagrant/salt.ufw /etc/ufw/applications.d/salt.ufw",
			privileged: true

		master.vm.provision "shell",
			path: "provision/ufw_allow_salt_master.sh",
			privileged: true
	
		if ARGV.length >= 1 and ARGV[0] == '--salt-bootstrap' # TODO: this is broken
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

	end

	# create a bunch of ubuntu hosts
	(1..1).each do |i|
		config.vm.define "ubuntu-#{i}" do |ubuntu|
			# base config
			ubuntu.vm.box = "bento/ubuntu-18.04"
			ubuntu.vm.hostname = "ubuntu-#{i}"

			# network
			if i  < 10
				ipAddress = "192.168.137.3#{i}"
			else
				raise "Too many VMs!"
			end
			ubuntu.vm.network "private_network", ip: ipAddress
			
			# install saltstack
			
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
