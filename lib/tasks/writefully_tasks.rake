namespace :writefully do 
  desc "Writes content to database"
  task :write => :environment do 
    Writefully::Source.indices.each do |index|
      writer = Writefully::Writer.new(index)
      writer.async.write_content 
      writer.async.write_assets
    end
  end

  desc "Starts the writefully monitor"
  task :start => :environment do
    require 'writefully/monitor'
    Signal.trap("INT") { $stdout.puts "Writefully exiting..."; exit }
    Writefully::Monitor.new(Writefully.options).listen
  end
end