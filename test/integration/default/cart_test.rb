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
    {"id":"foo.txt", "path":"1/2/3/foo.txt", "hashtype": "sha1", "hashsum": "4cbd040533a2f43fc6691d773d510cda70f4126a"}
  ]
}
EOF_JSON

describe command("curl -X POST http://127.0.0.1:8081/1234 -d'#{cartjson}'") do
  its(:stdout) { should match /Cart Processing has begun/ }
end

describe command('sleep 10; curl http://127.0.0.1:8081/1234 | file - | grep -q "POSIX tar archive"') do
  its(:exit_status) { should eq 0 }
end
