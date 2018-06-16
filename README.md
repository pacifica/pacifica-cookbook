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
| centos-7.4   | ✔      |
| ubuntu-16.04 | ✔      |

## Cookbook Dependencies

- [git](https://supermarket.chef.io/cookbooks/git)
- [poise-python](https://supermarket.chef.io/cookbooks/poise-python)
- [poise-service](https://supermarket.chef.io/cookbooks/poise-service)
- [chef-sugar](https://supermarket.chef.io/cookbooks/chef-sugar)

### Other Notes
This cookbook does not provide the following services, nor does it offer the means to configure by default:
* postgresql - Suggested cookbook [database](https://supermarket.chef.io/cookbooks/database) or [postgresql](https://supermarket.chef.io/cookbooks/postgresql)
* mysql - Suggested cookbook [database](https://supermarket.chef.io/cookbooks/database) or [mysql](https://supermarket.chef.io/cookbooks/mysql)
* elasticsearch - Suggested cookbook [elasticsearch](https://supermarket.chef.io/cookbooks/elasticsearch)
* rabbit - Suggested cookbook [rabbitmq](https://supermarket.chef.io/cookbooks/rabbitmq)
* java - Suggested cookbook [java](https://supermarket.chef.io/cookbooks/java)

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
- [pacifica_proxy](#pacifica_proxy): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_uniqueid](#pacifica_uniqueid): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_uploader](#pacifica_uploader): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties
- [pacifica_uploadercli](#pacifica_uploadercli): composite resource that uses
  libraries/pacifica_base.rb and tailored resource properties

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
- port - http socket port used in the init script for each service
- run_command - composite property used to activate a defined Pacifica service

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

## pacifica_proxy

The `pacifica_proxy` resource manages the proxy service and associated configuration.

### Example

```ruby
pacifica_proxy 'proxy'
```

## pacifica_uniqueid

The `pacifica_uniqueid` resource manages the uniqueid service and associated configuration.

### Example

```ruby
pacifica_uniqueid 'uniqueid'
```

## pacifica_uploader

The `pacifica_uploader` resource manages the uploader python library and associated configuration.

### Example

```ruby
pacifica_uploader 'uploader'
```

## pacifica_uploadercli

The `pacifica_uploadercli` resource manages the uploader CLI and associated configuration.

### Example

```ruby
pacifica_uploadercli 'uploadercli'
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
