Types::Section::HeroSectionType = GraphQL::ObjectType.define do
  name "HeroSection"

  field :id,    !types.String
  field :index, !types.Int

  field :photo, Types::PhotoType do
    resolve ->(obj, _, _) do
      ForeignKeyLoader.for(Photo, :photographic_id).load(obj.id)
    end
  end
end
