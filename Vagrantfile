Vagrant.configure('2') do |config|

# execute this with the script provider
$vagranthost= <<SCRIPT
systemctl stop firewalld.service
systemctl disable firewalld.service
SCRIPT

$phpapacheconfig= <<SCRIPT
echo LoadModule php5_module modules/libphp5.so >> /etc/httpd/conf.d/php.load
echo AddType application/x-httpd-php .php >> /etc/httpd/conf.d/php.load
systemctl restart httpd
SCRIPT

forwarded_ports = {'80' => '18080', '9292' => '9292', '8000' => '8000', '9200' => '9200'}

  forwarded_ports.each do |k,v|
    config.vm.network :forwarded_port, guest: "#{k}",  host: "#{v}", auto_correct: true
  end

  config.vm.hostname = 'apache'
  config.vm.box = 'puppetlabs/centos-7.0-64-puppet'

  config.vm.network :private_network, ip: '10.0.0.10'

  config.vm.provider :virtualbox do |virtualbox, override|
    virtualbox.customize ['modifyvm', :id, '--memory', '2048']
    virtualbox.customize ["modifyvm", :id, "--ioapic", "on"  ]
    virtualbox.customize ["modifyvm", :id, "--cpus"  , "2"   ]
  end

  config.ssh.forward_agent = true
  config.vm.provision "shell", inline: $vagranthost
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path       = 'manifests'
    puppet.module_path          = 'modules'
    puppet.manifest_file        = 'init.pp'
    puppet.hiera_config_path    = 'hiera.yaml'
    puppet.options              = '--verbose'
    puppet.facter = {
      "env" => "vagrant",
      "location" => "local",
      "role" => "apache"
    }
  end
  config.vm.provision "shell", inline: $phpapacheconfig

end

