class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    redirect =false
      if params[:sorting]
        @sorting = params[:sorting]
        session[:sorting] = params[:sorting]
               case params[:sorting]
                  when'title'
                    @title_header = 'hilite'
                    @release_date_header = nil
                  when'release_date'
                    @release_date_header = 'hilite'
                    @title_header = nil
                  else
                     @title_header = nil
                     @release_date_header = nil
               end
      elsif session[:sorting]
        @sorting = session[:sorting]
        redirect =true
      else
        @sorting = nil
      end
    
      if params[:commit] == "Refresh" and params[:ratings].nil?
          @ratings=nil
          session[:ratings]=nil
          @sorting=nil
          session[:sorting]=nil
        elsif params[:ratings]
          @ratings = params[:ratings]
          session[:ratings] = params[:ratings]
        elsif session[:ratings]
          @ratings = session[:ratings]
          redirect = true
        else
          @ratings = nil
        end

         if redirect
          redirect_to movies_path( :sorting=>@sorting, :ratings=>@ratings)
        end

        if @ratings and @sorting
          @movies = Movie.where(:rating => @ratings.keys).order(@sorting)  
        elsif @ratings
          @movies = Movie.where(:rating => @ratings.keys)
        elsif @sorting
          @movies = Movie.order(@sorting)
        else
          @movies= Movie.all
        end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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

