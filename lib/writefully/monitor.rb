require 'listen'
require 'logger'

module Writefully
  Monitor = Struct.new(:config) do

    def logger
      @logger ||= Logger.new(log_location)
    end

    def log_location
      Writefully.env == 'development' ? STDOUT : config[:logfile]
    end

    def listen
      logger.info("This is doctor Frasier Crane. I'm listening...")
      pool = worker_pool
      listener = Listen.to config[:content], wait_for_delay: 4, &process_message(pool)
      listener.start
      while listener.listen?
        sleep 0.5
      end
    end

    def worker_pool
      @_pool ||= Worker.pool
    end

    def process_message(pool)
      Proc.new do |modified, added, removed|
        pool.write(get_indices(modified))
      end
    end

    def get_indices(modified)
      modified.map do |file_name|
        index_hash_from(index_name_from(remove_content_path(file_name)))
      end
    end

    def remove_content_path(file_name)
      file_name.split('/') - Writefully.options[:content].split('/')
    end

    def index_name_from(array)
      [:resource, :slug].zip(array).flatten
    end

    def index_hash_from(array)
      Hash[*array]
    end

  end
end