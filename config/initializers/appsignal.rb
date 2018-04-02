class UsageProbe
  def call
    Appsignal.set_gauge("users", User.count)
    Appsignal.set_gauge("posts", Post.count)
    Appsignal.set_gauge("photos", Photo.count)
    Appsignal.set_gauge("trips", Trip.count)
  end
end

Appsignal::Minutely.probes << UsageProbe.new
