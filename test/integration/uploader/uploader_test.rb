# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe command('LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64 /opt/default/bin/python -c "import uploader"') do
  its(:exit_status) { should eq 0 }
end
