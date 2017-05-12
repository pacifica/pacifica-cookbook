# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe port(8066) do
  it { should be_listening }
end

describe package 'curl' do
  it { should be_installed }
end

describe command 'curl -X POST -T /opt/ingestd/source/test_data/good.tar localhost:8066/upload' do
  its(:stdout) { should contain 'UPLOADING' }
end

describe command 'sleep 5; curl localhost:8066/get_state?job_id=1' do
  its(:stdout) { should contain '"task_percent": "100.00000"' }
  its(:stdout) { should contain '"state": "OK"' }
end
