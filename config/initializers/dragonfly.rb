require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret Rails.application.secrets.secret_key_base
  url_format "/media/:job/:name"

  if Rails.env.production?
    datastore :s3,
      :bucket_name => Rails.application.secrets.aws_bucket,
      :access_key_id => Rails.application.secrets.aws_access_key_id,
      :secret_access_key => Rails.application.secrets.aws_secret_access_key,
      :region => Rails.application.secrets.aws_region,
      :root_path => Rails.env,
      :storage_headers => { "x-amz-acl" => "private" }
  else
    datastore :file,
      :root_path => Rails.root.join('public/system/dragonfly', Rails.env),
      :server_root => Rails.root.join('public')
  end
end

# Logger
Dragonfly.logger = Rails.logger
