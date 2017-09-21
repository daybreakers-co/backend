module Types
  SectionEnum = GraphQL::EnumType.define do
    name        "SectionEnum"
    description "Sections make up a post"

    value("TEXT", "A piece of text with an (optional) title")
    value("PHOTOROW", "A horizontal list of photos")
    value("HERO", "A big photo")
  end
end
