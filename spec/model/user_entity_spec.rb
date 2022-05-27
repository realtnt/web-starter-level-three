require 'user_entity'

RSpec.describe UserEntity do
  it "constructs without an ID" do
    user = UserEntity.new(
      email: "user1@mail.com",
      name: "User Name",
      password: "password",
      mobile: "07800000001",
      advertiser: false
    )
    expect(user.email).to eq "user1@mail.com"
    expect(user.name).to eq "User Name"
    expect(user.password).to eq "password"
    expect(user.mobile).to eq "07800000001"
    expect(user.advertiser).to eq false
  end

  it "constructs with an ID" do
    user = UserEntity.new(
      email: "user1@mail.com",
      name: "User Name",
      password: "password",
      mobile: "07800000001",
      advertiser: false,
      id: 11
    )
    expect(user.email).to eq "user1@mail.com"
    expect(user.name).to eq "User Name"
    expect(user.password).to eq "password"
    expect(user.mobile).to eq "07800000001"
    expect(user.advertiser).to eq false
    expect(user.id).to eq 11
  end
end
