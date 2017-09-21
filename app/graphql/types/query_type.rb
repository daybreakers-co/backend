Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :viewer, Types::ViewerType do
    description "(Authenticated) user of the GraphQL API"
    resolve ->(obj, args, ctx) { ctx[:current_user] }
  end

  field :user, Types::UserType do
    argument :username, !types.String
    resolve ->(obj, args, ctx) { User.find_by!(:username => args[:username]) }
  end
end
