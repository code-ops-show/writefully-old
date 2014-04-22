module Writefully
  module Tools
    class Retryer
      include Celluloid

      attr_accessor :job

      def retry(job)
        @job   = job
        if job[:message][:tries] <= 5
          after(delay) { queue_retry }
        else
          mark_as_failed
        end 
      end

      def queue_retry
        Writefully.add_job job[:worker], job[:message].merge({ run: true })
      end

      def delay
        (job[:message][:tries] * job[:message][:tries]).seconds
      end

      def mark_as_failed
        Writefully.redis.with { |c| c.sadd 'failed', Marshal.dump(job) }
      end
    end
  end
end