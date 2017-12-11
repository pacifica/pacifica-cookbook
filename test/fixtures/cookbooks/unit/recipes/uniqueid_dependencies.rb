include_recipe 'chef-sugar'
include_recipe 'build-essential'
packages = if rhel?
             if node[:platform_version].to_i == 6
               %w(mysql-server mysql mysql-devel)
             elsif node[:platform_version].to_i == 7
               %w(mariadb-server mariadb mariadb-devel)
             end
           elsif ubuntu?
             %w(mysql-client mysql-server libmysqlclient-dev)
           end
service_name = if rhel?
	         if node[:platform_version].to_i == 6
                   'mysqld'
		 elsif node[:platform_version].to_i == 7
	           'mariadb'
		 end
               elsif ubuntu?
                 'mysql'
               end
mysql_bin = '/usr/bin/mysql'
package 'CentOS SCL Packages' do
  package_name %w(centos-release-scl centos-release-scl-rh)
  only_if { rhel? }
end
package 'MySQL Packages' do
  package_name packages
end	
service 'MySQL Service' do
  service_name service_name
  action [:start, :enable]
end
execute 'Create UniqueID Database' do
  command "#{mysql_bin} -e 'create database pacifica_uniqueid;'"
  not_if "#{mysql_bin} -e 'show databases;' | grep -q pacifica_uniqueid"
end
execute 'Grant/Create UniqueID User' do
  command "#{mysql_bin} -e 'grant all on pacifica_uniqueid.* to uniqueid@'\\''localhost'\\'' identified by '\\''uniqueid'\\'';'"
  not_if "#{mysql_bin} -e 'select User from mysql.user;' | grep uniqueid"
end
