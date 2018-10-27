require 'rails_admin/adapters/active_record/abstract_object'

module RailsAdmin
  module Adapters
    module MongoMapper
      class AbstractObject < RailsAdmin::Adapters::ActiveRecord::AbstractObject
        def initialize(object)
          super
          object.associations.each do |name, association|
            association = Association.new(association, object.class)
            # TODO any other types?
            if [:has_many].include? association.type
              instance_eval <<-RUBY, __FILE__, __LINE__ + 1
              # e.g. if association is `users`, generate `user_ids`
              # @returns [Array] list of dependent IDs, e.g. user_ids
                def #{name.to_s.singularize}_ids
                  # TODO n+1?
                  #{name}.map{|item| item.id }
                end

                # Cribbed from Mongoid version. Should work with MongoMapper, but not tested

                # def #{name.to_s.singularize}_ids=(item_ids)
                #   __items__ = Array.wrap(item_ids).map{|item_id| #{name}.klass.find(item_id) rescue nil }.compact
                #   unless persisted?
                #     __items__.each do |item|
                #       item.update_attribute('#{association.foreign_key}', id)
                #     end
                #   end
                #   super __items__.map(&:id)
                # end
RUBY
            elsif [:has_one].include? association.type
              instance_eval <<-RUBY, __FILE__, __LINE__ + 1
                def #{name}_id=(item_id)
                  item = (#{association.klass}.find(item_id) rescue nil)
                  return unless item
                  item.update_attribute('#{association.foreign_key}', id) unless persisted?
                  super item.id
                end
RUBY
            end
          end
        end
      end
    end
  end
end
