# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define :default do |default|
    default.vm.box = "ubuntu/trusty64"
    default.vm.network :private_network, ip: "192.168.33.10"
    default.vm.synced_folder ".", "/vagrant_data", id: "vagrant_data", nfs: true, mount_options: ['nolock,vers=3,udp']
    default.vm.hostname = "jibjob.dev"
    default.vm.provider :virtualbox do |vbox|
      vbox.gui = false
      vbox.memory = 2048
      vbox.cpus = 1
      vbox.customize ["modifyvm", :id, "--cpuexecutioncap", "90"]
    end

    # Resolve "stdin: is not a tty" errors (https://github.com/mitchellh/vagrant/issues/1673)
    default.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    default.vm.provision "puppet" do |puppet|
      puppet.facter = {}
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "app.pp"
      puppet.module_path = "puppet/modules"
    end

    default.vm.boot_timeout = 0

    default.vm.provision :shell, inline: "echo \"Box IP address: $(ip addr | grep eth1$ | cut -d ' ' -f 6 | cut -d '/' -f 1)\""
  end
end
