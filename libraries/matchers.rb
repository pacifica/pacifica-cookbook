if defined?(ChefSpec)
  def create_pacifica_archiveinterface(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_archiveinterface, :create, resource_name
    )
  end

  def create_pacifica_cartbackend(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_cartbackend, :create, resource_name
    )
  end

  def create_pacifica_cartfrontend(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_cartfrontend, :create, resource_name
    )
  end

  def create_pacifica_ingestbackend(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_ingestbackend, :create, resource_name
    )
  end

  def create_pacifica_ingestfrontend(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_ingestfrontend, :create, resource_name
    )
  end

  def create_pacifica_metadata(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_metadata, :create, resource_name
    )
  end

  def create_pacifica_policy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_policy, :create, resource_name
    )
  end

  def create_pacifica_proxy(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_proxy, :create, resource_name
    )
  end

  def create_pacifica_reporting(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_reporting, :create, resource_name
    )
  end

  def create_pacifica_status(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_status, :create, resource_name
    )
  end

  def create_pacifica_uniqueid(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :pacifica_uniqueid, :create, resource_name
    )
  end

  def install_php_fpm_pool(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :php_fpm_pool, :install, resource_name
    )
  end

  def uninstall_php_fpm_pool(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :php_fpm_pool, :uninstall, resource_name
    )
  end

  def addormodify_selinux_policy_port(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :selinux_policy_port, :addormodify, resource_name
    )
  end

  def setpersist_selinux_policy_boolean(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :selinux_policy_boolean, :setpersist, resource_name
    )
  end

  def deploy_selinux_policy_module(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :selinux_policy_module, :deploy, resource_name
    )
  end

  def run_python_execute(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
      :python_execute, :run, resource_name
    )
  end
end
