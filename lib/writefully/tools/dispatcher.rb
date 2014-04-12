module Writefully
  module Tools
    class Dispatcher
      include Celluloid

      def initialize
        every 1.second do 
          async.process
        end
      end

      def process
        job_data = Writefully.redis.with { |c| c.spop 'jobs' }
        compute(job_data)
      end

      def retry
        
      end

      def compute job_data
        job      = Marshal.load(job_data)
        dispatch(job) if job_valid?(job)
      end

      def job_valid? job
        job.has_key?(:worker) and job.has_key?(:message)
      end

      def dispatch job
        Celluloid::Actor[job[:worker]].perform(job[:message])
      end
    end
  end
end