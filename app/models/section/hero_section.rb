class Section::HeroSection < Section
  has_one :photo, :as => :photographic, :dependent => :destroy

  def photographic_ids
    [id]
  end
end
