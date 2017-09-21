module Types
  DateTimeType = GraphQL::ScalarType.define do
    name "DateTime"
    description "UTC DateTime in ISO8601 format"

    coerce_input ->(value, _context) { Time.parse(URI.unescape(value)).utc }
    coerce_result ->(value, _context) { value.utc.iso8601 }
  end
end
