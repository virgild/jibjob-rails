$ruby_packages = ['git-core', 'libssl-dev', 'libncurses-dev', 'gcc', 'make', 'libffi-dev', 'libreadline-dev']
$ruby_version = "2.2.2"

Exec {
  path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin:/sbin',
}

package { $ruby_packages:
  ensure => installed,
}

exec { 'download-ruby-build':
  command => 'git clone https://github.com/sstephenson/ruby-build.git',
  onlyif => [
    "test ! -d /opt/ruby/${ruby_version}",
    "test -d /tmp/ruby-build",
  ],
  cwd => '/tmp',
}

exec { 'install-ruby-build':
  require => Exec["download-ruby-build"],
  command => 'bash install.sh',
  cwd     => '/tmp/ruby-build',
  creates => '/usr/local/bin/ruby-build',
}

exec { "cleanup-ruby-build":
  require => Exec["install-ruby-build"],
  cwd     => "/tmp",
  command => "rm -rf /tmp/ruby-build",
  onlyif  => [
    "test -d /tmp/ruby-build",
    "test -f /usr/local/bin/ruby-build",
  ],
}

exec { "install-ruby-${ruby_version}":
  require => Exec["install-ruby-build"],
  command => "ruby-build ${ruby_version} /opt/ruby/${ruby_version}",
  creates => "/opt/ruby/${ruby_version}",
  timeout => 0,
}

file { "/etc/apt/sources.list.d/pgdg.list":
  ensure => present,
  content => "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main",
}

exec { "import-postgres-signing-key":
  command => "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -",
  subscribe => File["/etc/apt/sources.list.d/pgdg.list"],
  onlyif => "test ! -e /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg",
}

exec { "apt-get update":
  subscribe => Exec["import-postgres-signing-key"],
}

$app_packages = ["libpq-dev", "g++", "imagemagick", "pdftk", "xfonts-base", "xfonts-75dpi", "libcurl4-openssl-dev", "postgresql-client-9.4"]

package { $app_packages:
  ensure => installed,
}

exec { "download-wkhtmltopdf":
  cwd => "/tmp",
  command => "wget http://iweb.dl.sourceforge.net/project/wkhtmltopdf/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb",
  onlyif => "test ! -f /usr/local/bin/wkhtmltopdf",
}

exec { "install-wkhtmltopdf":
  subscribe => Exec["download-wkhtmltopdf"],
  cwd => "/tmp",
  command => "dpkg -i ./wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && apt-get install -f",
  onlyif => "test ! -f /usr/local/bin/wkhtmltopdf",
}

exec { "cleanup-wkhtmtopdf":
  subscribe => Exec["install-wkhtmltopdf"],
  cwd => "/tmp",
  command => "rm -f wkhtmltox-0.12.2.1_linux-trusty-amd64.deb",
  onlyif => "test -e /tmp/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb",
}

exec { "copy-font-config-file":
  cwd => "/etc/fonts",
  command => "cp fonts.conf local.conf",
  onlyif => "test ! -f /etc/fonts/local.conf",
}

# exec { "register-fonts-location":
#   cwd => "/etc/fonts",
#   command => "sed -i 's/<dir>\/usr\/share\/fonts<\/dir>/<dir>\/usr\/share\/fonts<\/dir><dir>\/opt\/fonts<\/dir>/' local.conf",
#   subscribe => Exec["copy-font-config-file"],
# }

exec { "install-bundler":
  require => Exec["install-ruby-${ruby_version}"],
  path    => "/opt/ruby/${ruby_version}/bin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin:/sbin",
  command => "gem install bundler --no-rdoc --no-ri",
  creates => "/opt/ruby/${ruby_version}/bin/bundle",
}

exec { "install-passenger":
  require => Exec["install-bundler"],
  path    => "/opt/ruby/${ruby_version}/bin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin:/sbin",
  command => "gem install passenger --no-rdoc --no-ri",
  creates => "/opt/ruby/${ruby_version}/bin/passenger",
}

exec { "install-passenger-nginx":
  require => Exec["install-passenger"],
  path    => "/opt/ruby/${ruby_version}/bin:/usr/bin:/usr/sbin:/bin:/usr/local/bin:/usr/local/sbin:/sbin",
  command => "passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download --languages ruby",
  creates => "/opt/nginx",
  timeout => 0,
}

exec { "download-phantomjs":
  cwd => "/tmp",
  command => "wget -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2",
  creates => "/tmp/phantomjs-1.9.8-linux-x86_64.tar.bz2",
  onlyif => "test ! -e /usr/local/bin/phantomjs",
}

exec { "unpack-phantomjs":
  require => Exec["download-phantomjs"],
  cwd     => "/tmp",
  command => "bunzip2 phantomjs-1.9.8-linux-x86_64.tar.bz2 && tar xf phantomjs-1.9.8-linux-x86_64.tar",
  onlyif => [
    "test ! -e /usr/local/bin/phantomjs",
    "test -e /tmp/phantomjs-1.9.8-linux-x86_64.tar.bz2",
    "test ! -d /tmp/phantomjs-1.9.8-linux-x86_64",
  ],
}

exec { "install-phantomjs":
  require => Exec["unpack-phantomjs"],
  cwd     => "/tmp",
  command => "cp /tmp/phantomjs-1.9.8-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs",
  onlyif  => [
    "test ! -f /usr/local/bin/phantomjs",
    "test -f /tmp/phantomjs-1.9.8-linux-x86_64/bin/phantomjs",
  ],
}

exec { "cleanup-phantomjs":
  require => Exec["install-phantomjs"],
  cwd     => "/tmp",
  command => "rm -rf phantomjs*",
  onlyif  => [
    "test -f /usr/local/bin/phantomjs",
    "test -d /tmp/phantomjs-1.9.8-linux-x86_64",
  ],
}
