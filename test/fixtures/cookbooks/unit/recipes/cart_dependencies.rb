include_recipe 'unit::archiveinterface'
include_recipe 'yum-mysql-community::mysql56'

mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'default' do
  initial_root_password 'mysql'
  action [:start]
end

mysql_connection_info = {
  host: '127.0.0.1',
  socket: '/var/run/mysql-default/mysqld.sock',
  username: 'root',
  password: 'mysql',
}

database 'cartd' do
  provider Chef::Provider::Database::Mysql
  connection mysql_connection_info
end

database_user 'cart' do
  password 'cart'
  connection mysql_connection_info
  host '127.0.0.1'
  database_name 'cartd'
  action [:grant]
  provider Chef::Provider::Database::MysqlUser
end
