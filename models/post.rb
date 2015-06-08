require_relative "user"
require_relative "comment"

module JadenForum
  class Post

    def self.all
      $db.exec("SELECT * FROM posts").map { |row| new(row) }
    end

    def self.find(id)
      new($db.exec_params("SELECT * FROM posts WHERE id=$1", [id]).first)
    end

    def self.create(user_id, params)
      row = $db.exec_params(<<-SQL, [user_id, params[:title], params[:post]]).first
        INSERT INTO posts
          (user_id, title, post, created_at)
        VALUES
          ($1, $2, $3, CURRENT_TIMESTAMP)
        RETURNING *;
      SQL
      new(row)
    end

    attr_reader :id, :created_at
    attr_accessor :title, :post

    def initialize(attributes={})
      @id = attributes["id"]
      @title = attributes["title"]
      @post = attributes["post"]
      @user_id = attributes["user_id"]
      @created_at = attributes["created_at"]
    end

    def user
      User.find(@user_id)
    end

    def comments
      Comment.where("post_id = $1", [@id])
    end

  end
end
