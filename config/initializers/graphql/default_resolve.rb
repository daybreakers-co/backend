module GraphQLApiInitializers
  class DefaultResolve
    def self.call(target, func)
      target.resolve = Api::DefaultResolve.new(func)
    end
  end
end

GraphQL::Field.accepts_definitions(:resolve => GraphQLApiInitializers::DefaultResolve)
