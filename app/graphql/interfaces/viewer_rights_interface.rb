module Interfaces
  ViewerRightsInterface = GraphQL::InterfaceType.define do
    name "ViewerRights"

    camelized_field :viewer_can_edit, !types.Boolean do
      resolve ->(obj, _, ctx) { obj.user == ctx[:user] }
    end
  end
end
