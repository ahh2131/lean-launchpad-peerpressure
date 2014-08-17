json.success 1
json.lists @lists.each do |list|
	json.id list.id
	json.name list.title
end