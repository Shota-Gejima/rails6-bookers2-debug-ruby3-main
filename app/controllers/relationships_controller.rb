class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:user_id])
    follow = current_user.active_relationships.build(followed_id: user.id)
    follow.save!
    
    redirect_to request.referer
  end
  def destroy
    follow = current_user.active_relationships.find_by(followed_id: params[:user_id])
    follow.destroy
    redirect_to request.referer
  end
end
