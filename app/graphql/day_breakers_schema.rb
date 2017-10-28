DayBreakersSchema = GraphQL::Schema.define do
  mutation(Types::MutationType)
  query(Types::QueryType)
  use GraphQL::Batch
  use GraphQL::Tracing::AppsignalTracing

  resolve_type ->(type, obj, ctx) do
    "Types::#{obj.class}Type".constantize
  end
end
