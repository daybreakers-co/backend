class Section::PhotoRowSection < Section
  embeds_many :items, :class_name => "Section::PhotoRowSectionItem"

  def photographic_ids
    items.map(&:id)
  end
end
