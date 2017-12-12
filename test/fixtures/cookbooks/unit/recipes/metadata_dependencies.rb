include_recipe 'chef-sugar'
include_recipe 'java'
include_recipe 'elasticsearch'

packages = if ubuntu?
             %w(postgresql postgresql-client)
           elsif rhel?
             %w(postgresql-server postgresql)
           end
service_name = 'postgresql'

package 'PostgreSQL Packages' do
  package_name packages
end

setup_command = if rhel? && (node[:platform_version].to_i == 6)
                  'service postgresql initdb'
                else
                  'postgresql-setup initdb'
                end

execute 'Setup PostgreSQL Database' do
  environment PGSETUP_INITDB_OPTIONS: '--encoding=utf8'
  command setup_command
  only_if { rhel? }
  not_if { ::File.exist?('/var/lib/pgsql/data/pg_hba.conf') }
end

file '/var/lib/pgsql/data/pg_hba.conf' do
  content <<-EOH
local all all ident
host pacifica_metadata  pacifica 127.0.0.1/32 md5
host pacifica_metadata  pacifica ::1/128 md5
EOH
  only_if { rhel? }
end

service 'PostgreSQL Service' do
  service_name service_name
  action [:enable, :start]
end

execute 'Wait for DB' do
  command 'sleep 5'
end

execute 'Create Pacifica Database' do
  command %(psql -c "create database pacifica_metadata with encoding 'UTF8';")
  user 'postgres'
  not_if %(psql -c '\\l' | grep -q pacifica_metadata), user: 'postgres'
end

execute 'Create Pacifica Role' do
  command %(psql -c "create role pacifica with login password 'pacifica';")
  user 'postgres'
  not_if %(psql -c 'SELECT rolname FROM pg_roles;' | grep -q pacifica), user: 'postgres'
end

execute 'Grant Pacifica Permissions' do
  command %(psql -c "grant all on database pacifica_metadata to pacifica;")
  user 'postgres'
  not_if %(psql -c '\\l' | grep -q pacifica=), user: 'postgres'
end
