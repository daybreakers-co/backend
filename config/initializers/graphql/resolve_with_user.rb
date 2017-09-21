module GraphQLApiInitializers
  class ResolveWithUser
    def self.call(target, func)
      target.resolve = Api::DefaultResolve.new(Api::ResolveWithUser.new(func))
    end
  end
end

GraphQL::Field.accepts_definitions(:resolve_with_user => GraphQLApiInitializers::ResolveWithUser)
