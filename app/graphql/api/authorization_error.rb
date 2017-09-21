module Api
  class AuthorizationError < GraphQL::ExecutionError
    MESSAGE = "You are not authorized to access this object.".freeze

    def initialize(ast_node: nil)
      super MESSAGE, ast_node: ast_node
    end
  end
end
