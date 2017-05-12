include_recipe 'postgresql::ruby'
include_recipe 'postgresql::server'
include_recipe 'yum-mysql-community::mysql56'

mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'default_create' do
  instance 'default'
  initial_root_password 'mysql'
  action [:create]
end

execute 'chcon_mysql_default' do
  command 'chcon -R system_u:object_r:mysqld_db_t:s0 /var/lib/mysql-default'
  action :run
  only_if { rhel? }
end

mysql_service 'default_start' do
  instance 'default'
  initial_root_password 'mysql'
  action [:start]
end

postgresql_connection_info = {
  host: '127.0.0.1',
  port: node['postgresql']['config']['port'],
  username: 'postgres',
  password: 'postgres',
}
mysql_connection_info = {
  host: '127.0.0.1',
  socket: '/var/run/mysql-default/mysqld.sock',
  username: 'root',
  password: 'mysql',
}

{
  uniqueid: {
    provider: Chef::Provider::Database::Mysql,
    connection: mysql_connection_info,
  },
  ingest: {
    provider: Chef::Provider::Database::Mysql,
    connection: mysql_connection_info,
  },
  cartd: {
    provider: Chef::Provider::Database::Mysql,
    connection: mysql_connection_info,
  },
  status: {
    provider: Chef::Provider::Database::Postgresql,
    connection: postgresql_connection_info,
  },
  reporting: {
    provider: Chef::Provider::Database::Postgresql,
    connection: postgresql_connection_info,
  },
  metadata: {
    provider: Chef::Provider::Database::Postgresql,
    connection: postgresql_connection_info,
  },
}.each do |dbname, data|
  database dbname.to_s do
    data.each do |attr, value|
      send(attr.to_s, value)
    end
  end
end

{
  uniqueid: {
    password: 'uniqueid',
    connection: mysql_connection_info,
    host: '127.0.0.1',
    database_name: 'uniqueid',
    action: [:grant],
    provider: Chef::Provider::Database::MysqlUser,
  },
  cart: {
    password: 'cart',
    connection: mysql_connection_info,
    host: '127.0.0.1',
    database_name: 'cartd',
    action: [:grant],
    provider: Chef::Provider::Database::MysqlUser,
  },
  ingest: {
    password: 'ingest',
    connection: mysql_connection_info,
    host: '127.0.0.1',
    database_name: 'ingest',
    action: [:grant],
    provider: Chef::Provider::Database::MysqlUser,
  },
  reporting: {
    password: 'reporting',
    database_name: 'reporting',
    provider: Chef::Provider::Database::PostgresqlUser,
    connection: postgresql_connection_info,
    action: [:create, :grant],
  },
  status: {
    password: 'status',
    database_name: 'status',
    provider: Chef::Provider::Database::PostgresqlUser,
    connection: postgresql_connection_info,
    action: [:create, :grant],
  },
  metadata: {
    password: 'metadata',
    database_name: 'metadata',
    provider: Chef::Provider::Database::PostgresqlUser,
    connection: postgresql_connection_info,
    action: [:create, :grant],
  },
}.each do |user, data|
  database_user user.to_s do
    data.each do |attr, value|
      send(attr, value)
    end
  end
end
