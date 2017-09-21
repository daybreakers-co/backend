Types::PostType = GraphQL::ObjectType.define do
  interfaces [Interfaces::ViewerRightsInterface]

  name "Post"
  field :id,       types.String
  field :title,    types.String
  field :subtitle, types.String

  field :published, types.Boolean

  camelized_field :publish_date, !Types::DateType
  camelized_field :created_at,   !Types::DateTimeType
  camelized_field :updated_at,   !Types::DateTimeType

  field :locations, types[Types::LocationType]

  field :trip, !Types::TripType

  field :header, Types::PhotoType do
    resolve ->(obj, args, context) do
      ForeignKeyLoader.for(Photo, :photographic_id).load(obj.id)
    end
  end

  field :sections, types[Types::SectionUnion] do
    resolve -> (obj, args, ctx) { obj.sections.asc(:index) }
  end

  field :next, Types::PostType do
    resolve ->(obj, args, ctx) do
      Post
        .where(
          :trip_id => obj.trip_id,
          :created_at.gt => obj.created_at
        )
        .asc(:created_at)
        .first
    end
  end

  field :previous, Types::PostType do
    resolve ->(obj, args, ctx) do
      Post
        .where(
          :trip_id => obj.trip_id,
          :created_at.lt => obj.created_at
        )
        .desc(:created_at)
        .first
    end
  end
end
