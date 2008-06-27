class SearchesController < ApplicationController
  def show
    @search = Search.find(params[:id])
    @books = @search.books
    @authors = @search.authors
  end
  
  def create
    @search = Search.find_or_create_by_keywords(params[:search][:keywords])
    redirect_to @search
  end
end