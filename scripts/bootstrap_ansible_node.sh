# Initial OS configuration
chmod 400 /home/vagrant/.ssh/id_vagrant
echo "\n #  Start the ssh-agent"
echo "eval \`ssh-agent\`" >> /home/vagrant/.bashrc
echo "ssh-add /home/vagrant/.ssh/id_vagrant" >> /home/vagrant/.bashrc
echo "export LC_ALL=\"C.UTF-8\"" >> /home/vagrant/.bashrc

# Install ansible-core & modules
dnf install -y ansible-core

# Switch to the vagrant user to run the ansible playbooks & install kubernetes tools
sudo -i -u vagrant bash << EOF  

# Install ansible module for firewalld and mount 
ansible-galaxy collection install ansible.posix community.general

# Install kubernetes & helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
curl -LO "https://dl.k8s.io/release/v1.27.11/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
mkdir -p /home/vagrant/.kube

# # Run the playbooks
export LC_ALL="C.UTF-8"
cd /home/vagrant/ansible
ansible-playbook -i inventory.yml main.yml

# # Secure kubeconfi
# chmod 600 /home/vagrant/.kube/config

# bootstrap cluster
# kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml
# watch kubectl get pods -n calico-system

EOF


