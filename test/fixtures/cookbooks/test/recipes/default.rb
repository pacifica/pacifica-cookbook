include_recipe 'chef-sugar'
selinux_state 'SELinux Enforcing' do
  action :enforcing
  only_if { rhel? }
end
execute '/sbin/setenforce 1' do
  only_if { rhel? }
end
include_recipe 'test::database'
include_recipe 'test::messaging'
include_recipe 'test::elasticsearch'
include_recipe 'test::pacifica_nginx'
include_recipe 'test::http_proxy'
include_recipe 'test::pacifica'
include_recipe 'test::test_data'
