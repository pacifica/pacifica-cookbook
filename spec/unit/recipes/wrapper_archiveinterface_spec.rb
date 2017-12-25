#
# Cookbook Name:: pacifica
# Spec:: pacifica_archiveinterface
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pacifica::archiveinterface' do
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on an #{platform.capitalize}-#{version} box" do
        cached(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform, version: version
          ) do |node, server|
            node.normal['pacifica']['archiveinterface']['instances'] = %w(foo bar)
            server.create_data_bag(
              'pacifica_archiveinterface',
              'template' => {
                'id' => 'template',
              },
              'foo' => {
                'id' => 'foo',
                'port' => '8192',
              },
              'bar' => {
                'id' => 'bar',
                'port' => '4096',
              }
            )
          end.converge(described_recipe)
        end

        it 'Converges successfully for default' do
          expect { chef_run }.to_not raise_error
        end
        it 'Creates foo pacifica archiveinterface' do
          expect(chef_run).to create_pacifica_archiveinterface('foo')
        end
        it 'Creates bar pacifica archiveinterface' do
          expect(chef_run).to create_pacifica_archiveinterface('bar')
        end
      end
    end
  end
end