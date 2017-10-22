Types::TripType = GraphQL::ObjectType.define do
  interfaces [Interfaces::ViewerRightsInterface, Interfaces::DateableInterface]

  name "Trip"
  field :id,      !types.String
  field :title,    types.String
  field :subtitle, types.String

  field :photos, types[Types::PhotoType] do
    resolve ->(obj, args, context) do
      ForeignKeyLoader.for(Photo, :photographic_id).load(obj.photographic_ids)
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
