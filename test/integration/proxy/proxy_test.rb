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
hashsum = Digest::SHA1.file('README.md').hexdigest
describe command "curl localhost:8180/files/sha1/#{hashsum}" do
  its(:stdout) { should contain '# Pacifica Cookbook' }
end
