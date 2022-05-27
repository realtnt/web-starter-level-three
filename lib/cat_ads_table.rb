require "cat_ad_entity"

class CatAdsTable
  def initialize(db)
    @db = db
  end

  def list
    return @db.run("SELECT * FROM cat_ads ORDER BY id;").map do |row|
      row_to_object(row)
    end
  end

  def add(cat_ad)
    result = @db.run(
      "INSERT INTO cat_ads (title, description, image_url) VALUES ($1, $2, $3) RETURNING id;", 
      [cat_ad.title, cat_ad.description, cat_ad.image_url]
    )
    return result[0]["id"]
  end

  def remove(index)
    @db.run("DELETE FROM cat_ads WHERE id = $1;", [index])
  end

  def update(index:, title:, description:, image_url:)
    @db.run("UPDATE cat_ads SET title = $1, description = $2, image_url = $3 WHERE id = $4;", 
      [title, description, image_url, index])
  end

  def get(index)
    result = @db.run("SELECT * FROM cat_ads WHERE id = $1;", [index])
    return row_to_object(result[0])
  end

  private

  def row_to_object(row)
    return CatAdEntity.new(
      id: row["id"],
      title: row["title"],
      description: row["description"],
      image_url: row["image_url"],
    )
  end
end
