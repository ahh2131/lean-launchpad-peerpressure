class ChatsController < ApplicationController

  def getChats
    @chats = Chat.where("user_1 = ? or user_2 = ?", current_user.id, current_user.id).where(complete: 0).order("created_at desc").all
    @user = current_user
    @final_chats = []
    @chats.each do |chat|
      final_chat = Hash.new
      final_chat["id"] = chat.id
      if chat.user_1 != current_user.id
        final_chat["name"] = User.find(chat.user_1).name
      else
        final_chat["name"] = User.find(chat.user_2).name
      end
      last_message = Message.where(chat_id: chat.id).order("created_at desc").limit(1).first
      if last_message.nil?
        final_chat["last_message"] = ""
      else
        final_chat["last_message"] = last_message.message
      end
      final_chat["post_id"] = chat.post_id
      final_chat["post_image"] = Post.find(chat.post_id).photo.url(:medium)
      @final_chats.append(final_chat)
    end
    respond_to do |format|
      format.json
    end
  end

  def getMessages
    
  end

  def sendMessage
  
  end

  


end
