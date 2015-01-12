json.success @post.errors.nil?
if !@post.errors.nil?
  json.error @post.errors
end
