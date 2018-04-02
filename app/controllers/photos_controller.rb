class PhotosController < ApplicationController
  include PhotoHelper

  def create
    unless bearer_token
      head :authentication_required
      return
    end
    user = User.find_by(:authentication_token => bearer_token)

    unless user
      head :unauthorized
      return
    end

    photo = case params[:parentType]
      when 'PhotoRowSectionItem'
        user
          .posts
          .find_by('sections.items._id' => BSON::ObjectId.from_string(params[:parentId]))
          .sections
          .find_by('items._id' => BSON::ObjectId.from_string(params[:parentId]))
          .items
          .find_by('_id' => BSON::ObjectId.from_string(params[:parentId]))
          .create_photo(photo_params)
        when 'HeroSection'
        user
          .posts
          .find_by('sections._id' => BSON::ObjectId.from_string(params[:parentId]))
          .sections
          .find(params[:parentId])
          .create_photo(photo_params)
      when 'Post'
        user
          .posts
          .find(params[:parentId])
          .create_header(photo_params)
      else
        raise ArgumentError("Could not create photo for type #{args[:parentType]} and id: #{args[:parentId]}")
    end

    Appsignal.increment_counter("photo_created", 1)

    render :json => {
      :id     => photo.id.to_s,
      :url    => photo_cdn_url(photo),
      :width  => photo.image_width,
      :height => photo.image_height,
      :ratio  => photo.ratio
    }
  end

  def show
    image = Photo.find(params[:id]).image
    if params[:w] && params[:h]
      image = image.thumb("#{params[:w]}x#{params[:h]}").apply
    elsif params[:w] || params[:h]
      image = image.thumb("#{params[:w]}x#{params[:h]}").apply
    end

    response.set_header("ETag", %("#{image.try(:signature) || image.send(:uid)}"))
    expires_in 1.year, :public => true

    send_data image.data, type: 'image/jpeg', disposition: 'inline'
  end

  private

  def photo_params
    params.permit(:image)
  end
end
