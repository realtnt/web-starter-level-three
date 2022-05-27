class UserEntity
  attr_reader :email, :name, :password, :mobile, :advertiser, :id

  def initialize(
    email:, 
    name:, 
    password:, 
    mobile:, 
    advertiser:, 
    id: nil
  )
    @email = email
    @name = name
    @password = password
    @mobile = mobile
    @advertiser = advertiser
    @id = id
  end
end
