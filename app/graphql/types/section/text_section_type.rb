Types::Section::TextSectionType = GraphQL::ObjectType.define do
  name "TextSection"
  field :id,   !types.String
  field :title, types.String
  field :body,  types.String
  field :index, types.Int
end
