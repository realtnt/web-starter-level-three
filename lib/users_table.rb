require "user_entity"

class UsersTable
  def initialize(db)
    @db = db
  end
  
  def find_by(email:, password:) 
    result = @db.run("SELECT * FROM users WHERE email = $1 AND password = $2;", [email, password])
    return nil if result.to_a.empty?
    return row_to_object(result[0])
  end

  def list
    return @db.run("SELECT * FROM users ORDER BY id;").map do |row|
      row_to_object(row)
    end
  end

  def add(user)
    result = @db.run(
      "INSERT INTO users (email, name, password, mobile, advertiser) 
        VALUES ($1, $2, $3, $4, $5) RETURNING id;", 
        [user.email, user.name, user.password, user.mobile, user.advertiser])
    return result[0]["id"]
  end

  def remove(index)
    @db.run("DELETE FROM users WHERE id = $1;", [index])
  end

  def update(index:, email:, name:, password:, mobile:, advertiser:)
    @db.run("UPDATE users 
      SET email = $1, name = $2, password = $3, mobile = $4, advertiser = $5
      WHERE id = $6;", 
      [email, name, password, mobile, advertiser, index])
  end

  def get(index)
    result = @db.run("SELECT * FROM users WHERE id = $1;", [index])
    return row_to_object(result[0])
  end

  private

  def row_to_object(row)
    return UserEntity.new(
      id: row["id"],
      email: row["email"],
      name: row["name"],
      password: row["password"],
      mobile: row["mobile"],
      advertiser: row["advertiser"],
    )
  end
end
