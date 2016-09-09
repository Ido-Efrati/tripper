json.array!(@costs) do |cost|
  json.extract! cost, :value, :description, :user_id, :trip_id, :exchange_id
  json.url cost_url(cost, format: :json)
end
