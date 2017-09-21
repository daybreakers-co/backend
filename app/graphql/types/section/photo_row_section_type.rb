Types::Section::PhotoRowSectionType = GraphQL::ObjectType.define do
  name "PhotoRowSection"

  field :id,    !types.String
  field :index, !types.Int

  field :items, types[Types::Section::PhotoRowSectionItemType] do
    resolve ->(obj, arg, ctx) { obj.items.asc(:index) }
  end
end
