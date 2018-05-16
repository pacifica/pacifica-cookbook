require 'chefspec'
require 'chefspec/berkshelf'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  config.formatter = :documentation
  config.color = true
end

at_exit do
  ChefSpec::Coverage.report!
end
