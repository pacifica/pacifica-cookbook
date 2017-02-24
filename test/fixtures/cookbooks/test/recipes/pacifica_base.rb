pacifica_archiveinterface 'archiveinterface'
pacifica_cartfrontend 'cartwsgi'
pacifica_cartbackend 'cartd'
pacifica_metadata 'metadata'
pacifica_policy 'policy'
pacifica_proxy 'proxy'
pacifica_uniqueid 'uniqueid'
pacifica_ingestbackend 'ingestd'
pacifica_ingestfrontend 'ingestwsgi'
pacifica_uploaderbackend 'uploaderd'
pacifica_uploaderfrontend 'uploaderwsgi'
directory '/opt/uploader-data'
%w(uploaderd uploaderwsgi).each do |uploader_part|
  file "/opt/#{uploader_part}/source/UploaderConfig.json" do
    content data_bag_item('pacifica', 'uploader')['config'].to_json
  end
end
