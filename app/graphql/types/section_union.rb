module Types
  SectionUnion = GraphQL::UnionType.define do
    name        "Section"
    description "Sections make up a post"

    possible_types [
      Types::Section::TextSectionType,
      Types::Section::PhotoRowSectionType,
      Types::Section::HeroSectionType
    ]
  end
end
