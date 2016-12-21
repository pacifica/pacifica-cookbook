default['postgresql']['password']['postgres'] = 'postgres'
default['java']['jdk_version'] = '8'
case node['platform_family']
when 'rhel'
  override['elasticsearch']['install']['version'] = '5.2.1'
when 'debian'
  default['elasticsearch']['install']['version'] = '5.2.0'
end

default['rabbitmq']['loopback_users'] = []
default['rabbitmq']['virtualhosts'] = %w(/cart /ingest /uploader)
default['rabbitmq']['enabled_users'] = [
  {
    name: 'guest',
    password: 'guest',
    rights: [
      {
        vhost: '/uploader',
        conf: '.*',
        write: '.*',
        read: '.*',
      },
      {
        vhost: '/cart',
        conf: '.*',
        write: '.*',
        read: '.*',
      },
      {
        vhost: '/ingest',
        conf: '.*',
        write: '.*',
        read: '.*',
      },
    ],
  },
]
