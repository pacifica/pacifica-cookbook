# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe command('/opt/default/bin/CLIUploader --config /opt/default/default-pacifica-uploadercli.ini --help') do
  its(:exit_status) { should eq 0 }
end
