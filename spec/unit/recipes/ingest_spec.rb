#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'unit::ingest' do
  before do
    stub_command("/usr/bin/mysql -e 'show databases;' | grep -q pacifica_ingest").and_return(true)
    stub_command("/usr/bin/mysql -e 'select User from mysql.user;' | grep ingest").and_return(true)
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version
          ).converge(described_recipe)
        end

        it 'Setups pacifica ingest frontend' do
          expect(chef_run).to create_pacifica_ingestfrontend('default')
        end

        it 'Setups pacifica ingest backend' do
          expect(chef_run).to create_pacifica_ingestbackend('default')
        end

        it 'Converges successfully for default' do
          expect { chef_run }.to_not raise_error
        end
      end
    end
  end
end
