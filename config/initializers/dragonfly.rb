require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "64872d22eed459d23333a87b0775251da1107ea3f49aaa9a69540163ce78dafc"
  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger
