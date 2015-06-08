require "sinatra/base"
require "sinatra/reloader"
require_relative 'db/connection'
require_relative 'models/post'
require_relative 'models/user'
require_relative 'models/comment'

module JadenForum
  class Server < Sinatra::Base

    configure do
      register Sinatra::Reloader
      enable :sessions
      also_reload File.expand_path('models/post.rb')
      also_reload File.expand_path('models/user.rb')
      also_reload File.expand_path('models/comment.rb')
    end

    def notice
      "<p id=\"notice\">#{@notice}</p>" if @notice
    end

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id]) if logged_in?
    end

    before do
      unless logged_in? || ['/', '/users/login', '/users'].include?(request.path_info)
        redirect '/'
      end
    end

    get '/' do
      if logged_in?
        redirect '/posts'
      else
        erb :homepage
      end
    end

    post '/users' do
      if params[:user][:password] == params[:user][:retype_password]
        $db.exec_params(<<-SQL, params[:user][:name], params[:user][:email], params[:password])
          INSERT INTO users
            (name, email, password, created_at)
          VALUES
            ($1, $2, $3, CURRENT_TIMESTAMP);
        SQL
        redirect '/posts'
      else
        @notice = "Passwords do not match"
        erb :homepage
      end
    end

    post '/users/login' do
      @user = User.find_by_email(params[:login][:email])
      if @user && @user.password == params[:login][:password]
        session[:user_id] = @user.id
        redirect '/posts'
      else
        @notice = "Invalid Username/Password"
        erb :homepage
      end
    end

    get '/posts' do
      @posts = Post.all
      erb :posts
    end

    post '/posts' do
      @post = Post.create(current_user.id, params[:post])
      redirect "/posts/#{@post.id}"
    end

    get '/posts/:id' do
      @post = Post.find(params[:id])
      erb :post
    end

    get '/posts/:post_id/comments' do
      erb :comments
    end

    get '/posts/:post_id/comments/:id' do
      erb :comment
    end

    post '/posts/:post_id/comments' do |post_id|
      @comment = Comment.create(current_user.id, post_id, params[:comment])
      redirect "/posts/#{@comment.post_id}"
    end

  end
end
