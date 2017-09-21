Types::UserType = GraphQL::ObjectType.define do
  name "User"
  field :id,       !types.String
  field :username, !types.String
  field :email,    !types.String
  field :name,      types.String

  camelized_field :created_at, !Types::DateTimeType
  camelized_field :updated_at, !Types::DateTimeType

  camelized_field :is_viewer,  !types.Boolean do
    resolve -> (obj, args, ctx) { obj == ctx[:current_user] }
  end

  field :post, Types::PostType do
    argument :id, !types.String
    resolve ->(obj, args, ctx) { obj.posts.find(args[:id]) }
  end

  field :trips, types[Types::TripType] do
    resolve ->(obj, args, ctx) { obj.trips.desc(:created_at) }
  end

  field :trip, Types::TripType do
    argument :id, !types.String
    resolve -> (obj, args, ctx) { obj.trips.find(args[:id]) }
  end
end
