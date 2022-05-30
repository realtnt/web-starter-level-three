require "campaign_entity"

class CampaignsTable
  def initialize(db)
    @db = db
  end
  
  def list
    return @db.run("SELECT * FROM campaigns ORDER BY id;").map do |row|
      row_to_object(row)
    end
  end

  def add(campaign)
    result = @db.run(
      "INSERT INTO campaigns (title, copy, image_url, user_id) 
        VALUES ($1, $2, $3, $4) RETURNING id;", 
        [campaign.title, campaign.copy, campaign.image_url, campaign.user_id])
    return result[0]["id"]
  end

  def remove(index)
    @db.run("DELETE FROM campaigns WHERE id = $1;", [index])
  end

  def update(index:, title:, copy:, image_url:, user_id:)
    @db.run("UPDATE campaigns SET 
      title = $1, 
      copy = $2, 
      image_url = $3,
      user_id = $4
      WHERE id = $5;", 
      [title, copy, image_url, user_id, index])
  end

  def get(index)
    result = @db.run("SELECT * FROM campaigns WHERE id = $1;", [index])
    return row_to_object(result[0])
  end

  private

  def row_to_object(row)
    return CampaignEntity.new(
      id: row["id"],
      title: row["title"],
      copy: row["copy"], 
      image_url: row["image_url"],
      user_id: row["user_id"], 
    )
  end
end
