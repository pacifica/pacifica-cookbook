%w(
  archiveinterface
  cartbackend
  cartfrontend
  ingestbackend
  ingestfrontend
  metadata
  policy
  proxy
  uniqueid
  uploader
  uploadercli
).each do |service|
  node['pacifica'][service]['data_bag'] = "pacifica_#{service}"
  node['pacifica'][service]['instances'] = ['default']
  node['pacifica'][service]['template'] = 'template'
end
