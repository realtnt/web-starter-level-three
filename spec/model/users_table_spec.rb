require "helpers/database_helpers"
require "user_entity"
require "users_table"

RSpec.describe UsersTable do
  def clean_and_get_database
    DatabaseHelpers.clear_table("users")
    return DatabaseHelpers.test_db_connection
  end

  it "start with an empty table" do
    db = clean_and_get_database
    users_table = UsersTable.new(db)
    expect(users_table.list).to eq([])
  end

  it "adds users and lists them out again" do
    db = clean_and_get_database
    users_table = UsersTable.new(db)
    users_table.add(UserEntity.new(
      email: "user1@mail.com",
      name: "User Name",
      password: "password",
      mobile: "07800000001",
      advertiser: false
    ))

    users = users_table.list
    expect(users.length).to eq 1
    expect(users[0].email).to eq "user1@mail.com"
    expect(users[0].name).to eq "User Name"
    expect(users[0].password).to eq "password"
    expect(users[0].mobile).to eq "07800000001"
    expect(users[0].advertiser).to eq "f" # false
  end
end
