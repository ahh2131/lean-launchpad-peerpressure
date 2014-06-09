json.array!(@activities) do |activity|
  json.extract! activity, :id, :fromUser, :toUser, :type, :product
  json.url activity_url(activity, format: :json)
end
