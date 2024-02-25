# -*- mode: ruby -*-
# vi: set ft=ruby :

API_VER = "2"
NODES = 2

Vagrant.configure(API_VER) do |config|
  config.vm.box = "bento/rockylinux-8"

  # Add an authorised a public key to each vagrant box
  config.vm.provision "file", source: "./ssh_keys/id_vagrant", destination: "/home/vagrant/.ssh/id_vagrant"
  config.vm.provision "shell" do |s|
    ssh_pub_key = File.readlines("./ssh_keys/id_vagrant.pub").first.strip
    s.inline = <<-SHELL
      echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
    SHELL
  end

  config.vm.provider "vmware_desktop" do |v|
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "2"
    # gui = true need for private network functionality to work
    v.gui = true
  end

  (1..NODES).each do |i|
    config.vm.define :"haproxy#{i}" do |haproxy_config|
      haproxy_config.vm.hostname = "haproxy#{i}"  
      haproxy_config.vm.network :private_network, ip: "172.16.100.#{100 + i}"
    end
  end

  config.vm.define :controlplane do |controlplane_config|
    controlplane_config.vm.hostname = "controlplane"
    controlplane_config.vm.network :private_network, ip: "172.16.100.110"
  end

  (1..NODES).each do |n|
    config.vm.define :"workernode#{n}" do |workernode_config|
      workernode_config.vm.hostname = "workernode#{n}"
      workernode_config.vm.network :private_network, ip: "172.16.100.#{110 + n}"
    end
  end

  config.vm.define :ansible, primary: true do |ansible_config|
    ansible_config.vm.hostname = 'ansible'  
    ansible_config.vm.network :private_network, ip: "172.16.100.150" 
    ansible_config.vm.synced_folder './ansible', '/home/vagrant/ansible/', disabled: false, create: true
    # Add private ssh key to the ansible control node
    ansible_config.vm.provision "file", source: "./ssh_keys/id_vagrant", destination: "/home/vagrant/.ssh/id_vagrant"
    # Bootstrap ansible control node
    ansible_config.vm.provision :shell, :path => "./scripts/bootstrap_ansible_node.sh"
  end
end