include_recipe 'unit::archiveinterface'
include_recipe 'pacifica-dependencies::mysql_service'
include_recipe 'pacifica-dependencies::rabbitmq'
execute 'Load Archive Data' do
  command 'curl -X PUT http://127.0.0.1:8080/foo.txt -d1234'
end
include_recipe 'pacifica-dependencies::cartdb_setup'
