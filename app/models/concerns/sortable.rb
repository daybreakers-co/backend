module Sortable
  extend ActiveSupport::Concern
  included do
    field :index, :type => Integer, :default => 0

    before_create :ensure_index
  end
end
