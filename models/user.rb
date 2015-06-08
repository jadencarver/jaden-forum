module JadenForum
  class User
    def self.all
      $db.exec_params("SELECT * FROM users").map { |row| new(row) }
    end

    def self.find(id)
      row = $db.exec_params("SELECT * FROM users WHERE id=$1", [id]).first
      new(row) if row
    end

    def self.find_by_email(email)
      row = $db.exec_params("SELECT * FROM users WHERE email=$1", [email]).first
      new(row) if row
    end

    attr_reader :id, :created_at
    attr_accessor :name, :email, :password

    def initialize(attributes={})
      @id = attributes["id"]
      @name = attributes["name"]
      @email = attributes["email"]
      @password = attributes["password"]
      @created_at = attributes["created_at"]
    end

  end
end
