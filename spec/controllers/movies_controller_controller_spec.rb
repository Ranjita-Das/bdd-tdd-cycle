require 'spec_helper'

describe MoviesController do

	before :each do
		@bogus_movie = stub('double').as_null_object
		@movie = [mock('movie1')]
	end

	describe 'input movie information' do
		before :each do
			movie_id = 1
			Movie.should_receive(:find).with(movie_id.to_s).and_return(@bogus_movie)
			@bogus_movie.should_receive(:update_attributes!).exactly 1
			put :update, {:id => movie_id, :movie => @movie}
		end
		it 'should call the model method for updating movie' do
			true
		end
		it 'should redirect to details template for rendering' do
			response.should redirect_to(movie_path @bogus_movie)
		end
		it 'should make information that has been updated available to the template' do
			assigns(:movie).should == @bogus_movie
		end
	end

	describe 'find movies that have the same director' do
		before :each do
			@movie_id = 10
			@founded = [mock('a movie'), mock('another')]
			@bogus_movie.stub(:director).and_return('bogus director')
		end
		it 'should render same_director view' do
			Movie.stub(:find).and_return(@bogus_movie)
			Movie.stub(:find_all_by_director).and_return(@founded)

			get :same_director, {:id => @movie_id}
			response.should render_template 'same_director'
		end
		it 'should call Model method to get movies that have the same director' do
			Movie.should_receive(:find).with(@movie_id.to_s).and_return(@bogus_movie)
			Movie.should_receive(:find_all_by_director).and_return(@founded)

			get :same_director, {:id => @movie_id}
		end
		it 'should make movies that are found available to view' do
			Movie.stub(:find).and_return(@bogus_movie)
			Movie.stub(:find_all_by_director).and_return(@founded)

			get :same_director, {:id => @movie_id}

			assigns(:movies).should == @founded
		end
		it 'should return to home page when no movies are found' do
			empty_director =  double('movie', :director => '').as_null_object
			Movie.stub(:find).and_return(empty_director)
			Movie.stub(:find_all_by_director)
			
			get :same_director, {:id => @movie_id}
			response.should redirect_to(movies_path)						
		end
	end

	describe 'creates new movie' do
		it 'renders new-movie template' do
			get :new
			response.should render_template 'new'
		end
		it 'should call a model method to persist data' do
			movie = stub('new movie').as_null_object
			Movie.should_receive(:create!).and_return(movie)

			post :create, {:movie => movie}
		end
		it 'it should render the home template' do
			movie = stub('new movie').as_null_object
			Movie.stub(:create!).and_return(movie)

			post :create, {:movie => movie}
			response.should redirect_to(movies_path)
		end
	end

	describe 'deletes a movie that already exists' do
		it 'should render the edit movie template' do
			Movie.stub(:find)
			get :edit, {:id => 1}
			response.should render_template 'edit'
		end
		it 'should call a model method for updating data' do
			my_movie = mock('a movie').as_null_object
			
			Movie.should_receive(:find).and_return(my_movie)
			my_movie.should_receive(:destroy)

			delete :destroy, {:id => 1}
		end
		
	end

end