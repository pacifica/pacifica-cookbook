# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe port(8081) do
  it { should be_listening }
end

cartjson = <<EOF_JSON
{
  "fileids": [
    {"id":"foo.txt", "path":"1/2/3/foo.txt", "hashtype": "sha1", "hashsum": "7110eda4d09e062aa5e4a390b0a572ac0d2c0220"}
  ]
}
EOF_JSON

describe command("curl -X POST -H 'Content-Type: application/json' http://127.0.0.1:8081/1234 -d'#{cartjson}'") do
  its(:stdout) { should match /Cart Processing has begun/ }
end

describe command('sleep 10; curl http://127.0.0.1:8081/1234 | file - | grep -q "POSIX tar archive"') do
  its(:exit_status) { should eq 0 }
end
