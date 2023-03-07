# upgrade-centos-7-to-8
ugrade geelingguy/centos 7 to centos 8 using vagrant for provisiong centos7 and two ways for doing upgrade to centos 8 by shell and ansible scripts.  

# Provisionning infrastructure using vagrant
install two VMs using Vagrant, install in one vm geelingguy/centos box which will be upgraded to centos8, and install general/rhel8 box on the seconde vm which act as a controller and install ansible on it, from where we will upgrade the centos7 vm.  

  
Vagrant.configure("2") do |config|  
  config.vm.define "centos7to8_2" do |centos7to8_2|  
    centos7to8_2.vbguest.auto_update = false  
    centos7to8_2.vm.box = "geerlingguy/centos"  
    centos7to8_2.vm.hostname = "centos7to8v2"  
	centos7to8_2.vm.network "private_network", ip: "192.168.2.4"  
  end   
  config.vm.define "controller" do |controller|  
		controller.vbguest.auto_update = false  
        controller.vm.box = "generic/rhel8"  
        controller.vm.network "private_network", ip: "192.168.2.90"  
        controller.vm.hostname = "controller"  
        controller.vm.provider "virtualbox" do |vb|  
            vb.memory = "1024"  
        end  
    end  
end  

# From controller machine
# Install ansible and connect to centos7 machine
$sudo su -  
$subscription-manager register --auto-attach --username username  --password password  
$dnf install ansible ansible-core  
$dnf install rhel-system-roles  
$mkdir ansible && cd ansible  
$vi inventory  
[centos]  
192.168.2.4  
$vi ansible.cfg  
[defaults]  
inventory=inventory  
remote_user=root  
interpreter=auto  
roles_path: /usr/share/ansible/roles:~/.ansible/roles:/etc/ansible/roles  

$ssh-keygen   
$ssh vagrant@1921.168.2.4  
vagrant  
$sudo su -  
$passwd  
rootpass  
$exit  
$exit  

$ssh-copy-id root@192.168.2.4  
$ansible centos -m ping  
ok  


# upgrade using shell script
from the controller machine, inside ansible directory, run the yamel script upgrade_centos7to8_shell.yml, which run the shell script upgrade_centos7to8_shell.sh that content commands to upgrade the centos from version 7 to version 8.    
  
$ ansible-playbook upgrade_centos7to8_shell.yml  
  
to fellow the upgrade progress, check the logs on the upgraded machine  
$ ssh roo@192.168.2.4  
$ tail -f /var/log/upg
  
  
# upgrade using ansible modules  
The same upgrade work achieved by shell script can be done using ansible modules. run the script upgrade_centos7to8_ansible.yml and fellow the progess from logs.  

$ ansible-playbook upgrade_centos7to8_ansible.yml  
$ ssh roo@192.168.2.4  
$ tail -f /var/log/upg  





