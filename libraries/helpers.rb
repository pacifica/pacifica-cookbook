def call_pacifica_resource(resource)
  resource_map = {
    'archiveinterface' => ->(name, &block) { pacifica_archiveinterface(name, &block) },
    'cartbackend' => ->(name, &block) { pacifica_cartbackend(name, &block) },
    'cartfrontend' => ->(name, &block) { pacifica_cartfrontend(name, &block) },
    'ingestbackend' => ->(name, &block) { pacifica_ingestbackend(name, &block) },
    'ingestfrontend' => ->(name, &block) { pacifica_ingestfrontend(name, &block) },
    'metadata' => ->(name, &block) { pacifica_metadata(name, &block) },
    'policy' => ->(name, &block) { pacifica_policy(name, &block) },
    'proxy' => ->(name, &block) { pacifica_proxy(name, &block) },
    'uniqueid' => ->(name, &block) { pacifica_uniqueid(name, &block) },
    'uploader' => ->(name, &block) { pacifica_uploader(name, &block) },
    'uploadercli' => ->(name, &block) { pacifica_uploadercli(name, &block) },
  }
  template = data_bag_item(node.read('pacifica', resource, 'data_bag'), node.read('pacifica', resource, 'template'))
  template.delete('id')
  instances = node.read('pacifica', resource, 'instances')
  instances.each do |item|
    new_config = {}
    Chef::Mixin::DeepMerge.deep_merge(template, new_config)
    merge_config = data_bag_item(node.read('pacifica', resource, 'data_bag'), item)
    name = merge_config.delete('id')
    Chef::Mixin::DeepMerge.deep_merge(merge_config, new_config)
    send_block = proc do
      new_config.each do |key, value|
        send(key, value)
      end
    end
    resource_map[resource].call(name, &send_block)
  end
end
