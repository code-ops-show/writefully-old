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
        if is_retry? and retry_valid? then retry_job
        elsif is_job? and job_valid?  then dispatch
        else mark_as_failed end
      end

      def dispatch
        Celluloid::Actor[job[:worker]].perform(job[:message])
      end

      def retry_job
        after((job[:tries] * job[:tries]).seconds) { dispatch(job) }
      end

      def mark_as_failed
        Writefully.redis.with { |c| c.sadd 'failed', Marshal.dump(job) }
      end

      def is_job?
        job.has_key?(:worker) and job.has_key?(:message)
      end

      def is_retry?
        is_job? and job.has_key?(:tries)
      end

      def job_valid?
        job.keys.count == 2
      end

      def retry_valid?
        job[:tries] <= 5
      end

    end
  end
end