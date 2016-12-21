#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'test::pacifica_nginx' do
  nginx_resource = { pacifica_nginx: 'nginxai' }
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    stub_command(%r{/ls \/.*\/config.php/}).and_return(false)
    stub_command('grep -q http://127.0.0.1 /opt/status/source/application/config/production/config.php').and_return(true)
    stub_command('grep -q http://127.0.0.1 /opt/reporting/source/application/config/production/config.php').and_return(true)
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('/usr/sbin/httpd -t').and_return(true)
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          runner = ChefSpec::ServerRunner.new(
            platform: platform, version: version, step_into: nginx_resource.keys
          )
          runner.converge(described_recipe)
        end

        nginx_resource.each do |resource_key, resource_value|
          it "#{resource_key}:  Converges successfully for #{resource_value}" do
            expect { chef_run }.to_not raise_error
          end

          unless platform == 'ubuntu'
            it "#{resource_key}:  Sets the #{resource_value} SELinux httpd connect boolean" do
              expect(chef_run).to setpersist_selinux_policy_boolean('httpd_can_network_connect')
            end
            it "#{resource_key}:  Sets the #{resource_value} SELinux Policy Port 9000" do
              expect(chef_run).to addormodify_selinux_policy_port('9000')
            end
          end

          it "#{resource_key}:  Creates the nginx directory in /etc" do
            expect(chef_run).to create_directory('/etc/nginx')
          end

          it "#{resource_key}:  Renders the #{resource_key} nginx configuration" do
            expect(chef_run).to create_template("nginx_#{resource_value}_conf")
          end

          it "#{resource_key}:  Installs the nginx package" do
            expect(chef_run).to install_package('nginx')
          end

          it "#{resource_key}:  Renders the #{resource_key} nginx site configuration" do
            expect(chef_run).to create_template("nginx_#{resource_value}_site_conf")
          end

          it "#{resource_key}:  Deletes the default nginx site" do
            expect(chef_run).to delete_file('/etc/nginx/sites-enabled/default')
          end

          it "#{resource_key}:  Enables and starts the nginx service" do
            expect(chef_run).to enable_service('nginx')
            expect(chef_run).to start_service('nginx')
          end
        end
      end
    end
  end
end
