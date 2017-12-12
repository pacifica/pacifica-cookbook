#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'unit::archiveinterface' do
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version, step_into: 'pacifica_archiveinterface'
          ).converge(described_recipe)
        end

        it 'Installs the sqlite packages' do
          expect(chef_run).to install_package('default_packages')
        end

        it 'Converges successfully for default' do
          expect { chef_run }.to_not raise_error
        end

        it 'Installs git client' do
          expect(chef_run).to install_git_client('default')
        end

        it 'Creates prefix directory' do
          expect(chef_run).to create_directory('/opt/default')
        end

        it 'Creates the bash script file' do
          expect(chef_run).to create_file('/opt/default/PacificaArchiveInterface')
        end

        it 'Installs python runtime' do
          expect(chef_run).to install_python_runtime('default')
        end

        it 'Creates python virtual environment' do
          expect(chef_run).to create_python_virtualenv('/opt/default')
        end

        it 'Installs python requirements by python execute' do
          expect(chef_run).to run_python_execute('default_requirements')
        end

        it 'Creates poise service' do
          expect(chef_run).to create_poise_service('default')
        end

        it 'Enables and starts the service' do
          expect(chef_run).to enable_service('PacificaArchiveInterface')
          expect(chef_run).to start_service('PacificaArchiveInterface')
        end
      end
    end
  end
end
