module RailsAdmin
  module Adapters
    module MongoMapper
      class Association
        attr_reader :association, :model

        # @param association [MongoMapper::Plugins::Associations::Base]
        # @param model [Class]
        def initialize(association, model)
          @association = association
          @model = model
        end


        def name
          association.name.to_sym
        end

        def pretty_name
          name.to_s.tr('_', ' ').capitalize
        end

        def type
          case association#.class
          # case association
          when ::MongoMapper::Plugins::Associations::BelongsToAssociation
            :belongs_to
          when ::MongoMapper::Plugins::Associations::OneAssociation
            :has_one
          when ::MongoMapper::Plugins::Associations::ManyAssociation
            :has_many
            # TODO what's SingleAssociation?
          else
            raise("Unknown association type: #{association.inspect}")
          end
        end

        def klass
      #     if polymorphic? && [:referenced_in, :belongs_to].include?(macro)
      #       polymorphic_parents(:mongoid, model.name, name) || []
      #     else
            association.klass
      #     end
        end
      #
        def primary_key
          :_id
        end

        def foreign_key
          return if embeds?
          association.foreign_key.to_sym rescue nil
        end
      #
      #   def foreign_key_nullable?
      #     return if foreign_key.nil?
      #     true
      #   end
      #
      #   def foreign_type
      #     return unless polymorphic? && [:referenced_in, :belongs_to].include?(macro)
      #     association.inverse_type.try(:to_sym) || :"#{name}_type"
      #   end
      #
      #   def foreign_inverse_of
      #     return unless polymorphic? && [:referenced_in, :belongs_to].include?(macro)
      #     inverse_of_field.try(:to_sym)
      #   end
      #
      #   def as
      #     association.as.try :to_sym
      #   end
      #
        def polymorphic?
          association.polymorphic? #&& [:referenced_in, :belongs_to].include?(macro)
        end
      #
      #   def inverse_of
      #     association.inverse_of.try :to_sym
      #   end
      #
      #   def read_only?
      #     false
      #   end
      #
        def nested_options
          # TODO are these supported?
          nil
        end
      #
      #   def association?
      #     true
      #   end
      #
      #   def macro
      #     association.try(:macro) || association.class.name.split('::').last.underscore.to_sym
      #   end
      #
        def embeds?
          association.embeddable?
        end
      #
      # private
      #
      #   def inverse_of_field
      #     association.respond_to?(:inverse_of_field) && association.inverse_of_field
      #   end
      #
      #   def cyclic?
      #     association.respond_to?(:cyclic?) ? association.cyclic? : association.cyclic
      #   end
      #
      #   delegate :nested_attributes_options, to: :model, prefix: false
      #   delegate :polymorphic_parents, to: RailsAdmin::AbstractModel
      end
    end
  end
end
