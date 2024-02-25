# lab-haproxy-rke

This is a full kubernetes lab environment based on vagrant.

Vagrant will create six VMs:
* ansible control node
* ha proxy 1
* ha proxy 2
* kubernetes control node
* kubernetes worker node 1
* kubernetes worker node 2

The ansible control node also acts as a bastion for the cluster, kubectl will be installed there and along with the cluster configuration.

Vip for webservers running in the cluster is: 172.16.100.100


