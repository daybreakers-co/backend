module Dateable
  extend ActiveSupport::Concern
  included do
    field :start_date, :type => Date, :default => -> { Date.today }
    field :end_date,   :type => Date, :default => -> { Date.today }
  end
end
