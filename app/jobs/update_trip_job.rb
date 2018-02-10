class UpdateTripJob < ApplicationJob
  queue_as :default

  def perform(trip_id)
    Trip.find(trip_id).update_counts_and_photos
  end
end
