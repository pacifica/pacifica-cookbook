module PacificaCookbook
  module Helper
    def call_pacifica_resource(resource)
      resource_map = {
        archiveinterface: pacifica_archiveinterface,
	cartbackend: pacifica_cartbackend,
	cartfrontend: pacifica_cartfrontend,
	ingestbackend: pacifica_ingestbackend,
	ingestfrontend: pacifica_ingestfrontend,
	metadata: pacifica_metadata,
	policy: pacifica_policy,
	proxy: pacifica_proxy,
	uniqueid: pacifica_uniqueid,
	uploader: pacifica_uploader,
	uploadercli: pacifica_uploadercli,
      }
      template = data_bag_item(node.read('pacifica', resource, 'data_bag'), node.read('pacifica', resource, 'template'))
      instances = node.read('pacifica', resource, 'instances')
      instances.each do |item|
        new_config = {}
	Chef::Mixin::DeepMerge::deep_merge(template, new_config)
	merge_config = data_bag_item(node.read('pacifica', resource, 'data_bag'), item)
	Chef::Mixin::DeepMerge::deep_merge(merge_config, new_config)
	resource_map[resource] do
          new_config.each do |key, value|
            send(key, value)
          end
	end
      end
    end
  end
end
