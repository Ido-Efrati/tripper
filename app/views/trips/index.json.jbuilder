json.array!(@trips) do |trip|
  json.extract! trip, :trip_name, :user_id
  json.url trip_url(trip, format: :json)
end
