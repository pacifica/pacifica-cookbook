#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'unit::policy' do
  before do
    postgres_metadata_db
  end
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version
          ).converge(described_recipe)
        end

        it 'Setups pacifica policy' do
          expect(chef_run).to create_pacifica_policy('default')
        end

        it 'Converges successfully for default' do
          expect { chef_run }.to_not raise_error
        end
      end
    end
  end
end
