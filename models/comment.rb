require_relative 'post'
require_relative 'user'

module JadenForum
  class Comment

    def self.where(query, params=[])
      $db.exec_params("SELECT * FROM comments WHERE #{query}", params).map { |row| new(row) }
    end

    def self.all
      $db.exec_params("SELECT * FROM comments").map { |row| new(row) }
    end

    def self.create(user_id, post_id, params)
      row = $db.exec_params(<<-SQL, [post_id, user_id, params[:comment]]).first
        INSERT INTO comments
          (post_id, user_id, comment, created_at)
        VALUES
          ($1, $2, $3, CURRENT_TIMESTAMP)
        RETURNING *;
      SQL
      new(row)
    end

    attr_reader :id, :created_at, :user_id, :post_id
    attr_accessor :comment

    def initialize(attributes={})
      @id = attributes["id"]
      @post_id = attributes["post_id"]
      @user_id = attributes["user_id"]
      @comment = attributes["comment"]
      @created_at = attributes["created_at"]
    end

    def user
      User.find(@user_id)
    end

    def post
      Post.find(@post_id)
    end

  end
end
