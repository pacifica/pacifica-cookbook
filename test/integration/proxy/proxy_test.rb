# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe command 'sleep 7' do
  its(:exit_status) { should eq 0 }
end

describe port(8180) do
  it { should be_listening }
end

describe package 'curl' do
  it { should be_installed }
end
describe command "curl localhost:8180/files/sha1/0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33" do
  its(:stdout) { should contain 'foo' }
end
