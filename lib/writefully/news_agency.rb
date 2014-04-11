module Writefully
  class NewsAgency < Celluloid::SupervisionGroup
    pool      Tools::Pigeon,          as: :pigeons,     size: ((Writefully.options[:concurrency] * 2) rescue 2)

    pool      Workers::Journalist,    as: :journalists, size: (Writefully.options[:concurrency] rescue 2)
    supervise Workers::SiteBuilder,   as: :site_builder
  end
end