class Section::PhotoRowSectionItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sortable

  embedded_in :photo_row_section
  has_one :photo, :as => :photographic, :dependent => :destroy

  def ensure_index
    write_attribute(:index, photo_row_section.items.length - 1)
  end
end
