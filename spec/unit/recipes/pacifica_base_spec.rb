#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'test::pacifica_base' do
  base_resource = {
    pacifica_archiveinterface: 'archiveinterface',
    pacifica_cartfrontend: 'cartwsgi',
    pacifica_cartbackend: 'cartd',
    pacifica_metadata: 'metadata',
    pacifica_policy: 'policy',
    pacifica_proxy: 'proxy',
    pacifica_uniqueid: 'uniqueid',
    pacifica_ingestbackend: 'ingestd',
    pacifica_ingestfrontend: 'ingestwsgi',
    pacifica_uploaderbackend: 'uploaderd',
    pacifica_uploaderfrontend: 'uploaderwsgi',
  }
  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow(File).to receive(:exist?).and_call_original
    base_resource.each_value do |resource_value|
      allow(File).to receive(:exist?).with(
        "/opt/#{resource_value}/.dbcreate"
      ).and_return(false)
      allow(File).to receive(:exist?).with(
        "/opt/#{resource_value}/source/DatabaseCreate.py"
      ).and_return(true)
      stub_command("DatabaseCreate.py && touch /opt/#{resource_value}/.dbcreate").and_return(true)
      allow(File).to receive(:exist?).with(
        "/opt/#{resource_value}/source/setup.py"
      ).and_return(true)
      stub_command("setup.py install --prefix /opt/#{resource_value}/virtualenv").and_return(true)
    end
    stub_command(%r{/ls \/.*\/config.php/}).and_return(false)
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('/usr/sbin/httpd -t').and_return(true)
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version, step_into: base_resource.keys
          ) do |_node, server|
            server.create_data_bag(
              'pacifica',
              'uploader' => {
                id: 'uploader',
                config: 'this is the config',
              }
            )
          end.converge(described_recipe)
        end

        base_resource.each do |resource_key, resource_value|
          it "#{resource_key}:  Installs the #{resource_value} packages" do
            expect(chef_run).to install_package("#{resource_value}_packages")
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

          it "#{resource_key}:  Creates the #{resource_value} bash script file" do
            expect(chef_run).to create_file("/opt/#{resource_value}/#{resource_value}")
          end

          it "#{resource_key}:  Installs python runtime" do
            expect(chef_run).to install_python_runtime(resource_value)
          end

          it "#{resource_key}:  Creates #{resource_value} python virtual environment" do
            expect(chef_run).to create_python_virtualenv(
              "/opt/#{resource_value}/virtualenv"
            )
          end

          it "#{resource_key}:  Installs #{resource_value} python requirements" do
            expect(chef_run).to run_python_execute(
              "#{resource_value}_requirements"
            )
          end

          it "#{resource_key}:  Installs #{resource_value} uwsgi with pip" do
            expect(chef_run).to run_python_execute(
              "#{resource_value}_uwsgi"
            )
          end

          it "#{resource_key}:  Builds #{resource_value} python virtual environment" do
            expect(chef_run).to run_python_execute("#{resource_value}_build")
          end

          it "#{resource_key}:  DatabaseCreate #{resource_value} python virtual environment" do
            expect(chef_run).to run_python_execute("#{resource_value}_dbcreate")
          end

          it "#{resource_key}:  Creates #{resource_value} systemd service" do
            expect(chef_run).to create_systemd_service(resource_value)
          end

          it "#{resource_key}:  Enables and starts the #{resource_value} service" do
            expect(chef_run).to enable_service(resource_value)
            expect(chef_run).to start_service(resource_value)
          end
        end
      end
    end
  end
end
