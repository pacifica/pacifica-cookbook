# This is the primary shared library for Pacifica custom resources
module PacificaCookbook
  # Pacifica base class with common properties and actions
  class PacificaDBWrapper < Chef::Resource
    resource_name :pacifica_data_bag_wrapper
    property :name, String, name_property: true
    property :data_bag_path, Array, default: lazy { ['pacifica', name, 'data_bag'] }
    property :template_item_path, Array, default: lazy { ['pacifica', name, 'template'] }
    property :instances_list_path, Array, default: lazy { ['pacifica', name, 'instances'] }
    property :db_data_bag_path, Array, default: %w(pacifica secrets vault)
    property :db_secrets_path, Array, default: %w(pacifica secrets item)
    property :variables, Hash, default: {}
    default_action :create
    action :create do
      template = data_bag_item(node.read(*new_resource.data_bag_path), node.read(*new_resource.template_item_path)).to_hash
      template.delete('id')
      node.read(*new_resource.instances_list_path).each do |instance|
        new_config = {}
        new_config = Chef::Mixin::DeepMerge.deep_merge!(template, new_config)
        merge_config = data_bag_item(node.read(*new_resource.data_bag_path), instance).to_hash
        new_config = Chef::Mixin::DeepMerge.deep_merge!(merge_config, new_config)
        new_config.delete('chef_type')
        new_config.delete('data_bag')
        new_config.delete('id')
        namespace = OpenStruct.new(
          db_data_bag: chef_vault_item(
            node.read(*new_resource.db_data_bag_path),
            node.read(*new_resource.db_secrets_path)
          ).to_hash
        )
        new_config = JSON.parse(ERB.new(new_config.to_json).result(namespace.instance_eval { binding }))
        declare_resource("pacifica_#{new_resource.name}".to_sym, instance) do
          new_config.each do |key, value|
            send(key, Marshal.load(Marshal.dump(value)))
          end
        end
      end
    end
  end
end
