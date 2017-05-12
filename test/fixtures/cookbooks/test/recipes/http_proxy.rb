include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_fcgi'
apache_site '000-default' do
  enable false
end
template "#{node['apache']['dir']}/sites-available/pacifica.conf" do
  source 'pacifica.conf.erb'
  mode '0644'
  variables({
    apache_dir: node['apache']['dir']
  })
  if File.symlink?("#{node['apache']['dir']}/sites-enabled/pacifica.conf")
    notifies :reload, 'service[apache2]'
  end
end
htpasswd "#{node['apache']['dir']}/htpasswd" do
  user 'dmlb2001'
  password '1234'
end
apache_site 'pacifica'
