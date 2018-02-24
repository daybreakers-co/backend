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

  after_create :send_to_s3
  before_destroy :remove_from_s3

  def ratio
    (image_width.to_f / image_height.to_f).round(3)
  end

  def s3_bucket
    Fog::Storage.new(
      :provider => "AWS",
      :aws_access_key_id => Rails.application.secrets.aws_access_key_id,
      :aws_secret_access_key => Rails.application.secrets.aws_secret_access_key,
      :region => "eu-central-1"
    ).directories.new(:key => Rails.application.secrest.aws_bucket)
  end

  def send_to_s3
    return unless Rails.env.production?
    s3_bucket.files.create(:key => "#{id}.#{image.ext}", :body => image.data, :public => false)
  end

  def remove_from_s3
    return unless Rails.env.production?
    s3_bucket.files.destroy(:key => "#{id}.#{image.ext}")
  end
end
