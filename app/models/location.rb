class Location
  include Mongoid::Document

  field :title
  field :lat, :type => Float
  field :lng, :type => Float

  embedded_in :post
end
