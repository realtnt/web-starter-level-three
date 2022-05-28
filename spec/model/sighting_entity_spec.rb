require 'sighting_entity'

RSpec.describe SightingEntity do
  it "constructs without an ID" do
    sighting = SightingEntity.new(
      location: "High Street",
      details: "Blah Blah",
      user_id: 3,
      cat_ad_id: 3
    )
    expect(sighting.location).to eq "High Street"
    expect(sighting.details).to eq "Blah Blah"
    expect(sighting.user_id).to eq 3
    expect(sighting.cat_ad_id).to eq 3
  end

  it "constructs with an ID" do
    sighting = SightingEntity.new(
      location: "High Street",
      details: "Blah Blah",
      user_id: 3,
      cat_ad_id: 3,
      id: 5
    )
    expect(sighting.location).to eq "High Street"
    expect(sighting.details).to eq "Blah Blah"
    expect(sighting.user_id).to eq 3
    expect(sighting.cat_ad_id).to eq 3
    expect(sighting.id).to eq 5
  end
end
