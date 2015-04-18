# Install docker (bin and daemon setup)
exec { "install-docker":
  command => "/usr/bin/wget -qO- https://get.docker.com/ | /bin/sh",
  creates => "/usr/bin/docker",
}

# The 'vagrant' user should not sudo to run docker commands
exec { "usermod-vagrant-docker":
  command => "/usr/sbin/usermod -aG docker vagrant",
  require => Exec["install-docker"],
}

# Docker daemon
service { "docker-daemon":
  ensure => running,
  enable => true,
  require => Exec["install-docker"],
}

# Bind docker daemon to 0.0.0.0 port 2375 so we can run docker commands on the host
augeas { "docker-daemon-config":
  lens => "Shellvars.lns",
  incl => "/etc/default/docker",
  context => "/files/etc/default/docker",
  changes => ["set DOCKER_OPTS '\"-H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375\"'"],
  notify => Service["docker-daemon"],
}

# Install docker-compose 1.2.0
exec { "install-docker-compose":
  command => "/usr/bin/curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose",
  creates => "/usr/local/bin/docker-compose",
  require => Exec["install-docker"],
} ~> exec { "/bin/chmod +x /usr/local/bin/docker-compose": }

# /var/local/jibjob will be our general container volume mount
file { "/var/local/jibjob":
  ensure => directory,
}
