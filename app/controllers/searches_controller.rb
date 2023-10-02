class SearchesController < ApplicationController
  
  def search
		@range = params[:range]
		@word = params[:word]
		@search = params[:search]
		if @range == 'User'
			@records = User.search_for(@search, @word)
		else
			@records = Book.search_for(@search, @word)
		end
		
  end
  
end
