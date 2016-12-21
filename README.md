# Pacifica Cookbook

[![Build Status](https://travis-ci.org/pacifica/pacifica-cookbook.svg?branch=master)](https://travis-ci.org/pacifica/pacifica-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/pacifica.svg)](https://supermarket.chef.io/cookbooks/pacifica)

This cookbook configures [pacifica](https://github.com/pacifica/pacifica)
for deployment in a chef managed environment.

## Requirements

 - docker

### Other Notes
This cookbook does not provide the following services, nor does it offer the means to configure by default:
* postgresql
* mysql
* elasticsearch
* rabbit
* java

There is minimal configuration provided for:
* apache2/httpd

These services will need to be configured to taste before utilizing the custom resources this cookbook provides.

## Configuration

The attributes should give you an idea of what ports are where and how
to change the configuration.
