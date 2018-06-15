# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe port(8051) do
  it { should be_listening }
end

describe package 'curl' do
  it { should be_installed }
end

describe command 'curl "localhost:8051/getid?range=1&mode=test"' do
  its(:stdout) { should include 'endIndex' }
  its(:stdout) { should include 'startIndex' }
end
