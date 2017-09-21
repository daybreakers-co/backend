Types::Section::PhotoRowSectionItemType = GraphQL::ObjectType.define do
  name "PhotoRowSectionItem"

  field :id,    !types.String
  field :index, !types.Int

  field :photo, Types::PhotoType do
    resolve ->(obj, args, context) do
      ForeignKeyLoader.for(Photo, :photographic_id).load(obj.id)
    end
  end
end
