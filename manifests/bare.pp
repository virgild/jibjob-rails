$ruby_packages = ['git-core', 'libssl-dev', 'libncurses-dev', 'gcc', 'make', 'libffi-dev', 'libreadline-dev']
$ruby_version = "2.2.2"

package { $ruby_packages:
  ensure => installed,
}
