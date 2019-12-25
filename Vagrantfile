Vagrant.configure(2) do |config|

    vagrant_config = YAML.load_file('vagrant-config.yml.dist')
    if File.exists?('vagrant-config.yml')
    then
      vagrant_config.merge!(YAML.load_file('vagrant-config.yml'))
    end

    config.vm.box = "debian/contrib-buster64"
    config.vm.hostname = vagrant_config['project_name'] + "-vagrant"

    config.ssh.forward_agent = true

    # box configuration
    config.vm.provider :virtualbox do |v|
        v.name = vagrant_config['project_name'] + "-vagrant"

        v.customize ["modifyvm", :id, "--memory", vagrant_config["vagrant_memory_mb"]]

        v.customize ["modifyvm", :id, "--uartmode1", "file", "/tmp/vbox.log"]

        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end

    # port forwarding (internal (guest) and exposed (host))
    config.vm.network :forwarded_port, guest: 1337,  host: 1337  # http
    config.vm.network :forwarded_port, guest: 1080,  host: 1340  # maildev
    config.vm.network :forwarded_port, guest: 3000,  host: 1341  # mercure
    config.vm.network :forwarded_port, guest: 5432,  host: 65432 # postgresql

    # synced folder
    config.vm.synced_folder ".", "/vagrant", id: vagrant_config['project_name'] + '_shared', type: "rsync",
        :rsync__args => ["--verbose", "--archive", "--delete", "-z", '--no-links'],
        :rsync__exclude => [".provisioning/", ".git/", '.idea/']

    # setup
    config.vm.provision "ansible" do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.config_file = ".provisioning/ansible.cfg"
        ansible.playbook = ".provisioning/setup.yml"
        ansible.extra_vars = vagrant_config
    end

    # warmup
    config.vm.provision "ansible", run: "always" do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.config_file = ".provisioning/ansible.cfg"
        ansible.playbook = ".provisioning/warmup.yml"
        ansible.extra_vars = vagrant_config
    end

    # rsync-auto
    config.trigger.after [:up, :reload] do |trigger|
        trigger.info = "Rsync auto"
        trigger.run = {inline: "bash -c 'vagrant rsync-auto &'"}
    end
end
