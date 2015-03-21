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

      let(:retry_data) { { worker: job[:workeer], 
                           message: job[:message].merge({ tries: 2, run: false }) } }

      describe "#run_job" do 
        it "should call dispatch" do 
          Dispatcher.any_instance.stub(:job).and_return(job)
          Dispatcher.any_instance.stub(:retry_job).and_return(false)
          Dispatcher.any_instance.stub(:dispatch).and_return(true)
          dispatch = Dispatcher.new
          expect(dispatch.run_job).to be true
          dispatch.terminate
        end

        it "should call retry_job" do 
          Dispatcher.any_instance.stub(:job).and_return(retry_data)
          Dispatcher.any_instance.stub(:dispatch).and_return(false)
          Dispatcher.any_instance.stub(:retry_job).and_return(true)
          dispatch = Dispatcher.new
          expect(dispatch.run_job).to be true
          dispatch.terminate
        end
      end

      it "should be job and valid" do 
        Dispatcher.any_instance.stub(:job).and_return(job)
        dispatch = Dispatcher.new
        expect(dispatch.job_valid?).to be true
        expect(dispatch.retry_valid?).to be false
        dispatch.terminate
      end

      it "should be retry" do 
        Dispatcher.any_instance.stub(:job).and_return(retry_data)
        dispatch = Dispatcher.new
        expect(dispatch.retry_valid?).to be true
        dispatch.terminate
      end
    end
  end
end
