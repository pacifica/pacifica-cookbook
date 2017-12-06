include_recipe 'unit::cart_dependencies'
pacifica_cartfrontend 'default' do
  service_name 'cartserver'
  script_name 'cartserver'
  config_name 'cart.ini'
end
pacifica_cartbackend 'default' do
  service_name 'cartd'
  script_name 'cartd'
  config_name 'cart.ini'
end
