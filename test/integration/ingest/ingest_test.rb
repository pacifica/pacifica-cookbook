# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe port(8066) do
  it { should be_listening }
end

describe command 'LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64 /opt/default/bin/python -m pip install git+https://github.com/pacifica/pacifica-python-uploader.git@master' do
  its(:exit_status) { should be 0 }
end
describe command 'LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64 /opt/default/bin/python -m pip install git+https://github.com/pacifica/pacifica-cli-uploader.git@master' do
  its(:exit_status) { should be 0 }
end

describe command 'mkdir -p /etc/pacifica-cli' do
  its(:exit_status) { should be 0 }
end
describe command 'curl -o /etc/pacifica-cli/uploader.json https://raw.githubusercontent.com/pacifica/pacifica-cli-uploader/master/travis/uploader.json' do
  its(:exit_status) { should be 0 }
end

configure_uploader = %q(printf 'http://localhost:8066/upload\nhttp://localhost:8066/get_state\nhttp://localhost:8181/uploader\nTrue\nNone\n' | LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64 /opt/default/bin/CLIUploader configure)
describe command configure_uploader do
  its(:exit_status) { should eq 0 }
end

upload_command = %q(cd /etc ; LD_LIBRARY_PATH=/opt/rh/python27/root/usr/lib64 /opt/default/bin/CLIUploader upload --logon 10 group)
describe command upload_command do
  its(:exit_status) { should eq 0 }
end

describe command 'sleep 5; curl localhost:8066/get_state?job_id=1' do
  its(:stdout) { should contain '"task_percent": "100.00000"' }
  its(:stdout) { should contain '"state": "OK"' }
end
