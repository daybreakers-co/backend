class Trip
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,    :type => String
  field :subtitle, :type => String
  field :public,   :type => Mongoid::Boolean

  belongs_to :user
  has_one :header, :as => :photographic, :dependent => :destroy, :class_name => "Photo"
  has_many :posts, :dependent => :destroy
end
