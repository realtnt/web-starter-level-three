class SightingEntity
  attr_reader :location, :details, :spotted_on, :posted_on
  attr_reader :user_id, :cat_ad_id, :id

  def initialize(
    location:, 
    details:, 
    user_id:, 
    cat_ad_id:,
    spotted_on: nil, 
    posted_on: nil, 
    id: nil
  )
    @location = location
    @details = details
    @spotted_on = spotted_on
    @posted_on = posted_on
    @user_id = user_id
    @cat_ad_id = cat_ad_id
    @id = id
  end
end
