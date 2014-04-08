module Writefully
  class NewsAgency < Celluloid::SupervisionGroup
    pool      Tools::Pigeon,        as: :pigeons, size: (Writefully.options[:concurrency] rescue 2)
    supervise Tools::Pencil,        as: :pencil
    supervise Tools::Hammer,        as: :hammer

    supervise Roles::Journalist,    as: :journalist
    supervise Roles::SiteBuilder,   as: :site_builder
  end
end