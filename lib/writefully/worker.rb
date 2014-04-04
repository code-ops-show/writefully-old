module Writefully
  class Worker
    include Celluloid
    include Tasks::Writer
    include Tasks::Repository  
  end
end