require 'spec_helper'
require 'celluloid'
require 'writefully/tools'

module Writefully
  module Tools
    describe Dispatcher do 

      let(:job) { { worker: :journalists,
        message: { 
          resource: 'posts',
          slug: '1-hash-selector-pattern' } 
      }}

      let(:retry_data) { job.merge({ tries: 2 })}
      let(:failure) { job.merge({ tries: 6 }) }

      describe "#run_job" do 
        it "should call dispatch" do 
          Dispatcher.any_instance.stub(:job).and_return(job)
          Dispatcher.any_instance.stub(:dispatch).and_return(true)
          dispatch = Dispatcher.new
          dispatch.run_job.should be_true
          dispatch.terminate
        end

        it "should call retry_job" do 
          Dispatcher.any_instance.stub(:job).and_return(retry_data)
          Dispatcher.any_instance.stub(:retry_job).and_return(true)
          dispatch = Dispatcher.new
          dispatch.run_job.should be_true
          dispatch.terminate
        end

        it "should call retry_job" do 
          Dispatcher.any_instance.stub(:job).and_return(failure)
          Dispatcher.any_instance.stub(:mark_as_failed).and_return(true)
          dispatch = Dispatcher.new
          dispatch.run_job.should be_true
          dispatch.terminate
        end
      end


      it "should be retry" do 
        Dispatcher.any_instance.stub(:job).and_return(retry_data)
        dispatch = Dispatcher.new
        dispatch.is_job?.should be_true
        dispatch.job_valid?.should be_false
        dispatch.is_retry?.should be_true
        dispatch.retry_valid?.should be_true
        dispatch.terminate
      end

      it "should be job and valid" do 
        Dispatcher.any_instance.stub(:job).and_return(job)
        dispatch = Dispatcher.new
        dispatch.is_job?.should be_true
        dispatch.job_valid?.should be_true
        dispatch.is_retry?.should be_false
        dispatch.terminate
      end

      it "should be false for everything" do 
        Dispatcher.any_instance.stub(:job).and_return(failure)
        dispatch = Dispatcher.new
        dispatch.is_job?.should be_true
        dispatch.job_valid?.should be_false
        dispatch.is_retry?.should be_true
        dispatch.retry_valid?.should be_false
        dispatch.terminate
      end
    end
  end
end
