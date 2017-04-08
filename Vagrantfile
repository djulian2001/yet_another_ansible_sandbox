# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/config.yaml")
vm_configs = configs['configs'][configs['configs']['use']]

# INTERESTING Approach...^^^the above^^^^
# but I just need:
# manage_host_ip = "192.168.34.50"
# remote_host_ip = "192.168.34.51"
# user_name = "ansible_manager"
# user_pass = "ansible"        # very bad practice... but it's local...
# user_uuid = 999

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
# remote box that above box will crap all over, same private network.
  # vm_configs['remote']
  # vm_configs['remote']['x']
  # remote_lb
  # remote_db
  # remote_app1
  # remote_app2
  config.vm.define vm_configs['remote_lb']['vagrant_name'] do |rem_lb|
    rem_lb.vm.box = vm_configs['remote_lb']['vagrant_box']
    rem_lb.vm.hostname = vm_configs['remote_lb']['hostname']
    rem_lb.vm.network "private_network", ip:vm_configs['remote_lb']['private_ip']
    rem_lb.vm.provider vm_configs['vm_box_type'] do |vb1|
      vb1.name = vm_configs['remote_lb']['vbox_name']
      vb1.memory = 512
      # vb1.cpus = 1
    end
    rem_lb.vm.provision vm_configs['remote_lb']['provision_label'], type:"shell" do |sh_cmd1|
      sh_cmd1.path = vm_configs['remote_lb']['provision_path']
      sh_cmd1.args = [vm_configs['arg_user_name'],vm_configs['arg_user_pass'],vm_configs['arg_user_uuid'],vm_configs['arg_user_desc']]
    end
  end
  config.vm.define vm_configs['remote_db']['vagrant_name'] do |rem_db|
    rem_db.vm.box = vm_configs['remote_db']['vagrant_box']
    rem_db.vm.hostname = vm_configs['remote_db']['hostname']
    rem_db.vm.network "private_network", ip:vm_configs['remote_db']['private_ip']
    rem_db.vm.provider vm_configs['vm_box_type'] do |vb1|
      vb1.name = vm_configs['remote_db']['vbox_name']
      vb1.memory = 1024
      # vb1.cpus = 1
    end
    rem_db.vm.provision vm_configs['remote_db']['provision_label'], type:"shell" do |sh_cmd1|
      sh_cmd1.path = vm_configs['remote_db']['provision_path']
      sh_cmd1.args = [vm_configs['arg_user_name'],vm_configs['arg_user_pass'],vm_configs['arg_user_uuid'],vm_configs['arg_user_desc']]
    end
  end
  config.vm.define vm_configs['remote_app1']['vagrant_name'] do |rem_app1|
    rem_app1.vm.box = vm_configs['remote_app1']['vagrant_box']
    rem_app1.vm.hostname = vm_configs['remote_app1']['hostname']
    rem_app1.vm.network "private_network", ip:vm_configs['remote_app1']['private_ip']
    
    rem_app1.vm.provider vm_configs['vm_box_type'] do |vb1|
      vb1.name = vm_configs['remote_app1']['vbox_name']
      vb1.memory = 1024
      # vb1.cpus = 1
    end
    rem_app1.vm.provision vm_configs['remote_app1']['provision_label'], type:"shell" do |sh_cmd1|
      sh_cmd1.path = vm_configs['remote_app1']['provision_path']
      sh_cmd1.args = [vm_configs['arg_user_name'],vm_configs['arg_user_pass'],vm_configs['arg_user_uuid'],vm_configs['arg_user_desc']]
    end
  end
  config.vm.define vm_configs['remote_app2']['vagrant_name'] do |rem_app2|
    rem_app2.vm.box = vm_configs['remote_app2']['vagrant_box']
    rem_app2.vm.hostname = vm_configs['remote_app2']['hostname']
    rem_app2.vm.network "private_network", ip:vm_configs['remote_app2']['private_ip']
    
    rem_app2.vm.provider vm_configs['vm_box_type'] do |vb1|
      vb1.name = vm_configs['remote_app2']['vbox_name']
      vb1.memory = 1024
      # vb1.cpus = 1
    end
    rem_app2.vm.provision vm_configs['remote_app2']['provision_label'], type:"shell" do |sh_cmd1|
      sh_cmd1.path = vm_configs['remote_app2']['provision_path']
      sh_cmd1.args = [vm_configs['arg_user_name'],vm_configs['arg_user_pass'],vm_configs['arg_user_uuid'],vm_configs['arg_user_desc']]
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
