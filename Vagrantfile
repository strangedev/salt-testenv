# -*- mode: ruby -*-
# vi: set ft=ruby :

numCPUs = 2
memoryKb = 1024

Vagrant.configure("2") do |config|

  	config.vm.provider "virtualbox" do |v|
		v.memory = memoryKb
		v.cpus = numCPUs
	end

	config.vm.synced_folder ".", "/vagrant",
		type: "rsync",
		rsync__exclude: ".git/",
		owner: "root",
		group: "root"

  	config.vm.define "core" do |master|
		master.vm.box = "swarm-core"
		master.vm.hostname = "core"

		master.vm.network "private_network", ip: "192.168.137.100"

		
	end
end
