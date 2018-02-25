class Section::PhotoRowSection < Section
  embeds_many :items, :cascade_callbacks => true, :class_name => "Section::PhotoRowSectionItem"

  before_destroy lambda { |section| section.items.each(&:destroy) }

  def photographic_ids
    items.map(&:id)
  end
end
