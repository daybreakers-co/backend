Types::TripType = GraphQL::ObjectType.define do
  interfaces [Interfaces::ViewerRightsInterface]

  name "Trip"
  field :id,      !types.String
  field :title,    types.String
  field :subtitle, types.String

  field :header, Types::PhotoType do
    resolve ->(obj, args, context) do
      ForeignKeyLoader.for(Photo, :photographic_id).load(obj.id)
    end
  end

  field :posts, types[Types::PostType] do
    resolve ->(obj, args, ctx) do
      if ctx[:current_user]
        obj.posts
      else
        obj.posts.published
      end
    end
  end
end
