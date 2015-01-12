json.chats @final_chats.each do |chat|
  json.chat_id chat["id"]
  json.name chat["name"]
  json.last_message chat["last_message"]
  json.post_id chat["post_id"]
  json.post_image chat["post_image"]
end
