Types::TripType = GraphQL::ObjectType.define do
  interfaces [Interfaces::ViewerRightsInterface, Interfaces::DateableInterface]

  name "Trip"
  field :id,      !types.String
  field :title,    types.String
  field :subtitle, types.String

  camelized_field :post_count, !types.Int
  camelized_field :photo_count, !types.Int

  field :photos, types[Types::PhotoType] do
    argument :sample, types.Int
    resolve ->(obj, args, context) do
      ids = obj.photographic_ids
      if args[:sample] && args[:sample] > 0
        ids = ids.sample(args[:sample])
      end

      ForeignKeyLoader.for(Photo, :photographic_id).load(ids)
    end
  end

  field :posts, types[Types::PostType] do
    resolve ->(obj, args, ctx) do
      if ctx[:current_user]
        obj.posts.asc(:created_at)
      else
        obj.posts.published.asc(:created_at)
      end
    end
  end
end
