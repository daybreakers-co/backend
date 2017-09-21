class Photo
  include Mongoid::Document
  extend Dragonfly::Model
  dragonfly_accessor :image

  field :image_uid,    :type => String
  field :title,        :type => String
  field :image_width,  :type => Integer
  field :image_height, :type => Integer
  field :image_size,   :type => Integer

  belongs_to :photographic, :polymorphic => true

  def ratio
    (image_width.to_f / image_height.to_f).round(3)
  end
end
