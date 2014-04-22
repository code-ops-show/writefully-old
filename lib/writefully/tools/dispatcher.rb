module Writefully
  module Tools
    class Dispatcher
      include Celluloid

      attr_reader :job

      def initialize
        every 1.second do 
          async.heartbeat
        end
      end

      def get_job_data
        Writefully.redis.with { |c| c.spop 'jobs' }
      end

      def heartbeat
        @job      = Marshal.load(get_job_data)
        run_job if is_job?
      end

      def run_job
        if    retry_valid?   then retry_job
        elsif job_valid?     then dispatch
        end
      end

      def dispatch
        Celluloid::Actor[job[:worker]].perform(job[:message])
      end

      def retry_job
        Celluloid::Actor[:retryer].retry(job)
      end

      def is_job?
        job.has_key?(:worker) and job.has_key?(:message)
      end

      def is_retry?
        is_job? and job[:message].has_key?(:tries) and job[:message].has_key?(:run)
      end

      def job_valid?
        is_job? and job.keys.count == 2
      end

      def retry_valid?
        is_retry? and (job[:message][:run] == false)
      end

    end
  end
end