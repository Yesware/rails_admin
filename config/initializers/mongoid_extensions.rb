if defined?(::Mongoid::Document)
  require 'rails_admin/adapters/mongoid/extension'
  # TODO make the extension module not Mongoid-specific
  Mongoid::Document.send(:include, RailsAdmin::Adapters::Mongoid::Extension)
end
