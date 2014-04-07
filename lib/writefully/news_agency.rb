module Writefully
  class NewsAgency < Celluloid::SupervisionGroup
    pool      Tools::Pigeon,        as: :pigeons, size: (Writefully.options[:concurrency] || 2)
    supervise Tools::Pencil,        as: :pencil

    supervise Roles::Journalist,    as: :journalist
    supervise Roles::SiteBuilder,   as: :site_builder
  end
end