Types::ViewerType = GraphQL::ObjectType.define do
  name "Viewer"
  field :id,       !types.String
  field :username, !types.String
  field :email,    !types.String
  field :name,      types.String

  camelized_field :authentication_token, !types.String

  camelized_field :created_at, !Types::DateTimeType
  camelized_field :updated_at, !Types::DateTimeType

  field :post, Types::PostType do
    argument :id, !types.String

    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].posts.find(args[:id])
    end
  end

  field :trips, types[Types::TripType] do
    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].trips.desc(:created_at)
    end
  end

  field :trip, Types::TripType do
    argument :id, !types.String
    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].trips.find(args[:id])
    end
  end
end
