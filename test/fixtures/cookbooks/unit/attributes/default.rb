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
