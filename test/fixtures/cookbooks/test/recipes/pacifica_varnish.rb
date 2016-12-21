cookbook_file '/tmp/robots.txt' do
  source 'robots.txt'
end
pacifica_varnish 'varnishai' do
  backend_hosts ['127.0.0.1:8080']
end
