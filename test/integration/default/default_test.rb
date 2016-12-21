# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

%w(
  8080
  8081
  8066
  8121
  8181
  8051
  80
).each do |port|
  describe port(port.to_i) do
    it { should be_listening }
  end
end

describe package 'git' do
  it { should be_installed }
end
