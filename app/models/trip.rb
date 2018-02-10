class Trip
  include Mongoid::Document
  include Mongoid::Timestamps
  include Dateable

  field :title,    :type => String
  field :subtitle, :type => String
  field :public,   :type => Mongoid::Boolean

  field :photo_count, :type => Integer
  field :photographic_ids, :type => Array

  belongs_to :user
  has_many :posts, :dependent => :destroy

  def update_photographic_ids
    photographic_ids = posts.published.map(&:photographic_ids).flatten

    update_attributes!(
      :photo_count => photographic_ids.length,
      :photographic_ids => photographic_ids
    )
  end
end
