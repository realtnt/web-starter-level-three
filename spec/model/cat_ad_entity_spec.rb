require 'cat_ad_entity'

RSpec.describe CatAdEntity do
  it "constructs without an ID" do
    cat_ad = CatAdEntity.new(
      title: "Cat",
      description: "Blah Blah",
      image_url: "http://image.url",
    )
    expect(cat_ad.title).to eq "Cat"
    expect(cat_ad.description).to eq "Blah Blah"
    expect(cat_ad.image_url).to eq "http://image.url"
  end

  it "constructs with an ID" do
    cat_ad = CatAdEntity.new(
      title: "Cat",
      description: "Blah Blah",
      image_url: "http://image.url",
      id: 5
    )
    expect(cat_ad.title).to eq "Cat"
    expect(cat_ad.description).to eq "Blah Blah"
    expect(cat_ad.image_url).to eq "http://image.url"
    expect(cat_ad.id).to eq 5
  end
end
