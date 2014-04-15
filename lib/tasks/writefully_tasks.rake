require 'writefully/process'

namespace :writefully do 
  desc "Starts the writefully monitor"
  task :start do
    Signal.trap("INT") { $stdout.puts "Writefully exiting..."; exit }
    Writefully::Process.new(Writefully.options).listen
  end
end