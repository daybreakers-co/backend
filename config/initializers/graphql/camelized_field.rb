# Helper for camelized field names
#
# Convenience helper for camelized fields we define as underscored names for
# easier mapping to fields in the database.
#
# This helper differs from `camelized_hash_field` which is used for mapping to
# Hash objects. This helper is used when the object being passed to the
# GraphQL gem is an Object / Model.
#
# @example
#   camelized_field :user_name, types.string
#   # same as
#   field :userName, types.string, :property => :user_name
module CamelizedField
  def self.call(target, field_name, *args, &block)
    # modify the incoming name:
    camelized_field_name = field_name.to_s.camelize(:lower)

    # use the original name as the `property:` keyword argument:
    if args.last.is_a?(Hash)
      keyword_args = args.last
    else
      keyword_args = {}
      args << keyword_args
    end
    keyword_args[:property] = field_name

    # use the new name to create a GraphQL::Field:
    GraphQL::Define::AssignObjectField.call(target, camelized_field_name, *args, &block)
  end
end

GraphQL::ObjectType.accepts_definitions(:camelized_field => CamelizedField)
GraphQL::InterfaceType.accepts_definitions(:camelized_field => CamelizedField)
