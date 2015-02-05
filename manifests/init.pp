node default {

  $app_name = hiera('app_name')
  $app_port = hiera('app_port')
  $app_docroot = hiera('app_docroot')

  notice("\n\n")
  notice("Running at $::env - $::location and my role is $::role")
  notice("Provisioning $app_name \n\n")

  include apache
  include java
  include redis
  include composer

  apache::vhost { $app_name:
    port    => "$app_port",
    docroot => "$app_docroot",
  }

  #REPOS
  yumrepo { 'webtatic':
    ensure         => 'present',
    descr          => 'Webtatic Repository EL7 - $basearch',
    enabled        => '1',
    failovermethod => 'priority',
    gpgcheck       => '0',
    mirrorlist     => 'https://mirror.webtatic.com/yum/el7/$basearch/mirrorlist',
  }

  yumrepo { 'epel':
    ensure         => 'present',
    descr          => 'Extra Packages for Enterprise Linux 7 - $basearch',
    enabled        => '1',
    failovermethod => 'priority',
    gpgcheck       => '0',
    mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch',
  }

  class { 'elasticsearch':
    manage_repo  => true,
    repo_version => '1.4',
    status       => 'enabled'
  }

  elasticsearch::instance { 'es-01':
    config => { 'node.name' => 'nodename' }
  }

  class { '::mysql::server':
    root_password    => 'toor'
  }

  # Packages
  package { 'php56w':
    ensure => 'installed',
    require => Yumrepo["webtatic"]
  }

  package { 'php56w-opcache':
    ensure => 'installed',
    require => Yumrepo["webtatic"]
  }

  package { 'php56w-cli':
    ensure => 'installed',
    require => Yumrepo["webtatic"]
  }

  package { 'php56w-common':
    ensure => 'installed',
    require => Yumrepo["webtatic"]
  }

  package { 'redis':
    ensure => installed,
  }
}
