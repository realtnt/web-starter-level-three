$:.unshift File.join(File.dirname(__FILE__), 'lib')
require "database_connection"

# This file sets up the database tables. If you change any of the contents
# of this file, you should rerun `ruby reset_tables.rb` to ensure that your
# database tables are re-created.

def reset_tables(db)
  db.run("DROP TABLE IF EXISTS sightings CASCADE;")
  db.run("CREATE TABLE sightings (
    id SERIAL PRIMARY KEY,
    user_id INT,
    cat_ad_id INT, 
    location TEXT NOT NULL,
    details TEXT NOT NULL,
    spotted_on DATE NOT NULL,
    posted_on TIMESTAMP NOT NULL,
    CONSTRAINT fk_user
      FOREIGN KEY(user_id) 
        REFERENCES users(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_cat_ad
      FOREIGN KEY(cat_ad_id) 
        REFERENCES cat_ads(id)
        ON DELETE CASCADE
    );"
  )

  db.run("DROP TABLE IF EXISTS cat_ads CASCADE;")
  db.run("CREATE TABLE cat_ads (
    id SERIAL PRIMARY KEY, 
    user_id INT,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    image_url TEXT,
    CONSTRAINT fk_user
      FOREIGN KEY(user_id) 
        REFERENCES users(id)
        ON DELETE CASCADE
    );"
  )
  db.run("DROP TABLE IF EXISTS users CASCADE;")
  db.run("CREATE TABLE users (
    id SERIAL PRIMARY KEY, 
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    name TEXT NOT NULL,
    mobile TEXT NOT NULL,
    advertiser BOOLEAN
    );"
  )

  # Add your table creation SQL here
  # Each one should be a pair of lines:
  #   db.run("DROP TABLE IF EXISTS ...;")
  #   db.run("CREATE TABLE ... (id SERIAL PRIMARY KEY, ...);")
end

dev_db = DatabaseConnection.new("localhost", "web_application_dev")
reset_tables(dev_db)

test_db = DatabaseConnection.new("localhost", "web_application_test")
reset_tables(test_db)
