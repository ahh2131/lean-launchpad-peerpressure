json.posts @posts.each do |post|
  json.id post.id
  json.name post.name
  json.description post.description
  json.price post.price
  json.user_id post.user_id
  json.sold post.sold
  json.photo post.photo.url(:medium)
end
