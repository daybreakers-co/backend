class Section::PhotoRowSection < Section
  embeds_many :items, :class_name => "Section::PhotoRowSectionItem"
end
