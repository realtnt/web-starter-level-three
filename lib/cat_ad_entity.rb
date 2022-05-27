class CatAdEntity
  attr_reader :title, :description, :image_url, :user_id, :id

  def initialize(title:, description:, image_url:, user_id:, id: nil)
    @title = title
    @description = description
    @image_url = image_url
    @user_id = user_id
    @id = id 
  end
end
