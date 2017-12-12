include_recipe 'unit::policy_dependencies'
include_recipe 'unit::archiveinterface'
execute 'Load Archive Data' do
  command 'curl -X PUT http://127.0.0.1:8080/104 --upload-file /tmp/kitchen/cache/cookbooks/pacifica/README.md'
end
hashsum = Digest::SHA1.file('/tmp/kitchen/cache/cookbooks/pacifica/README.md').hexdigest
filesize = File.new('/tmp/kitchen/cache/cookbooks/pacifica/README.md').size
execute 'Update Metadata' do
  command "curl -X POST -H 'Content-Type: application/json' http://127.0.0.1:8121/files?_id=104 -d'{ \"hashtype\": \"sha1\", \"hashsum\": \"#{hashsum}\", \"size\": \"#{filesize}\" }'"
end
