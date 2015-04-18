exec { "install-docker":
  command => "/usr/bin/wget -qO- https://get.docker.com/ | /bin/sh",
  creates => "/usr/bin/docker",
}

exec { "usermod-vagrant-docker":
  command => "/usr/sbin/usermod -aG docker vagrant",
  require => Exec["install-docker"],
}

exec { "install-docker-compose":
  command => "/usr/bin/curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose",
  creates => "/usr/local/bin/docker-compose",
  require => Exec["install-docker"],
} ~> exec { "/bin/chmod +x /usr/local/bin/docker-compose": }

file { "/var/local/jibjob":
  ensure => directory,
}
