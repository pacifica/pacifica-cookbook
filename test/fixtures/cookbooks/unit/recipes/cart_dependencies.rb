include_recipe 'unit::archiveinterface'
include_recipe 'pacifica-dependencies::mysql_service'
include_recipe 'pacifica-dependencies::rabbitmq'
package 'file'
bash 'Load Archive Data' do
  code <<EOH
  echo -n 1234 | curl -X PUT -T - -H 'Content-Length: 4' http://127.0.0.1:8080/foo.txt
EOH
end
include_recipe 'pacifica-dependencies::cartdb_setup'
