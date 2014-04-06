require 'writefully/tasks'

module Writefully
  class NewsAgency < Celluloid::SupervisionGroup
    supervise Roles::Journalist    as: :journalist
    supervise Roles::SiteBuilder   as: :site_builder
    pool      Roles::AssetsHandler as: :assets_handler, size: (Writefully.options[:concurrency] || 2)
  end
end