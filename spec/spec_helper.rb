require 'chefspec'
require 'chefspec/berkshelf'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

at_exit do
  ChefSpec::Coverage.report!
end
