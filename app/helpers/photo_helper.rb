module PhotoHelper
  def photo_cdn_url(path, options={})
    if ActionController::Base.asset_host
      host = ActionController::Base.asset_host % (Zlib.crc32(photo_path(path, options)) % 4)
      photo_url(path, options.merge(:host => host))
    else
      photo_url(path, options)
    end
  end
end
