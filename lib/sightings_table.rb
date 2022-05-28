require "sighting_entity"

class SightingsTable
  def initialize(db)
    @db = db
  end
  
  def list(cat_ad_id)
    return @db.run("SELECT * FROM sightings WHERE cat_ad_id = $1 ORDER BY id;", 
      [cat_ad_id]).map do |row|
        row_to_object(row)
      end
  end

  def add(sighting)
    result = @db.run(
      "INSERT INTO sightings (location, details, user_id, cat_ad_id, spotted_on, posted_on) 
        VALUES ($1, $2, $3, $4, $5, $6) RETURNING id;", 
        [sighting.location, sighting.details, sighting.user_id, sighting.cat_ad_id, 
          sighting.spotted_on, sighting.posted_on])
    return result[0]["id"]
  end

  def remove(index)
    @db.run("DELETE FROM sightings WHERE id = $1;", [index])
  end

  def update(index:, location:, details:, user_id:, cat_ad_id:, spotted_on:, posted_on:)
    @db.run("UPDATE sightings SET 
      location = $1, 
      details = $2, 
      user_id = $3,
      cat_ad_id = $4,
      spotted_on = $5,
      posted_on = $6 
      WHERE id = $7;", 
      [location, details, user_id, cat_ad_id, spotted_on, posted_on, index])
  end

  def get(index)
    result = @db.run("SELECT * FROM sightings WHERE id = $1;", [index])
    return row_to_object(result[0])
  end

  private

  def row_to_object(row)
    return SightingEntity.new(
      id: row["id"],
      location: row["location"],
      details: row["details"], 
      user_id: row["user_id"], 
      cat_ad_id: row["cat_ad_id"],
      spotted_on: row["spotted_on"], 
      posted_on: row["posted_on"]
    )
  end
end
