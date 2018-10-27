if defined?(::MongoMapper::Document)
  require 'rails_admin/adapters/mongomapper/extension'
  ::MongoMapper::Document.send(:include, RailsAdmin::Adapters::MongoMapper::Extension)
end
