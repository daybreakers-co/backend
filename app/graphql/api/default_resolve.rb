module Api
  # Override default GraphQL resolver
  #
  # Adds check to rescue `Mongoid::Errors::DocumentNotFound` errors and returns
  # a more developer friendly error message instead.
  #
  # Can be expanded to support more errors.
  #
  # This will allow us to rely on this logic without having to manually add
  # checks for this everywhere in the GraphQL API.
  #
  # @example
  #   field :app, Types::AppType do
  #     resolve -> (_parent, _args, _context) do
  #       App.find("i-dont-exist")
  #       # No rescue needed!
  #     end
  #   end
  class DefaultResolve
    def initialize(resolve_func)
      @resolve_func = resolve_func
    end

    def call(obj, args, context)
      @resolve_func.call(obj, args, context)
    rescue Mongoid::Errors::DocumentNotFound
      Api::NotFoundError.new
    end
  end
end
