include_recipe 'java'
include_recipe 'elasticsearch'

{
  pacifica_metadata: {
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
  pacifica: {
    password: 'pacifica',
    database_name: 'pacifica_metadata',
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
