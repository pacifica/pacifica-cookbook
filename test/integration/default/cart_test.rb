# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe port(8081) do
  it { should be_listening }
end

cartjson = File.open('/tmp/cart.json', 'w')
cartjson.write <<EOF_JSON
{
  "fileids": [
    {"id":"foo.txt", "path":"1/2/3/foo.txt"}
  ]
}
EOF_JSON
cartjson.close

describe command('curl -X POST --upload-file /tmp/cart.json http://127.0.0.1:8081/1234') do
  its(:stdout) { should match /Cart Processing has begun/ }
end

describe command('sleep 3') do
  its(:exit_status) { should eq 0 }
end

describe command('curl http://127.0.0.1:8081/1234 | file - | grep -q "POSIX tar archive"') do
  its(:exit_status) { should eq 0 }
end
