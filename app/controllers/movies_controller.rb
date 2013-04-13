class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort]	
    ratings  = params[:ratings]
     
    @all_ratings = Movie.new.ratings   
    
    if ratings
	session[:ratings] = ratings
    end
    session_ratings = session[:ratings]
    @ratings = Hash.new
    @all_ratings.each do |rating|
      if session_ratings
	if session_ratings.has_key? rating
          @ratings[rating]= true
        else
          @ratings[rating] = false
        end
	else
	  @ratings[rating]= true
      end
    end
    
     if sort
	     if sort == "release_date"
		@movies = Movie.order(sort).find_all_by_rating(@ratings.select {|k,v| v == true}.keys)
		@release_date = "hilite"
	     end
	     if sort == "title"
		@movies = Movie.order(sort).find_all_by_rating(@ratings.select {|k,v| v == true}.keys)
		@title = "hilite"
	     end
     else
		@movies = Movie.find_all_by_rating(@ratings.select {|k,v| v == true}.keys)
     end
     
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
