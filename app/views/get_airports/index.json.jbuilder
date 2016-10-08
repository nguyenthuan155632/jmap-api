json.array!(@get_airports) do |get_airport|
  json.extract! get_airport, :id
  json.url get_airport_url(get_airport, format: :json)
end
