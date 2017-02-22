name 'pacifica'
maintainer 'David Brown'
maintainer_email 'dmlb2000@gmail.com'
license 'Apache v2.0'
description 'Installs/Configures pacifica'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
if respond_to?(:issues_url)
  issues_url 'https://github.com/pacifica/pacifica-cookbook/issues'
end
if respond_to?(:source_url)
  source_url 'https://github.com/pacifica/pacifica-cookbook'
end
version '0.1.2'

chef_version '>= 12'

supports 'ubuntu', '>= 16.04'
supports 'centos', '>= 7.0'
supports 'redhat', '>= 7.0'

depends 'apache2'
depends 'git'
depends 'poise-python'
depends 'systemd'
depends 'php'
depends 'varnish'
depends 'chef-sugar'
depends 'selinux'
depends 'selinux_policy', '=1.1.0'
depends 'yum-epel'
