$:.unshift File.join(File.dirname(__FILE__), 'lib')
require "database_connection"

# This file sets up the database tables. If you change any of the contents
# of this file, you should rerun `ruby reset_tables.rb` to ensure that your
# database tables are re-created.

def reset_tables(db)

  db.run("DROP TABLE IF EXISTS campaigns CASCADE;")
  db.run("CREATE TABLE campaigns (
    id SERIAL PRIMARY KEY,
    user_id INT,
    title TEXT NOT NULL,
    copy TEXT,
    image_url text,
    CONSTRAINT fk_user
      FOREIGN KEY(user_id) 
        REFERENCES users(id)
        ON DELETE CASCADE
    );"
  )

  db.run("DROP TABLE IF EXISTS keywords CASCADE;")
  db.run("CREATE TABLE keywords (
    id SERIAL PRIMARY KEY, 
    keyword TEXT NOT NULL
    );"
  )

  db.run("DROP TABLE IF EXISTS area_codes CASCADE;")
  db.run("CREATE TABLE area_codes (
    id SERIAL PRIMARY KEY, 
    code TEXT NOT NULL
    );"
  )

  db.run("DROP TABLE IF EXISTS campaign_keywords CASCADE;")
  db.run("CREATE TABLE campaign_keywords (
    keyword_id INT, 
    campaign_id INT,
    CONSTRAINT fk_keyword
      FOREIGN KEY(keyword_id) 
        REFERENCES keywords(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_campaign
      FOREIGN KEY(campaign_id) 
        REFERENCES campaigns(id)
        ON DELETE CASCADE
    );"
  )

  db.run("DROP TABLE IF EXISTS campaign_area_codes CASCADE;")
  db.run("CREATE TABLE campaign_area_codes (
    area_code_id INT, 
    campaign_id INT,
    CONSTRAINT fk_area_code
      FOREIGN KEY(area_code_id) 
        REFERENCES area_codes(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_campaign
      FOREIGN KEY(campaign_id) 
        REFERENCES campaigns(id)
        ON DELETE CASCADE
    );"
  )

  db.run("DROP TABLE IF EXISTS keywords CASCADE;")
  db.run("CREATE TABLE keywords (
    id SERIAL PRIMARY KEY, 
    keyword TEXT NOT NULL
    );"
  )

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
    posted_on TIMESTAMP NOT NULL,
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
end

dev_db = DatabaseConnection.new("localhost", "web_application_dev")
reset_tables(dev_db)

test_db = DatabaseConnection.new("localhost", "web_application_test")
reset_tables(test_db)
