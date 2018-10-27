module RailsAdmin
  module Adapters
    module MongoMapper
      class Property
        attr_reader :property, :model

        # @param property [MongoMapper::Plugins::Keys::Key]
        # @param model [Class]
        def initialize(property, model)
          @property = property
          @model = model
        end

        def name
          property.name.to_sym
        end

        def pretty_name
          property.name.to_s.tr('_', ' ').capitalize
        end

        # TODO DRY up with Mongoid version if possible
        # TODO test each one
        def type
          case property.type.to_s
          when 'Array', 'Hash', 'Money'
            :serialized
          when 'BigDecimal'
            :decimal
          when /Boolean/
            :boolean
          when 'BSON::ObjectId', 'Moped::BSON::ObjectId', 'ObjectId'
            :bson_object_id
          when 'Date'
            :date
          when 'ActiveSupport::TimeWithZone', 'DateTime', 'Time'
            :datetime
          when 'Float'
            :float
          when 'Integer'
            :integer
          when 'Object'
            object_field_type
          when 'String', 'Symbol'
            :string
          else
            :string
          end
        end

        def length
          length_validator = model.validators.find do |v|
            v.is_a?(ActiveModel::Validations::LengthValidator) && v.attributes == [name]
          end
          # TODO if multiple validators, take lowest one, cf Mongoid
          length_validator ? length_validator.options[:maximum] : 255
        end

        def nullable?
          # TODO what's this mean?
          true
          # property.null
        end

        def serial?
          property.name == "_id"
        end

        def association?
          false
        end

        def read_only?
          false
        end

        # TODO DRY up with Mongoid version
        def object_field_type
          return :bson_object_id if model.associations.detect do |_k, association|
            association.class.in?([
              MongoMapper::Plugins::Associations::BelongsToAssociation,
              MongoMapper::Plugins::Associations::EmbeddedCollection # TODO verify, add other classes
            ]) && association.name == property.name
          end
          # [:belongs_to, :referenced_in, :embedded_in].include?(association.macro)
          :string
        end
        private :object_field_type
      end
    end
  end
end
