module Writefully
  class NewsAgency < Celluloid::SupervisionGroup
    pool      Tools::Pigeon,          as: :pigeons,     size: ((Writefully.options[:concurrency] * 4) rescue 2)
    pool      Workers::Journalist,    as: :journalists, size: (Writefully.options[:concurrency] rescue 2)
    
    supervise Workers::Builder,       as: :builder
  end
end