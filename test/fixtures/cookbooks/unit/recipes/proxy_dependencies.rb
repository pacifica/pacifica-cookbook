include_recipe 'unit::policy_dependencies'
include_recipe 'unit::archiveinterface'
bash 'Load Archive Data' do
  code <<EOH
  sleep 3
  echo -n foo | curl -X PUT -T - -H 'Content-Length: 3' http://127.0.0.1:8080/104
EOH
end
execute 'Update Metadata' do
  command "curl -X POST -H 'Content-Type: application/json' http://127.0.0.1:8121/files?_id=104 -d'{ \"hashtype\": \"sha1\", \"hashsum\": \"0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33\", \"size\": \"3\" }'"
end
