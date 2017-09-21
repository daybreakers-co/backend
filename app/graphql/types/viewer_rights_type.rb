Types::ViewerRightsType = GraphQL::InterfaceType.define do
  name "ViewerRights"

  camelized_field :viewer_can_edit, !types.Bool do
    resolve ->(obj, args, ctx) { obj.user == ctx[:user] }
  end
end
