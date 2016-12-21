#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'test::pacifica_varnish' do
  varnish_resource = { pacifica_varnish: 'varnishai' }
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
            platform: platform, version: version, step_into: varnish_resource.keys
          )
          runner.converge(described_recipe)
        end

        varnish_resource.each do |resource_key, resource_value|
          it "#{resource_key}:  Converges successfully for #{resource_value}" do
            expect { chef_run }.to_not raise_error
          end

          unless platform == 'ubuntu'
            it "#{resource_key}:  Includes the selinux_policy::install recipe" do
              expect(chef_run).to include_recipe('selinux_policy::install')
            end

            it "#{resource_key}:  Sets the varnishd SELinux connect any boolean" do
              expect(chef_run).to setpersist_selinux_policy_boolean('varnishd_connect_any')
            end

            it "#{resource_key}:  Sets the #{resource_value} SELinux Policy Port 6081" do
              expect(chef_run).to addormodify_selinux_policy_port('6081')
            end

            it "#{resource_key}:  Deploys the varnish log policy module" do
              expect(chef_run).to deploy_selinux_policy_module('allow_varnishlog_vsm')
            end

            it "#{resource_key}:  Runs `restorecon /var/log/varnish/*`" do
              expect(chef_run).to run_execute('restorecon /var/log/varnish/*')
            end

            it "#{resource_key}:  Configures the varnish repo for #{platform}" do
              expect(chef_run).to configure_varnish_repo(resource_value)
            end
          end

          it "#{resource_key}:  Configures the varnish vcl template" do
            expect(chef_run).to configure_vcl_template('default.vcl')
          end

          if platform == 'ubuntu'
            it "#{resource_key}:  Configures the varnish repo for #{platform}" do
              expect(chef_run).to add_apt_repository('varnish-cache_4.1')
            end
          end

          it "#{resource_key}:  Configures the varnish log" do
            expect(chef_run).to configure_varnish_log('default')
          end

          it "#{resource_key}:  Configures the varnish configuration" do
            expect(chef_run).to configure_varnish_config('default')
          end

          it "#{resource_key}:  Includes the chef-sugar::default recipe" do
            expect(chef_run).to include_recipe('chef-sugar::default')
          end

          it "#{resource_key}:  Create the varnish log" do
            expect(chef_run).to create_file_if_missing('/var/log/varnish/varnishlog.log')
          end

          it "#{resource_key}:  Installs the varnish package" do
            expect(chef_run).to install_package('varnish')
          end

          it "#{resource_key}:  Enables and starts the varnish service" do
            expect(chef_run).to enable_service('varnish')
            expect(chef_run).to start_service('varnish')
          end
        end
      end
    end
  end
end
