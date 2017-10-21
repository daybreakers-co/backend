class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,      :type => String
  field :subtitle,   :type => String
  field :start_date, :type => Date, :default => -> { Date.today }
  field :end_date,   :type => Date, :default => -> { Date.today }
  field :published,  :type => Mongoid::Boolean, :default => false

  belongs_to :user
  belongs_to :trip

  has_one :header, :as => :photographic, :dependent => :destroy, :class_name => "Photo"

  embeds_many :sections,  :cascade_callbacks => true
  embeds_many :locations, :cascade_callbacks => true

  scope :published, lambda {
    where(:published => true, :publish_date.lte => Time.now)
  }

  def photographic_ids
    sections.map(&:photographic_ids).flatten
  end
end
