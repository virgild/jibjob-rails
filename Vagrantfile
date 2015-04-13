# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define :coreos do |coreos|
    coreos.vm.box = "coreos-%s" % "stable"
    coreos.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % "stable"
    coreos.vm.network :private_network, ip: "192.168.113.105"
    coreos.vm.synced_folder ".", "/home/core/share", id: "core", nfs: true, mount_options: ['nolock,vers=3,udp']
    config.vm.network "forwarded_port", guest: 2375, host: 2375, auto_correct: true
    config.ssh.insert_key = false
    coreos.vm.provider :virtualbox do |v|
      v.check_guest_additions = false
      v.functional_vboxsf = false
      v.gui = false
      v.memory = 1024
      v.cpus = 1
    end

    config.vm.provision :file, source: "CoreOS/cloud-config.yml", destination: "/tmp/vagrantfile-user-data"
    config.vm.provision :shell, inline: "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", privileged: true
  end
end
