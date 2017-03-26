# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe port(8080) do
  it { should be_listening }
end

describe package 'curl' do
  it { should be_installed }
end

describe command('curl localhost:8080/robots.txt') do
  its(:stdout) { should match /blah/ }
end

describe command('curl -X PUT -H "Last-Modified: Sun, 06 Nov 1994 08:49:37 GMT" --upload-file /tmp/robots.txt http://127.0.0.1:8080/foo.txt') do
  its(:stdout) { should match /total_bytes/ }
end

describe file('/tmp/foo.txt') do
  it { should be_file }
  its(:content) { should match /blah/ }
end
