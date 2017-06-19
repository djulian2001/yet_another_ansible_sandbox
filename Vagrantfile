# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yaml")
vm_configs = configs['configs'][configs['configs']['use']]

# because virtualbox kinda sucks...
# 
# This leverages from a vagrant plugin to ensure the install of the VBoxguest additions
# source: https://seven.centos.org/2017/03/updated-centos-vagrant-images-available-v1702-01/
# recommended:
#   https://github.com/dotless-de/vagrant-vbguest
# issue:
#   the plugin always runs...
#   adds time to up, thought, might be better to pull down the offical, 

Vagrant.configure(2) do |config|

  (1..2).each do |var|
    config.vm.define vm_configs['node']['vagrant_name'] % { :hook => var } do |rem_lb|
      rem_lb.vm.box = vm_configs['node']['vagrant_box']
      rem_lb.vm.hostname = vm_configs['node']['hostname'] % { :hook => var }
      # NOTE: ip address 192.168.34.5%{hook} will be limited to 1..9
      rem_lb.vm.network "private_network", ip:vm_configs['node']['private_ip'] % { :hook => var }
      
      rem_lb.vm.provider vm_configs['vm_box_type'] do |vb1|
        vb1.name = vm_configs['node']['vbox_name'] % { :hook => var }
        vb1.memory = 512
        # vb1.cpus = 1
      end

      rem_lb.vm.provision vm_configs['node']['provision_label'] % { :hook => var }, type:"shell" do |sh_cmd1|
        sh_cmd1.path = vm_configs['node']['provision_path']
        sh_cmd1.args = [vm_configs['arg_user_name'],vm_configs['arg_user_pass'],vm_configs['arg_user_uuid'],vm_configs['arg_user_desc']]
      end
    end
  end
  # vm_configs['manage']['x']

  # management node that pushes ansible crap onto the remote host.
  config.vm.define vm_configs['manage']['vagrant_name'] do |ans|
    ans.vm.box = vm_configs['manage']['vagrant_box']
    ans.vm.hostname = vm_configs['manage']['hostname']
    # ans.vm.network "private_network", ip:"192.168.34.50"
    ans.vm.network "private_network", ip:vm_configs['manage']['private_ip']

    ans.vm.provider vm_configs['vm_box_type'] do |vb|
      vb.name = vm_configs['manage']['vbox_name']
      vb.memory = 1024
      # vb.cpus = 1
    end
  
    ans.vm.provision vm_configs['manage']['provision_label'], type:"shell" do |sh_cmd|
      sh_cmd.path = vm_configs['manage']['provision_path']
      sh_cmd.args = [vm_configs['arg_user_name'],vm_configs['arg_user_pass'],vm_configs['arg_user_uuid'],vm_configs['arg_user_desc']]
    end
  end

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"

  # set 
  # config.vbguest.auto_update = false

end
