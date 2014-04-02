module Writefully
  class Engine < ::Rails::Engine
    isolate_namespace Writefully

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end  
  end
end
