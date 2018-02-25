class Photo
  include Mongoid::Document
  extend Dragonfly::Model
  dragonfly_accessor :image do
    storage_options do |attachment|
      { :path => storage_path(attachment) }
    end
  end

  field :image_uid,    :type => String
  field :title,        :type => String
  field :image_width,  :type => Integer
  field :image_height, :type => Integer
  field :image_size,   :type => Integer

  belongs_to :photographic, :polymorphic => true

  def ratio
    (image_width.to_f / image_height.to_f).round(3)
  end

  def storage_path(attachment)
    post_id = case photographic_type
              when "Post"
                Post.find(photographic_id).id
              when "Section::PhotoRowSectionItem"
                Post.find_by('sections.items._id' => BSON::ObjectId.from_string(photographic_id)).id
              else
                Post.find_by('sections._id' => BSON::ObjectId.from_string(photographic_id)).id
              end

    "posts/#{post_id}/#{id}.#{attachment.ext}"
  end
end
