# -*- mode: ruby -*-
# # vi: set ft=ruby :
Vagrant.require_version ">= 1.9.5"
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
require 'pp'

#require 'colorize'

servergroups = YAML.load_file(File.join(File.dirname(__FILE__), 'vagrant_servers.yml'))

VAGRANT_SERVERS_CONFIG = ENV['VAGRANT_SERVERS_CONFIG'] || File.join(File.dirname(__FILE__), 'vagrant_servers.yml')
DEFAULT_SERVERS_CONFIG = File.join(File.dirname(__FILE__), '.vagrant_servers.yml')
serverconfig = YAML.load_file(VAGRANT_SERVERS_CONFIG)
# override with default variable
serverconfig = serverconfig.merge(YAML.load_file(DEFAULT_SERVERS_CONFIG)) if File.file?(DEFAULT_SERVERS_CONFIG)

servergroups = serverconfig['servers']
defaultconfig = serverconfig['default']

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  servergroups.each do |servergroup, servers|
    servers.each do |servername, serverconfig|
      secrets = YAML.load_file(File.join(File.dirname(__FILE__),"configs/#{servergroup}/#{servername}/secrets.yml")) if File.exist? "configs/#{servergroup}/#{servername}/secrets.yml"
      vm_name = "#{servername}.#{servergroup}"
      config.vm.define vm_name do |server|
        server.vm.network :forwarded_port, guest: 22, host: 2222, id: 'ssh', auto_correct: true
        if serverconfig['provider'] == 'linode' then
          server.vm.provider :linode do |provider, override|
            override.ssh.private_key_path = serverconfig['private_key_path']
            override.vm.box               = 'linode/ubuntu1404'

            provider.api_key      = secrets['api_key']
            provider.datacenter   = serverconfig['datacenter']
            provider.plan         = serverconfig['plan']
            provider.label        = "#{servername.gsub(/\./,'_')}_#{servergroup.gsub(/\./,'_')}"
            provider.group        = servergroup
            provider.distribution = serverconfig['distribution'] unless serverconfig['distribution'].nil?
            provider.image        = serverconfig['image'] unless serverconfig['image'].nil?
            provider.imageid      = serverconfig['imageid'] unless serverconfig['imageid'].nil?
          end
          server.vm.hostname = "#{servername}.#{servergroup}"
        elsif serverconfig['provider'] == 'scaleway' then
          server.vm.provider :scaleway do |provider, override|
            override.ssh.private_key_path = serverconfig['private_key_path']

            provider.name            = "#{servername}.#{servergroup}"
            provider.region          = serverconfig['region']
            provider.tags            = serverconfig['tags']
            provider.commercial_type = serverconfig['commercial_type']
            provider.organization    = secrets['organization']
            provider.token           = secrets['token']
            provider.image           = serverconfig['image']

            override.landrush.enabled = true
            override.landrush.tld = servergroup

          end
          server.vm.hostname = "#{servername}.#{servergroup}"
        elsif serverconfig['provider'] == 'virtualbox' then
          server.vm.provider :virtualbox do |provider, override|
            override.vm.box          = serverconfig['box']
            override.ssh.insert_key  = false
            override.vm.network serverconfig['network_type'], ip: serverconfig['ip'], bridge: serverconfig['bridge']
            override.vm.hostname     = "#{serverconfig['hostname']}.#{servergroup}"
            
            override.landrush.enabled = true
            override.landrush.tld = servergroup

            provider.name            = "#{servername}.#{servergroup}"
            provider.memory = serverconfig['memory']
            provider.cpus = serverconfig['cpus']
            unless serverconfig['vboxmanage'].nil?
              serverconfig['vboxmanage'].each do |customize|
                provider.customize [customize['name'], :id, customize['setting'], customize['value']]
              end
            end
          end
        else
          exit 'Please pass a provider'
        end

        # mount any synced folders
        unless serverconfig['synced_folders'].nil?
          serverconfig['synced_folders'].each do |synced_folder|
            server.vm.synced_folder synced_folder['src'], synced_folder['dest'], disabled: synced_folder['disabled']
          end
        end

        # copy files
        unless serverconfig['files'].nil?
          serverconfig['files'].each do |file|
            server.vm.provision "file", source: "configs/#{servergroup}/#{servername}/#{file['src']}", destination: "#{file['dest']}" if File.exist? "configs/#{servergroup}/#{servername}/#{file['src']}"
          end
        end

        # run the scripts
        server.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'" # needed for ubuntu 16.04 LTS
        unless serverconfig['scripts'].nil?
          serverconfig['scripts'].each do |script|
            server.vm.provision script['name'], type: :shell, path: "configs/#{servergroup}/#{servername}/#{script['src']}"
          end
        end

        # open iptables all ports
        server.vm.provision 'open_iptables', type: :shell, 

        unless serverconfig['ansible'].nil?
          unless serverconfig['ansible']['playbooks'].nil?
            serverconfig['ansible']['playbooks'].each do |playbook|
              server.vm.provision "ansible" do |ansible|
                ansible.playbook = playbook['name']
                ansible.inventory_path = playbook['inventory']
                ansible.sudo = true
              end
            end
          end
        end
      end
    end
  end
end
