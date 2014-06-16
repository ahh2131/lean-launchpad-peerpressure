json.array!(@test_modules) do |test_module|
  json.extract! test_module, :id
  json.url test_module_url(test_module, format: :json)
end
