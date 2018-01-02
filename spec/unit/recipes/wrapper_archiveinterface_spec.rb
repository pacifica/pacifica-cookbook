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
            platform: platform, version: version, step_into: 'pacifica_data_bag_wrapper'
          ) do |node, server|
            node.normal['pacifica']['archiveinterface']['instances'] = %w(foo bar)
            server.create_data_bag(
              'pacifica_archiveinterface',
              'template' => {
                'id' => 'template',
              },
              'foo' => {
                'id' => 'foo',
                'port' => 8192,
              },
              'bar' => {
                'id' => 'bar',
                'port' => 4096,
              }
            )
          end.converge(described_recipe)
        end

        it 'Converges successfully for default' do
          expect { chef_run }.to_not raise_error
        end
        it 'Creates the pacifica archiveinterface data bag wrapper' do
          expect(chef_run).to create_pacifica_data_bag_wrapper('archiveinterface')
        end
        it 'Creates foo pacifica archiveinterface' do
          expect(chef_run).to create_pacifica_archiveinterface('foo').with(
            port: 8192
          )
        end
        it 'Creates bar pacifica archiveinterface' do
          expect(chef_run).to create_pacifica_archiveinterface('bar').with(
            port: 4096
          )
        end
      end
    end
  end
end
