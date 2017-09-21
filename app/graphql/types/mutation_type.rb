Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  camelized_field :create_user, Types::ViewerType do
    argument :username, !types.String
    argument :email,    !types.String
    argument :password, !types.String
    argument :name,     !types.String

    resolve ->(obj, args, ctx) do
      User.create(
        :name     => args[:name],
        :username => args[:username],
        :email    => args[:email],
        :password => args[:password]
      )
    end
  end

  camelized_field :signin_user, Types::ViewerType do
    argument :email,    !types.String
    argument :password, !types.String

    resolve ->(obj, args, ctx) do
      user = User.find_by(:email => args[:email])
      raise 'Not authenticated' unless user.valid_password?(args[:password])
      user
    end
  end

  camelized_field :create_trip, Types::TripType do
    argument :title,    types.String
    argument :subtitle, types.String

    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].trips.create(
        :title    => args[:title],
        :subtitle => args[:subtitle]
      )
    end
  end

  camelized_field :update_trip, Types::TripType do
    argument :id,      !types.String
    argument :title,    types.String
    argument :subtitle, types.String

    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].trips.find(args[:id]).tap do |trip|
        trip.update_attributes!(
          :title    => args[:title],
          :subtitle => args[:subtitle]
        )
      end
    end
  end

  camelized_field :delete_trip, Types::TripType do
    argument :id, !types.String

    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].trips.find(args[:id]).tap(&:destroy)
    end
  end

  camelized_field :create_post, Types::PostType do
    argument :title,    types.String
    argument :subtitle, types.String

    camelized_argument :trip_id, !types.String

    resolve_with_user ->(obj, args, ctx) do
      trip = ctx[:current_user].trips.find(args[:trip_id])
      trip.posts.create(
        :title    => args[:title],
        :subtitle => args[:subtitle],
        :user     => ctx[:current_user]
      )
    end
  end

  camelized_field :update_post, Types::PostType do
    argument :id,      !types.String
    argument :title,    types.String
    argument :subtitle, types.String

    argument :published, types.Boolean

    camelized_argument :publish_date, Types::DateType

    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].posts.find(args[:id]).tap do |post|
        post.update_attributes!(
          :title        => args[:title],
          :subtitle     => args[:subtitle],
          :publish_date => args[:publish_date],
          :published    => args[:published] == true
        )
      end
    end
  end

  camelized_field :delete_post, Types::PostType do
    argument :id, !types.String

    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].posts.find(args[:id]).tap(&:destroy)
    end
  end

  camelized_field :create_location, Types::LocationType do
    camelized_argument :post_id, !types.String
    argument :title,             !types.String

    argument :lat, !types.Float
    argument :lng, !types.Float

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find(args[:post_id])
      post.locations.create(
        :title => args[:title],
        :lat => args[:lat],
        :lng => args[:lng]
      )
    end
  end

  camelized_field :delete_location, Types::LocationType do
    camelized_argument :post_id, !types.String
    argument :id,                !types.String

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find(args[:post_id])
      post.locations.find(args[:id]).tap(&:destroy)
    end
  end

  camelized_field :create_empty_section, Types::SectionUnion do
    camelized_argument :post_id, !types.String
    argument :type, !Types::SectionEnum

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find(args[:post_id])
      section = case args[:type]
        when "TEXT"     then Section::TextSection
        when "PHOTOROW" then Section::PhotoRowSection
        when "HERO"     then Section::HeroSection
      end
      section.new(:post => post).tap(&:save!)
    end
  end

  camelized_field :create_text_section, Types::Section::TextSectionType do
    camelized_argument :post_id, types.String

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find(args[:post_id])
      Section::TextSection.new(:post => post, :title => args[:title], :body => args[:body]).tap(&:save!)
    end
  end

  camelized_field :update_text_section, Types::Section::TextSectionType do
    argument :id,    types.String
    argument :title, types.String
    argument :body,  types.String

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find_by("sections._id" => BSON::ObjectId.from_string(args[:id]))
      post.sections.find(args[:id]).tap do |section|
        section.update_attributes(:title => args[:title], :body => args[:body])
      end
    end
  end

  camelized_field :update_section, Types::SectionUnion do
    argument :id,   !types.String
    argument :index, types.Int

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find_by("sections._id" => BSON::ObjectId.from_string(args[:id]))
      post.sections.find(args[:id]).tap do |section|
        section.update_attributes(:index => args[:index])
      end
    end
  end

  camelized_field :delete_section, Types::SectionUnion do
    argument :id, !types.String

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find_by('sections._id' => BSON::ObjectId.from_string(args[:id]))
      post.sections.find(args[:id]).tap(&:destroy)
    end
  end

  camelized_field :create_photo_row_section, Types::Section::PhotoRowSectionType do
    camelized_argument :post_id, types.String

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find(args[:post_id])
      Section::PhotoRowSection.new(:post => post).tap(&:save!)
    end
  end

  camelized_field :delete_photo_row_photo, Types::PhotoType do
    argument :id, !types.String

    resolve_with_user ->(obj, args, ctx) do
      ctx[:current_user].photos.find(args[:id]).tap(&:destroy)
    end
  end

  camelized_field :create_photo_row_section_item, Types::Section::PhotoRowSectionItemType do
    camelized_argument :section_id, types.String

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find_by('sections._id' => BSON::ObjectId.from_string(args[:section_id]))
      section = post.sections.find(args[:section_id])
      Section::PhotoRowSectionItem.new(:photo_row_section => section).tap(&:save!)
    end
  end

  camelized_field :delete_photo_row_section_item, Types::PhotoType do
    argument :id, !types.String

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find_by('sections.items._id' => BSON::ObjectId.from_string(args[:id]))
      post.sections.find { |section| section.items.find { |item| item.id == args[:id] } }.tap(&:destroy!)
    end
  end

  camelized_field :update_photo_row_section_item_index, Types::SectionUnion do
    argument :id,   !types.String
    argument :index, types.Int

    resolve_with_user ->(obj, args, ctx) do
      post = ctx[:current_user].posts.find_by('sections.items._id' => BSON::ObjectId.from_string(args[:id]))
      post.sections.find { |section| section.items.find { |item| item.id == args[:id] } }.tap do |item|
        item.update_attributes!(:index => args[:index])
      end
    end
  end
end
