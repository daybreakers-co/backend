# Helper for camelized argument names
#
# Convenience helper for camelized arguments we define as underscored names for
# easier mapping to fields in the database.
#
# @example
#   camelized_argument :user_name, types.string
#   # same as
#   argument :userName, types.string, :as => :user_name
module CamelizedArgument
  def self.call(target, argument_name, *args, &block)
    # modify the incoming name:
    camelized_argument_name = argument_name.to_s.camelize(:lower)

    # use the original name as the `as:` keyword argument:
    if args.last.is_a?(Hash)
      keyword_args = args.last
    else
      keyword_args = {}
      args << keyword_args
    end
    keyword_args[:as] = argument_name

    # use the new name to create a GraphQL::Argument:
    GraphQL::Define::AssignArgument.call(target, camelized_argument_name, *args, &block)
  end
end

GraphQL::Field.accepts_definitions(:camelized_argument => CamelizedArgument)
GraphQL::ObjectType.accepts_definitions(:camelized_argument => CamelizedArgument)
GraphQL::InputObjectType.accepts_definitions(:camelized_argument => CamelizedArgument)
GraphQL::InterfaceType.accepts_definitions(:camelized_argument => CamelizedArgument)
