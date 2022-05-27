class CatAdEntity
  attr_reader :title, :description, :image_url, :id

  def initialize(title:, description:, image_url:, id: nil)
    @title = title
    @description = description
    @image_url = image_url
    @id = id 
  end
end
