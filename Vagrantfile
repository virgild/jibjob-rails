# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define :coreos do |coreos|
    coreos.vm.box = "coreos-%s" % "stable"
    coreos.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % "stable"
    coreos.vm.network :public_network, ip: "10.0.1.208", bridge: "en0: Wi-Fi (AirPort)"
    coreos.vm.network :private_network, ip: "192.168.113.108"
    coreos.vm.network :forwarded_port, guest: 2375, host: 2375, auto_correct: true
    coreos.vm.synced_folder ".", "/home/core/share", id: "core", nfs: true, mount_options: ['nolock,vers=3,udp']
    coreos.ssh.insert_key = false
    coreos.vm.provider :virtualbox do |vbox|
      vbox.check_guest_additions = false
      vbox.functional_vboxsf = false
      vbox.gui = false
      vbox.memory = 2048
      vbox.cpus = 1
      # Set NIC 2 (public network above) promiscuity to allow VMs
      vbox.customize ["modifyvm", :id, "--nicpromisc2", "allow-vms"]
      vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
    end

    if Vagrant.has_plugin?("vagrant-vbguest") then
      coreos.vbguest.auto_update = false
    end

    config.vm.provision :file, source: "CoreOS/cloud-config.yml", destination: "/tmp/vagrantfile-user-data"
    config.vm.provision :shell, inline: "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", privileged: true
  end
end
