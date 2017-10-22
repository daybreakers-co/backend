module Interfaces
  DateableInterface = GraphQL::InterfaceType.define do
    name "Dateable"

    camelized_field :start_date, !Types::DateType
    camelized_field :end_date,   !Types::DateType
  end
end
