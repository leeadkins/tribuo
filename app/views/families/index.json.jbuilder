json.array!(@families) do |family|
  json.extract! family, 
  json.url family_url(family, format: :json)
end
