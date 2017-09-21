class Section
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sortable

  embedded_in :post

  def ensure_index
    write_attribute(:index, post.sections.length - 1)
  end
end
