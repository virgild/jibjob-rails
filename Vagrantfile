# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define :coreos do |coreos|
    coreos.vm.box = "coreos-%s" % "stable"
    coreos.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % "stable"
    coreos.vm.network :private_network, ip: "192.168.113.108"
    coreos.vm.synced_folder ".", "/home/core/share", id: "core", nfs: true, mount_options: ['nolock,vers=3,udp']
    coreos.ssh.insert_key = false
    coreos.vm.provider :virtualbox do |vbox|
      vbox.check_guest_additions = false
      vbox.functional_vboxsf = false
      vbox.gui = false
      vbox.memory = 2048
      vbox.cpus = 1
      vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
    end

    if Vagrant.has_plugin?("vagrant-vbguest") then
      coreos.vbguest.auto_update = false
    end

    coreos.vm.provision :file, source: "CoreOS/cloud-config.yml", destination: "/tmp/vagrantfile-user-data"
    coreos.vm.provision :shell, inline: "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", privileged: true
  end

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.box = "ubuntu"
    ubuntu.vm.network :private_network, ip: "192.168.113.109"
    ubuntu.vm.synced_folder ".", "/vagrant_data", id: "vagrant_data", nfs: true, mount_options: ['nolock,vers=3,udp']
    ubuntu.vm.provider :virtualbox do |vbox|
      vbox.gui = false
      vbox.memory = 2048
      vbox.cpus = 1
      vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
    end

    # Resolve "stdin: is not a tty" errors (https://github.com/mitchellh/vagrant/issues/1673)
    ubuntu.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    ubuntu.vm.provision :shell, inline: "mkdir -p /var/local/jibjob"
    ubuntu.vm.provision :shell, inline: "sudo -u vagrant touch /home/vagrant"
    ubuntu.vm.provision :shell, inline: "echo \"Box IP address: $(ip addr | grep eth1$ | cut -d ' ' -f 6 | cut -d '/' -f 1)\""
  end
end
