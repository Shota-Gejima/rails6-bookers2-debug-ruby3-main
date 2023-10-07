class FavoritesController < ApplicationController
    
  # before_action :favorite_sort, only: [:update, :destroy]
    
  def create
     
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    
    favorite_sort
    
  end
        
    
  def destroy
    
    @book = Book.find(params[:book_id])
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    
    favorite_sort
      
  end
  
  private
  
  def favorite_sort
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
    sort_by { |x| x.favorited_users.includes(:favorites).where(created_at: from...to).size }.reverse
  end

end
