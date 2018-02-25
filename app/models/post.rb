class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Dateable

  field :title,      :type => String
  field :subtitle,   :type => String
  field :published,  :type => Mongoid::Boolean, :default => false

  belongs_to :user
  belongs_to :trip

  has_one :header, :as => :photographic, :dependent => :destroy, :class_name => "Photo"

  embeds_many :sections,  :cascade_callbacks => true
  embeds_many :locations, :cascade_callbacks => true

  scope :published, lambda {
    where(:published => true)
  }

  after_save :update_trip
  before_destroy lambda { |post| Photo.where(:photographic_id.in => photographic_ids).each(&:destroy) }

  def update_trip
    UpdateTripJob.perform_later trip.id.to_s
  end

  def photographic_ids
    @photographic_ids ||= sections.map(&:photographic_ids).flatten
  end
end
