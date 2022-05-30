require "helpers/database_helpers"
require "campaign_entity"
require "campaigns_table"

RSpec.describe CampaignsTable do
  def clean_and_get_database
    DatabaseHelpers.clear_table("campaigns")
    return DatabaseHelpers.test_db_connection
  end

  it "start with an empty table" do
    db = clean_and_get_database
    campaigns_table = CampaignsTable.new(db)
    expect(campaigns_table.list).to eq([])
  end

  it "adds campaigns and lists them out again" do
    db = clean_and_get_database
    campaigns_table = CampaignsTable.new(db)
    campaigns_table.add(CampaignEntity.new(
      title: "universe",
      copy: "lost", 
      image_url: "https://image.url",
      user_id: 2
    ))

    campaigns = campaigns_table.list
    expect(campaigns.length).to eq 1
    expect(campaigns[0].title).to eq "universe"
    expect(campaigns[0].copy).to eq "lost"
    expect(campaigns[0].image_url).to eq "https://image.url"
    expect(campaigns[0].user_id).to eq "2"
  end

  it "adds campaigns and removes them" do
    db = clean_and_get_database
    campaigns_table = CampaignsTable.new(db)
    campaigns_table.add(CampaignEntity.new(
      title: "universe",
      copy: "lost", 
      image_url: "https://image.url",
      user_id: 2
    ))

    campaigns = campaigns_table.list
    expect(campaigns.length).to eq 1
    expect(campaigns[0].title).to eq "universe"
    expect(campaigns[0].copy).to eq "lost"
    expect(campaigns[0].image_url).to eq "https://image.url"
    expect(campaigns[0].user_id).to eq "2"

    campaigns_table.remove(campaigns[0].id)
    campaigns = campaigns_table.list
    expect(campaigns.length).to eq 0
  end

  it "adds campaign and gets it" do
    db = clean_and_get_database
    campaigns_table = CampaignsTable.new(db)
    id = campaigns_table.add(CampaignEntity.new(
      title: "universe",
      copy: "lost", 
      image_url: "https://image.url",
      user_id: 2
    ))

    campaign = campaigns_table.get(id)
    expect(campaign.title).to eq "universe"
    expect(campaign.copy).to eq "lost"
    expect(campaign.image_url).to eq "https://image.url"
    expect(campaign.user_id).to eq "2"
  end

  it "adds campaign and updates it" do
    db = clean_and_get_database
    campaigns_table = CampaignsTable.new(db)
    id = campaigns_table.add(CampaignEntity.new(
      title: "universe",
      copy: "lost", 
      image_url: "https://image.url",
      user_id: 2
    ))

    campaigns_table.update(
      index: id,
      title: "universe2",
      copy: "lost2", 
      image_url: "https://image2.url",
      user_id: 2
    )

    campaign = campaigns_table.get(id)
    expect(campaign.title).to eq "universe2"
    expect(campaign.copy).to eq "lost2"
    expect(campaign.image_url).to eq "https://image2.url"
    expect(campaign.user_id).to eq "2"
  end
end
