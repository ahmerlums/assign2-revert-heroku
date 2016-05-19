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
    @ratings = params[:ratings]
    
    if params[:sort_param] == 'title'
      @title_header = 'hilite'
    end
    if params[:sort_param] == 'release_date'
      @release_header = 'hilite'
    end
    
    if @ratings.nil?
      @movies = Movie.order(params[:sort_param])
    else
      
      @movies = Movie.where ["rating in (?)", @ratings.keys]
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


  def updatemymovie
    myTitle = params[:movie][:title]
    mymovie= Movie.find_by_title(myTitle)
    if (Movie.find_by_title(myTitle).nil?)
      flash[:notice] = "The movie : #{myTitle} does not exist in the database"
    else
      mydate =  Date.new params[:movie]["release_date(1i)"].to_i, params[:movie]["release_date(2i)"].to_i, params[:movie]["release_date(3i)"].to_i
      mytitle = params[:movie][:newtitle]
      myrating = params[:movie][:rating]
      if (mytitle == "" )
        mytitle = mymovie.title
      elsif (myrating == "N/A")
        myrating = mymovie.rating
      end
      
        mymovie.update_attribute(:title,mytitle)
        mymovie.update_attribute(:rating,myrating)
        mymovie.update_attribute(:release_date,mydate)
      
    end
    redirect_to movies_path
  end
  
  def deletemymovie
    
    myTitle = params[:movie][:title]
    mymovie = Movie.find_by_title(myTitle)
    myrating = params[:movie][:rating]
    if (not (mymovie.nil?) or  myrating!="N/A")
     if (myrating=="N/A"  )
       
        mymovie.destroy
     else
        mymovie = Movie.find_by_rating(myrating)
    while(not(myrating == "N/A" or mymovie.nil?))
        mymovie.destroy
        mymovie = Movie.find_by_rating(mymovie)
    end
    end
    
    else
      flash[:notice] = "The movie : #{myTitle} does not exist in the database"

    end
      
  
    

    redirect_to movies_path
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
end
