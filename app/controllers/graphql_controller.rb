class GraphqlController < ApplicationController
  def execute
    context = {}
    if bearer_token
      user = User.find_by(:authentication_token => bearer_token)
      context[:current_user] = user if user
    end

    result = if params[:_json]
      queries = params[:_json].map do |param|
        {
          :query => param[:query],
          :operation_name => param[:operationName],
          :variables => ensure_hash(param[:variables]),
          :context => context
        }
      end
      DayBreakersSchema.multiplex(queries)
    else
      DayBreakersSchema.execute(
        params[:query],
        :operation_name => params[:operationName],
        :variables => ensure_hash(params[:variables]),
        :context => context
      )
    end

    render :json => result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def bearer_token
    pattern = /^Bearer /
    header  = request.headers['Authorization']
    header.gsub(pattern, '') if header && header.match(pattern)
  end
end
