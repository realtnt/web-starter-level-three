class CampaignEntity
  attr_reader :title, :copy, :image_url, :user_id, :id;

  def initialize(title:, copy:, image_url:, user_id:, id: nil)
    @title = title
    @copy = copy
    @image_url = image_url
    @user_id = user_id
    @id = id
  end
end
