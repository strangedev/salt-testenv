# -*- mode: ruby -*-
# vi: set ft=ruby :

numCPUs = 1
memoryKb = 1024
externalStorageSize = 1024  # MiB

Vagrant.configure("2") do |config|

  	config.vm.provider "virtualbox" do |v|
		v.memory = memoryKb
		v.cpus = numCPUs
	end

	config.vm.synced_folder ".", "/vagrant",
		type: "rsync",
		rsync__exclude: [".git/", "boxes/", ".disks/"],
		owner: "root",
		group: "root"

  	config.vm.define "core" do |core|
		core.vm.box = "swarm-core"
		core.vm.hostname = "core"

		core.vm.network "private_network", 
			ip: "192.168.137.100"

		core.vm.provider "virtualbox" do |vb|
			externalStorage = File.join(".disks", core.vm.hostname, "external.vdi")
			unless File.exist?(externalStorage)
				vb.customize ["createhd", 
					"--filename", externalStorage, 
					"--format", "VDI", 
					"--size", externalStorageSize]
			end
			vb.customize ["storageattach",
				:id, 
				"--storagectl", "SATA Controller", 
				"--port", 1, 
				"--device", 0, 
				"--type", "hdd", 
				"--medium", externalStorage]
		end
	end

	config.vm.define "compute" do |compute|
		compute.vm.box = "swarm-compute"
		compute.vm.hostname = "compute-0"

		compute.vm.network "private_network",
			ip: "192.168.137.201"

		compute.vm.provider "virtualbox" do |vb|
			externalStorage = File.join(".disks", compute.vm.hostname, "external.vdi")
			unless File.exist?(externalStorage)
				vb.customize ["createhd", 
					"--filename", externalStorage, 
					"--format", "VDI", 
					"--size", externalStorageSize]
			end
			vb.customize ["storageattach",
				:id, 
				"--storagectl", "SATA Controller", 
				"--port", 1, 
				"--device", 0, 
				"--type", "hdd", 
				"--medium", externalStorage]
		end
	end
end
