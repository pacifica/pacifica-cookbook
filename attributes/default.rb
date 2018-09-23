%w(
  archiveinterface
  cartbackend
  cartfrontend
  ingestbackend
  ingestfrontend
  metadata
  notifybackend
  notifyfrontend
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
default['pacifica']['secrets']['vault'] = 'pacifica_vault'
default['pacifica']['secrets']['item'] = 'secrets'
