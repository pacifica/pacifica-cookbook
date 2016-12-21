#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'test::pacifica_base_php' do
  base_php_resource = {
    pacifica_status: 'status',
    pacifica_reporting: 'reporting',
  }
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    stub_command(%r{/ls \/.*\/config.php/}).and_return(false)
    stub_command('grep -q http://127.0.0.1 /opt/status/source/application/config/production/config.php').and_return(true)
    stub_command('grep -q http://127.0.0.1 /opt/reporting/source/application/config/production/config.php').and_return(true)
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('/usr/sbin/httpd -t').and_return(true)
    stub_command('grep -q http://127.0.0.1 /opt/status/source/application/config/production/config.php').and_return(false)
    stub_command('grep -q http://127.0.0.1 /opt/reporting/source/application/config/production/config.php').and_return(false)
    base_php_resource.each do |_resource_key, resource_value|
      stub_command("chcon -R system_u:object_r:httpd_sys_content_t:s0 /opt/#{resource_value}/source").and_return(false)
    end
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          runner = ChefSpec::ServerRunner.new(
            platform: platform, version: version, step_into: base_php_resource.keys
          )
          runner.converge(described_recipe)
        end
        base_php_resource.each do |resource_key, resource_value|
          unless platform == 'ubuntu'
            it "#{resource_key}:  Includes selinux::install" do
              expect(chef_run).to include_recipe('selinux_policy::install')
            end

            it "#{resource_key}:  Sets the #{resource_value} SELinux Context" do
              expect(chef_run).to run_execute("set_#{resource_value}_selinux_context")
            end

            it "#{resource_key}:  Sets the #{resource_value} SELinux Policy Port" do
              expect(chef_run).to addormodify_selinux_policy_port("#{resource_value}_9000")
            end

            it "#{resource_key}:  Sets the #{resource_value} SELinux Policy Boolean" do
              expect(chef_run).to setpersist_selinux_policy_boolean("#{resource_value}_httpd")
            end

            it "#{resource_key}:  Fixes the ownership of the source files in #{resource_value} repo" do
              expect(chef_run).to run_execute("chcon -R system_u:object_r:httpd_sys_content_t:s0 /opt/#{resource_value}/source")
            end
          end

          it "#{resource_key}:  Converges successfully for #{resource_value}" do
            expect { chef_run }.to_not raise_error
          end

          it "#{resource_key}:  Installs git client" do
            expect(chef_run).to install_git_client(resource_value)
          end

          it "#{resource_key}:  Creates #{resource_value} directory" do
            expect(chef_run).to create_directory("/opt/#{resource_value}")
          end

          it "#{resource_key}:  Syncs #{resource_value} git repository" do
            expect(chef_run).to sync_git("/opt/#{resource_value}/source")
          end

          it "#{resource_key}:  Creates #{resource_value} logs directory" do
            expect(chef_run).to create_directory("/opt/#{resource_value}/source/application/logs")
          end

          it "#{resource_key}:  Includes chef-sugar::default" do
            expect(chef_run).to include_recipe('chef-sugar::default')
          end

          it "#{resource_key}:  Includes apache2::default" do
            expect(chef_run).to include_recipe('apache2::default')
          end

          it "#{resource_key}:  Includes php recipes" do
            expect(chef_run).to include_recipe('php::default')
            expect(chef_run).to include_recipe('php::module_pgsql')
            expect(chef_run).to include_recipe('php::module_sqlite3')
            expect(chef_run).to include_recipe('php::module_gd')
          end

          it "#{resource_key}:  Change #{resource_value} git ownership to apache user and group" do
            expect(chef_run).to run_execute("chown_#{resource_value}_files")
          end

          it "#{resource_key}:  Creates #{resource_value} config from a template" do
            expect(chef_run).to create_template("/opt/#{resource_value}/source/application/config/production/config.php")
          end

          it "#{resource_key}:  Creates #{resource_value} production database from a template" do
            expect(chef_run).to create_template("#{resource_value}_create_prod_database")
          end

          it "#{resource_key}:  Sets the #{resource_value} PHP FPM Pool" do
            case platform
            when 'redhat', 'centos'
              expect(chef_run).to install_php_fpm_pool("php-fpm_#{resource_value}")
            when 'ubuntu'
              expect(chef_run).to install_php_fpm_pool("php7.0-fpm_#{resource_value}")
            end
          end

          it "#{resource_key}:  Enables and starts the #{resource_value} PHP FPM Service" do
            case platform
            when 'redhat', 'centos'
              expect(chef_run).to enable_service("php-fpm_#{resource_value}")
              expect(chef_run).to start_service("php-fpm_#{resource_value}")
            when 'ubuntu'
              expect(chef_run).to enable_service("php7.0-fpm_#{resource_value}")
              expect(chef_run).to start_service("php7.0-fpm_#{resource_value}")
            end
          end

          it "#{resource_key}:  Enables and starts the apache/httpd service" do
            case platform
            when 'redhat', 'centos'
              expect(chef_run).to enable_service('httpd')
              expect(chef_run).to start_service('httpd')
            when 'ubuntu'
              expect(chef_run).to enable_service('apache2')
              expect(chef_run).to start_service('apache2')
            end
          end
        end
      end
    end
  end
end
