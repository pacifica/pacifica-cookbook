# Pacifica Cookbook

[![Build Status](https://travis-ci.org/pacifica/pacifica-cookbook.svg?branch=master)](https://travis-ci.org/pacifica/pacifica-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/pacifica.svg)](https://supermarket.chef.io/cookbooks/pacifica)

This library cookbook provides resources
to install and configures [pacifica](https://github.com/pacifica/pacifica)

## Requirements

- Chef 12.5.x or higher. Chef 11 is NOT SUPPORTED, please do not open issues about it.
- Ruby 2.1 or higher (preferably, the Chef full-stack installer)
- Network accessible web server hosting the docker binary.

## Platform Support

The following platforms have been tested with Test Kitchen: You may be
able to get it working on other platforms, with appropriate
configuration of cgroups and storage back ends.

| Platform     | Tested |
|--------------|:------:|
| centos-7.3   | ✔      |
| ubuntu-16.04 | ✔      |

## Cookbook Dependencies

- [compat_resource](https://supermarket.chef.io/cookbooks/compat_resource)
- [docker](https://supermarket.chef.io/cookbooks/docker)
- [apache2](https://supermarket.chef.io/cookbooks/apache2)
- [git](https://supermarket.chef.io/cookbooks/git)
- [poise-python](https://supermarket.chef.io/cookbooks/poise-python)
- [systemd](https://supermarket.chef.io/cookbooks/systemd)
- [php](https://supermarket.chef.io/cookbooks/php)
- [varnish](https://supermarket.chef.io/cookbooks/varnish)
- [chef-sugar](https://supermarket.chef.io/cookbooks/chef-sugar)
- [selinux](https://supermarket.chef.io/cookbooks/selinux)
- [selinux_policy](https://supermarket.chef.io/cookbooks/selinux_policy)
- [yum-epel](https://supermarket.chef.io/cookbooks/yum-epel)

### Other Notes
This cookbook does not provide the following services, nor does it offer the means to configure by default:
* postgresql - Suggested cookbook [database](https://supermarket.chef.io/cookbooks/database) or [postgresql](https://supermarket.chef.io/cookbooks/postgresql)
* mysql - Suggested cookbook [database](https://supermarket.chef.io/cookbooks/database) or [mysql](https://supermarket.chef.io/cookbooks/mysql)
* elasticsearch - Suggested cookbook [elasticsearch](https://supermarket.chef.io/cookbooks/elasticsearch)
* rabbit - Suggested cookbook [rabbitmq](https://supermarket.chef.io/cookbooks/rabbitmq)
* java - Suggested cookbook [java](https://supermarket.chef.io/cookbooks/java)

There is minimal configuration provided for:
* [apache2/httpd](https://supermarket.chef.io/cookbooks/apache2)
* [nginx](https://supermarket.chef.io/cookbooks/chef_nginx)
* [varnish](https://supermarket.chef.io/cookbooks/varnish)

These services will need to be configured to taste before utilizing the custom resources this cookbook provides.

## Usage

- Add `depends 'pacifica'` to your cookbook's metadata.rb
- Use the resources shipped in cookbook in a recipe, the same way
  you'd use core Chef resources (file, template, directory, package,
  etc).

## Resources Overview

- [pacifica_archiveinterface](#pacifica_archiveinterface): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_cartbackend](#pacifica_cartbackend): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_cartfrontend](#pacifica_cartfrontend): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_ingestbackend](#pacifica_ingestbackend): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_ingestfrontend](#pacifica_ingestfrontend): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_metadata](#pacifica_metadata): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_policy](#pacifica_policy): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_uniqueid](#pacifica_uniqueid): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_uploaderbackend](#pacifica_uploaderbackend): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_uploaderfrontend](#pacifica_uploaderfrontend): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_reporting](#pacifica_reporting): composite resource that uses
  libraries/pacifica_base_php.rb and tailored resource properties
- [pacifica_status](#pacifica_status): composite resource that uses
  libraries/pacifica_base_php.rb and tailored resource properties
- [pacifica_nginx](#pacifica_nginx): resource provides a minimal nginx configuration
  and creates selinux policies on RHEL systems
- [pacifica_varnish](#pacifica_varnish): resource provides a varnish configuration,
  deploys the varnish service, and creates selinux policies on RHEL systems

See full documentation for each resource and action below for more information.

## Resources Details

## `pacifica_base.rb` shared properties:
- name - Name of the resource
- prefix - prefix directory to put source code git clones
- directory_opts - prefix directory resource options appended via hash
- virtualenv_opts - virtualenv direcotry resource options appended via hash
- python_opts - python_virtualenv resource options appended via hash
- pip_install_opt - python_execute pip install options appended via hash
- build_opts - python_execute setup.py options appended via hash
- script_opts - file resource with creation script options appended via hash
- git_opts - git resource options appended via hash
- git_client_opts - git client resource options appended via hash
- service_opts - systemd_service resource options appended via hash
- wsgi_file - Name of the wsgi for a defined service
- port - http socket port used in the init script for each service
- run_command - composite property used to activate a defined Pacifica service

## `pacifica_base_php.rb` shared properties:
- name - Name of the resource
- prefix - prefix directory to put source code git clones
- directory_opts - prefix directory resource options appended via hash
<!-- - site_fqdn, String, default: 'http://127.0.0.1' -->
- git_opts - git resource options appended via hash
- git_client_opts - git client resource options appended via hash
- php_fpm_opts - appended via hash
- ci_prod_config_opts - appended via hash
- ci_prod_config_vars - appended via hash
- ci_prod_database_opts - appended via hash
- ci_prod_database_vars - appended via hash

## pacifica_archiveinterface

The `pacifica_archiveinterface` resource manages the desired archive interface and associated configuration.

### Example

```ruby
pacifica_archiveinterface 'archiveinterface'
```

## pacifica_cartbackend

The `pacifica_cartbackend` resource manages the desired cart back-end and associated configuration.

### Example

```ruby
pacifica_cartbackend 'cartd'
```

## pacifica_cartfrontend

The `pacifica_cartfrontend` resource manages the desired cart front-end and associated configuration.

### Example

```ruby
pacifica_cartfrontend 'cartwsgi'
```

## pacifica_ingestbackend

The `pacifica_ingestbackend` resource manages the desired ingest back-end and associated configuration.

### Example

```ruby
pacifica_ingestbackend 'ingestd'
```

## pacifica_ingestfrontend

The `pacifica_ingestfrontend` resource manages the desired ingest front-end and associated configuration.

### Example

```ruby
pacifica_ingestfrontend 'ingestwsgi'
```

## pacifica_metadata

The `pacifica_metadata` resource manages the metadata service and associated configuration.

### Example

```ruby
pacifica_metadata 'metadata'
```

## pacifica_policy

The `pacifica_policy` resource manages the policy service and associated configuration.

### Example

```ruby
pacifica_policy 'policy'
```

## pacifica_uniqueid

The `pacifica_uniqueid` resource manages the uniqueid service and associated configuration.

### Example

```ruby
pacifica_uniqueid 'uniqueid'
```

## pacifica_uploaderbackend

The `pacifica_uploaderbackend` resource manages the uploader back-end service and associated configuration.

### Example

```ruby
pacifica_uploaderbackend 'uploaderd'
```

## pacifica_uploaderfrontend

The `pacifica_uploaderfrontend` resource manages the uploader front-end service and associated configuration.

### Example

```ruby
pacifica_uploaderfrontend 'uploaderwsgi'
```

## pacifica_reporting

The `pacifica_reporting` resource manages the reporting service and associated configuration.

### Example

```ruby
pacifica_reporting 'reporting'
```

## pacifica_status

The `pacifica_status` resource manages the status service and associated configuration.

### Example

```ruby
pacifica_status 'status'
```

## pacifica_nginx

The `pacifica_nginx` resource manages a basic nginx service and associated configuration.

### Example

```ruby
pacifica_nginx 'nginxai' do
  backend_hosts ['127.0.0.1:8080']
end
```

## pacifica_varnish

The `pacifica_varnish` resource manages a basic varnish service and associated configuration.

### Example

```ruby
pacifica_varnish 'varnishai' do
  backend_hosts ['127.0.0.1:8080']
end
```

## Testing and Development

- Full development and testing workflow with Test Kitchen and friends:

  <testing.md>
  </testing.md>

## Contributing

Please see contributing information in:

<contributing.md>
</contributing.md>

## Maintainers

- David M. Brown ([dmlb2000@gmail.com](mailto:dmlb2000@gmail.com))
- Ian Smith ([gitbytes@gmail.com](mailto:gitbytes@gmail.com))

## License

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License. You may
obtain a copy of the License at


```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied. See the License for the specific language governing
permissions and limitations under the License.
