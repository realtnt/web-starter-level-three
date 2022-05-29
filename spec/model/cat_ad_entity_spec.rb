require 'cat_ad_entity'

RSpec.describe CatAdEntity do
  it "constructs without an ID" do
    cat_ad = CatAdEntity.new(
      title: "Cat",
      description: "Blah Blah",
      image_url: "http://image.url",
      user_id: 3,
      posted_on: "01/01/2022 00:00:00"
    )
    expect(cat_ad.title).to eq "Cat"
    expect(cat_ad.description).to eq "Blah Blah"
    expect(cat_ad.image_url).to eq "http://image.url"
    expect(cat_ad.user_id).to eq 3
    expect(cat_ad.posted_on).to eq "01/01/2022 00:00:00"
  end

  it "constructs with an ID" do
    cat_ad = CatAdEntity.new(
      title: "Cat",
      description: "Blah Blah",
      image_url: "http://image.url",
      user_id: 3,
      id: 5,
      posted_on: "01/01/2022 00:00:00"
    )
    expect(cat_ad.title).to eq "Cat"
    expect(cat_ad.description).to eq "Blah Blah"
    expect(cat_ad.image_url).to eq "http://image.url"
    expect(cat_ad.user_id).to eq 3
    expect(cat_ad.id).to eq 5
    expect(cat_ad.posted_on).to eq "01/01/2022 00:00:00"
  end
end
