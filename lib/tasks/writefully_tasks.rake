namespace :writefully do 
  desc "Starts the writefully monitor"
  task :start do
    require 'writefully/process'
    Signal.trap("INT") { $stdout.puts "Writefully exiting..."; exit }
    Writefully::Process.new(Writefully.options).listen
  end
end