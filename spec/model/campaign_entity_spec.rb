require 'campaign_entity'

RSpec.describe CampaignEntity do
  it "constructs without an ID" do
    campaign = CampaignEntity.new(
      title: "Big Campaign Title",
      copy: "Some interesting copy",
      image_url: "https://image.url",
      user_id: 3
    )
    expect(campaign.title).to eq "Big Campaign Title"
    expect(campaign.copy).to eq "Some interesting copy"
    expect(campaign.image_url).to eq "https://image.url"
    expect(campaign.user_id).to eq 3
  end

  it "constructs with an ID" do
    campaign = CampaignEntity.new(
      title: "Big Campaign Title",
      copy: "Some interesting copy",
      image_url: "https://image.url",
      user_id: 3,
      id: 5
    )
    expect(campaign.title).to eq "Big Campaign Title"
    expect(campaign.copy).to eq "Some interesting copy"
    expect(campaign.image_url).to eq "https://image.url"
    expect(campaign.user_id).to eq 3
    expect(campaign.id).to eq 5
  end
end
