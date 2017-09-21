class Section::HeroSection < Section
  has_one :photo, :as => :photographic, :dependent => :destroy
end
