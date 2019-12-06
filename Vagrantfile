# -*- mode: ruby -*-
# vi: set ft=ruby :

numCPUs = 1
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

  	config.vm.define "core" do |core|
		core.vm.box = "swarm-core"
		core.vm.hostname = "core"

		core.vm.network "private_network", 
			ip: "192.168.137.100"
	end

	config.vm.define "compute" do |compute|
		compute.vm.box = "swarm-compute"
		compute.vm.hostname = "compute-0"

		compute.vm.network "private_network",
			ip: "192.168.137.201"
	end
end
