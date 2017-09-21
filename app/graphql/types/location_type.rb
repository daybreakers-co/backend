Types::LocationType = GraphQL::ObjectType.define do
  name "Location"
  field :id,    !types.String
  field :title, !types.String
  field :lat,   !types.Float
  field :lng,   !types.Float
end
