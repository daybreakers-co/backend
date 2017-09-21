module Api
  # Allow for `resolve_with_user` to be used in GraphQL field definitions.
  #
  # Automatically checks if the current_user is authorized to access the user and
  # if not raises and `AuthorizationError`.
  #
  # @example
  #   field :name, types.string do
  #     resolve_with_user -> (_parent, _args, context) do
  #       user = context[:current_user]
  #     end
  #   end
  class ResolveWithUser
    # Get a permission level and the "inner" resolve function
    def initialize(resolve_func)
      @resolve_func = resolve_func
    end

    def call(obj, args, context)
      # Check if authenticated user is member of app
      return Api::AuthorizationError.new unless context[:current_user]

      # and execute original proc
      @resolve_func.call(obj, args, context)
    end
  end
end
