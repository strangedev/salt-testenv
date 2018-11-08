Vagrant.configure("2") do |config|

	# create 1 salt master
	config.vm.define "salt-master" do |master|
		master.vm.box = "bento/ubuntu-18.04"
		master.vm.hostname = "salt-master"

		master.vm.network "private_network", ip: "192.168.137.100"

		master.vm.provision "shell",
			path: "provision/install_salt_master.sh"

		master.vm.provision "file",
			source: "provision/config/salt.ufw",
			destination: "~/salt.ufw"

		master.vm.provision "shell",
			inline: "mv /home/vagrant/salt.ufw /etc/ufw/applications.d/salt.ufw",
			privileged: true

		master.vm.provision "shell",
			path: "provision/ufw_allow_salt_master.sh",
			privileged: true
	end

	# create a bunch of ubuntu hosts
	(1..1).each do |i|
		config.vm.define "ubuntu-#{i}" do |ubuntu|
			ubuntu.vm.box = "bento/ubuntu-18.04"
			ubuntu.vm.hostname = "ubuntu-#{i}"

			if i  < 10
				ipAddress = "192.168.137.3#{i}"
			else
				raise "Too many VMs!"
			end
			ubuntu.vm.network "private_network", ip: ipAddress
			
			ubuntu.vm.provision "shell",
				path: "provision/install_salt_minion.sh"

			ubuntu.vm.provision "file",
				source: "provision/config/minion",
				destination: "~/minion"

			ubuntu.vm.provision "shell",
				inline: "mv /home/vagrant/minion /etc/salt/minion",
				privileged: true			
		end
	end
end