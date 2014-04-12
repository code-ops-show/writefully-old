module Writefully
  module Tools
    class Dispatcher
      include Celluloid

      def initialize
        every 1.second do 
          async.heartbeat
        end
      end

      def heartbeat
        job_data = Writefully.redis.with { |c| c.spop 'jobs' }
        job      = Marshal.load(job_data)
        dispatch(job) if job_valid?(job)
      end

      def job_valid? job
        # should also check amount of retries and mark as failed
        job.has_key?(:worker) and job.has_key?(:message)
      end

      def dispatch job
        Celluloid::Actor[job[:worker]].perform(job[:message])
      end
    end
  end
end