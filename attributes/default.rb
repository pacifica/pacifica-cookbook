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
  default['pacifica'][service]['data_bag'] = "pacifica_#{service}"
  default['pacifica'][service]['instances'] = ['default']
  default['pacifica'][service]['template'] = 'template'
end
