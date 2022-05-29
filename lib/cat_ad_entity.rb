class CatAdEntity
  attr_reader :title, :description, :image_url, :user_id, :posted_on, :id

  def initialize(title:, description:, image_url:, user_id:, posted_on:, id: nil)
    @title = title
    @description = description
    @image_url = image_url
    @user_id = user_id
    @posted_on = posted_on
    @id = id 
  end
end
