class Trip
  include Mongoid::Document
  include Mongoid::Timestamps
  include Dateable

  field :title,    :type => String
  field :subtitle, :type => String
  field :public,   :type => Mongoid::Boolean

  belongs_to :user
  has_many :posts, :dependent => :destroy

  def photographic_ids
    posts.map(&:photographic_ids).flatten
  end
end
