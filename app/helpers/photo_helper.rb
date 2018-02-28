module PhotoHelper
  def photo_cdn_url(obj, options={})
    if ActionController::Base.asset_host
      [ActionController::Base.asset_host, Rails.env, obj.image_uid].join("/")
    else
      photo_url(obj.id, :format => File.extname(obj.image_uid).delete("."))
    end
  end
end
