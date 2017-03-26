# upload test data sets
python_execute 'metadata_test_data_upload' do
  virtualenv '/opt/metadata/virtualenv'
  cwd '/opt/metadata/source'
  command '-m test_files.loadit'
end
