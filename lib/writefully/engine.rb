require 'jquery-rails'
require 'turbolinks'
require 'transponder'
require 'bootstrap-sass'

module Writefully
  class Engine < ::Rails::Engine
    isolate_namespace Writefully

    initializer 'Writefully precompile hook', group: :all do |app|
      app.config.assets.precompile += %w[
        writefully/writefully.js
        writefully/writefully.css
      ]
    end

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end  
  end
end
