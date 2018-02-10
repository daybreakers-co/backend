class UpdateTripJob < ApplicationJob
  queue_as :default

  def perform(trip_id)
    Trip.find(trip_id).update_photographic_ids
  end
end
