# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu64"
  config.vm.network "private_network", ip: "192.168.113.103"
  config.vm.synced_folder ".", "/vagrant_data", type: "nfs"

  config.vm.provider "virtualbox" do |vbox|
    vbox.gui = false
    vbox.memory = "2048"
  end
end
