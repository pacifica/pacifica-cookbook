# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe port(8070) do
  it { should be_listening }
end

describe command 'curl -X POST -H "Http-Remote-User: dmlb2001" -H "Content-Type: application/json" localhost:8070/eventmatch -d"{\"name\": \"MyMatch\", \"jsonpath\": \"$.data\", \"target_url\": \"http://api.example.com/recieve\"}"' do
  its(:stdout) { should include 'uuid' }
end
