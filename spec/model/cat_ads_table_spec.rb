require "helpers/database_helpers"
require "cat_ad_entity"
require "cat_ads_table"

RSpec.describe CatAdsTable do
  def clean_and_get_database
    DatabaseHelpers.clear_table("cat_ads")
    return DatabaseHelpers.test_db_connection
  end

  it "start with an empty table" do
    db = clean_and_get_database
    cat_ads_table = CatAdsTable.new(db)
    expect(cat_ads_table.list).to eq([])
  end

  it "adds cat ads and lists them out again" do
    db = clean_and_get_database
    cat_ads_table = CatAdsTable.new(db)
    cat_ads_table.add(CatAdEntity.new(
      title: "Cat Ad Title", 
      description: "Cat Ad Description", 
      image_url: "https://image.url",
      user_id: 5,
      posted_on: "01/01/2022 00:00:00"
    ))

    cat_ads = cat_ads_table.list
    expect(cat_ads.length).to eq 1
    expect(cat_ads[0].title).to eq "Cat Ad Title"
    expect(cat_ads[0].description).to eq "Cat Ad Description"
    expect(cat_ads[0].image_url).to eq "https://image.url"
    expect(cat_ads[0].user_id).to eq "5"
  end

  it "adds cat ads and removes them" do
    db = clean_and_get_database
    cat_ads_table = CatAdsTable.new(db)
    cat_ads_table.add(CatAdEntity.new(
      title: "Cat Ad Title", 
      description: "Cat Ad Description", 
      image_url: "https://image.url",
      user_id: 5,
      posted_on: "01/01/2022 00:00:00"
    ))

    cat_ads = cat_ads_table.list
    expect(cat_ads.length).to eq 1
    expect(cat_ads[0].title).to eq "Cat Ad Title"
    expect(cat_ads[0].description).to eq "Cat Ad Description"
    expect(cat_ads[0].image_url).to eq "https://image.url"
    expect(cat_ads[0].user_id).to eq "5"

    cat_ads_table.remove(cat_ads[0].id)
    cat_ads = cat_ads_table.list
    expect(cat_ads.length).to eq 0
  end

  it "adds cat ads and lists them by user id" do
    db = clean_and_get_database
    cat_ads_table = CatAdsTable.new(db)
    cat_ads_table.add(CatAdEntity.new(
      title: "Cat Ad Title 1", 
      description: "Cat Ad Description 1", 
      image_url: "https://image1.url",
      user_id: 5,
      posted_on: "01/01/2022 00:00:00"
    ))

    cat_ads_table.add(CatAdEntity.new(
      title: "Cat Ad Title 2", 
      description: "Cat Ad Description 2", 
      image_url: "https://image2.url",
      user_id: 1,
      posted_on: "01/01/2022 00:00:00"
    ))

    cat_ads_table.add(CatAdEntity.new(
      title: "Cat Ad Title 3", 
      description: "Cat Ad Description 3", 
      image_url: "https://image3.url",
      user_id: 5,
      posted_on: "01/01/2022 00:00:00"
    ))

    cat_ads = cat_ads_table.list_by_user_id(5)
    expect(cat_ads.length).to eq 2
    expect(cat_ads[0].title).to eq "Cat Ad Title 1"
    expect(cat_ads[1].title).to eq "Cat Ad Title 3"
    expect(cat_ads[0].description).to eq "Cat Ad Description 1"
    expect(cat_ads[1].description).to eq "Cat Ad Description 3"
    expect(cat_ads[0].image_url).to eq "https://image1.url"
    expect(cat_ads[1].image_url).to eq "https://image3.url"

    cat_ads = cat_ads_table.list_by_user_id(1)
    expect(cat_ads.length).to eq 1
    expect(cat_ads[0].title).to eq "Cat Ad Title 2"
    expect(cat_ads[0].description).to eq "Cat Ad Description 2"
    expect(cat_ads[0].image_url).to eq "https://image2.url"
  end
end
