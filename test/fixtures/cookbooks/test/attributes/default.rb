default['postgresql']['password']['postgres'] = 'postgres'
default['java']['jdk_version'] = '8'
default['elasticsearch']['install']['version'] = '5.4.0'

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
