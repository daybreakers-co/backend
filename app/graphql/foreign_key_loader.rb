class ForeignKeyLoader < GraphQL::Batch::Loader
  def initialize(model, foreign_key)
    @model = model
    @foreign_key = foreign_key
  end

  def perform(foreign_value_sets)
    # Generate a flat array of all the id's we have to request and make a request
    foreign_values = foreign_value_sets.flatten.uniq
    records = @model.where(@foreign_key.in => foreign_values).to_a

    foreign_value_sets.each do |foreign_value_set|
      # If the input set is an array, return an array
      match = if foreign_value_set.is_a?(Array)
        records.select { |r| foreign_value_set.include?(r.send(@foreign_key)) }

      # If the input set is a single record, return a single record
      else
        records.find { |r| foreign_value_set == r.send(@foreign_key) }
      end

      fulfill(foreign_value_set, match)
    end
  end
end
