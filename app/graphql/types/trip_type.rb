Types::TripType = GraphQL::ObjectType.define do
  interfaces [Interfaces::ViewerRightsInterface, Interfaces::DateableInterface]

  name "Trip"
  field :id,      !types.String
  field :title,    types.String
  field :subtitle, types.String

  field :photos, types[Types::PhotoType] do
    argument :sample, types.Int
    resolve ->(obj, args, context) do
      ids = obj.photographic_ids
      ids = ids.sample(args[:sample]) if args[:sample] && args[:sample] > 0

      ForeignKeyLoader.for(Photo, :photographic_id).load(ids)
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
