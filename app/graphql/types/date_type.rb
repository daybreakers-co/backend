module Types
  DateType = GraphQL::ScalarType.define do
    name "Date"
    description "Date in ISO8601 format"

    coerce_input ->(value, _context)  { Date.parse(URI.unescape(value)).to_date }
    coerce_result ->(value, _context) { value.iso8601 }
  end
end
