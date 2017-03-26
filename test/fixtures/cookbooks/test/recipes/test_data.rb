# upload test data sets
python_virtualenv '/opt/metadata/virtualenv'
python_execute 'metadata_test_data_upload' do
  virtualenv '/opt/metadata/virtualenv'
  cwd '/opt/metadata/source'
  command '-m test_files.loadit && touch /opt/metadata/.mdloaded'
  not_if { File.exist?('/opt/metadata/.mdloaded') }
end

execute 'build test ingest tar' do
  cwd '/opt/ingestd/source/test_data'
  command 'cp metadata-files/good-md.json metadata.txt && tar -cf good.tar metadata.txt data'
  not_if { File.exist?('/opt/ingestd/source/test_data/good.tar') }
end
