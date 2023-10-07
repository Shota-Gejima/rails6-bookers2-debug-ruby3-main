class BooksController < ApplicationController
  
  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @book_comment = BookComment.new
    
    unless ReadCount.where(created_at: Time.zone.now.all_day).find_by(user_id: current_user.id, book_id: @book.id) 
      @read_count = ReadCount.new(user_id: current_user.id, book_id: @book.id)
      @read_count.save
      # current_user.read_counts.create(book_id: @book.id)　※↑２行省略するとこうできる
    end
    
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort_by { |x| x.favorited_users.includes(:favorites).where(created_at: from...to).size }.reverse
    
    
    @book = Book.new
    # @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render :index
      
    end
  end

  def edit
    
    book = Book.find(params[:id])
    unless book.user == current_user
      redirect_to '/books'
    end
    
    
    @book = Book.find(params[:id])
    
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have Updated book successfully."
    else
      render "edit"
    end
  end
    
  def destroy
    
    book = Book.find(params[:id])
    
    book.destroy

    redirect_to '/books'
    
  end

  private

  def book_params

    params.require(:book).permit(:title, :body)
  end
  
    
end
