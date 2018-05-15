name 'pacifica'
maintainer 'David Brown'
maintainer_email 'dmlb2000@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures pacifica'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
if respond_to?(:issues_url)
  issues_url 'https://github.com/pacifica/pacifica-cookbook/issues'
end
if respond_to?(:source_url)
  source_url 'https://github.com/pacifica/pacifica-cookbook'
end
version '2.0.0'

chef_version '>= 12'

supports 'ubuntu', '>= 16.04'
supports 'centos', '>= 6.0'
supports 'redhat', '>= 6.0'

depends 'git'
depends 'poise-python'
depends 'poise-service'
depends 'chef-sugar'
depends 'compat_resource'
