include_recipe 'unit::metadata'
git "#{Chef::Config[:file_cache_path]}/pacifica-metadata" do
  repository 'https://github.com/pacifica/pacifica-metadata.git'
  action :sync
end

execute 'sleep 15'

execute 'Load Metadata Set' do
  environment LD_LIBRARY_PATH: '/opt/rh/python27/root/usr/lib64', LD_RUN_PATH: '/opt/rh/python27/root/usr/lib64'
  command '/opt/default/bin/python test_files/loadit.py'
  cwd "#{Chef::Config[:file_cache_path]}/pacifica-metadata"
end
