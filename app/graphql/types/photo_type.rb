Types::PhotoType = GraphQL::ObjectType.define do
  name "Photo"

  field :id,     !types.String
  field :width,  !types.String, :property => :image_width
  field :height, !types.String, :property => :image_height
  field :ratio,  !types.Float,  :property => :ratio

  field :url,    !types.String do
    resolve ->(obj, args, ctx) { photo_cdn_url(obj.id, :format => "jpg").to_s }
  end
end
