# -*- mode: ruby -*-
# # vi: set ft=ruby :
Vagrant.require_version ">= 1.9.5"
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
require 'pp'

#require 'colorize'

CONFIG_FILE = ENV['CONFIG_FILE'] || File.join(File.dirname(__FILE__), 'vagrant_servers.yml')
CONFIG_OVERRIDE_FILE = File.join(File.dirname(__FILE__), '.vagrant_servers.yml')
SECRETS_FILE = File.join(File.dirname(__FILE__), 'secrets.yml')
SECRETS_OVERRIDE_FILE = File.join(File.dirname(__FILE__), '.secrets.yml')

abort 'config file vagrant_servers.yml missing. Please add that file to continue.' unless File.file? CONFIG_FILE
abort 'secrets config file secrets.yml missing. Please add that file to continue.' unless File.file?(SECRETS_FILE)

serverconfig = YAML.load_file(CONFIG_FILE)
# override with default variable
serverconfig = serverconfig.merge(YAML.load_file(CONFIG_OVERRIDE_FILE)) if File.file?(CONFIG_OVERRIDE_FILE)

servergroups = serverconfig['servers']
defaultconfig = serverconfig['default']

secrets = YAML.load_file(SECRETS_FILE) if File.file? SECRETS_FILE
secrets = secrets.merge(YAML.load_file(SECRETS_OVERRIDE_FILE)) if File.file? SECRETS_OVERRIDE_FILE

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  servergroups.each do |servergroup, servers|
    servers.each do |servername, serverconfig|

      # merge the default config
      if serverconfig.nil?
        serverconfig = defaultconfig
      else
        serverconfig = defaultconfig.merge(serverconfig)
      end

      vm_name = "#{servername}.#{servergroup}"
      config.vm.define vm_name do |server|
        server.vm.network :forwarded_port, guest: 22, host: 2222, id: 'ssh', auto_correct: true
        if serverconfig['provider'] == 'linode' then
          server.vm.provider :linode do |provider, override|
            override.ssh.private_key_path = serverconfig['private_key_path']
            override.vm.box               = 'linode/ubuntu1404'

            provider.api_key      = secrets['linode']['api_key']
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
            provider.organization    = secrets['scaleway']['organization']
            provider.token           = secrets['scaleway']['token']
            provider.image           = serverconfig['image']

            provider.security_group  = serverconfig['security_group'] unless serverconfig['security_group'].nil?

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

      end
    end
  end
end
