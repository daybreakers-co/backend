class Trip
  include Mongoid::Document
  include Mongoid::Timestamps
  include Dateable

  field :title,    :type => String
  field :subtitle, :type => String
  field :public,   :type => Mongoid::Boolean

  field :post_count, :type => Integer
  field :photo_count, :type => Integer
  field :photographic_ids, :type => Array

  belongs_to :user
  has_many :posts, :dependent => :destroy

  def update_counts_and_photos
    published_posts = posts.published
    photographic_ids = published_posts.map(&:photographic_ids).flatten

    update_attributes!(
      :photo_count => photographic_ids.length,
      :photographic_ids => photographic_ids,
      :post_count => published_posts.length
    )
  end
end
