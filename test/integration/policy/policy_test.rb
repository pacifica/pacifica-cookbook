# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe command 'sleep 7' do
  its(:exit_status) { should eq 0 }
end

describe port(8181) do
  it { should be_listening }
end

describe package 'curl' do
  it { should be_installed }
end

describe command 'curl localhost:8181/status/users/search/dmlb2001/simple' do
  its(:stdout) { should contain '"person_id": 10' }
end
