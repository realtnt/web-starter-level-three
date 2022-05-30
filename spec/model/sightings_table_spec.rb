require "helpers/database_helpers"
require "sighting_entity"
require "sightings_table"

RSpec.describe SightingsTable do
  def clean_and_get_database
    DatabaseHelpers.clear_table("sightings")
    return DatabaseHelpers.test_db_connection
  end

  it "start with an empty table" do
    db = clean_and_get_database
    sightings_table = SightingsTable.new(db)
    expect(sightings_table.list(0)).to eq([])
  end

  it "adds sightings and lists them out again" do
    db = clean_and_get_database
    sightings_table = SightingsTable.new(db)
    sightings_table.add(SightingEntity.new(
      location: "universe",
      details: "lost", 
      user_id: 2, 
      cat_ad_id: 3,
      spotted_on: "01/01/2022", 
      posted_on: "01/01/2022 00:00:00"
    ))

    sightings = sightings_table.list(3)
    expect(sightings.length).to eq 1
    expect(sightings[0].location).to eq "universe"
    expect(sightings[0].details).to eq "lost"
    expect(sightings[0].user_id).to eq "2"
    expect(sightings[0].cat_ad_id).to eq "3"
    expect(sightings[0].spotted_on).to eq "2022-01-01"
    expect(sightings[0].posted_on).to eq "2022-01-01 00:00:00"
  end

  it "adds sightings and removes them" do
    db = clean_and_get_database
    sightings_table = SightingsTable.new(db)
    sightings_table.add(SightingEntity.new(
      location: "universe",
      details: "lost", 
      user_id: 2, 
      cat_ad_id: 3,
      spotted_on: "01/01/2022", 
      posted_on: "01/01/2022 00:00:00"
    ))

    sightings = sightings_table.list(3)
    expect(sightings.length).to eq 1
    expect(sightings[0].location).to eq "universe"
    expect(sightings[0].details).to eq "lost"
    expect(sightings[0].user_id).to eq "2"
    expect(sightings[0].cat_ad_id).to eq "3"
    expect(sightings[0].spotted_on).to eq "2022-01-01"
    expect(sightings[0].posted_on).to eq "2022-01-01 00:00:00"

    sightings_table.remove(sightings[0].id)
    sightings = sightings_table.list(3)
    expect(sightings.length).to eq 0
  end

  it "adds sighting and gets it" do
    db = clean_and_get_database
    sightings_table = SightingsTable.new(db)
    sighting = SightingEntity.new(
      location: "universe",
      details: "lost", 
      user_id: 2, 
      cat_ad_id: 3,
      spotted_on: "01/01/2022", 
      posted_on: "01/01/2022 00:00:00"
    )
    id = sightings_table.add(sighting)

    sighting = sightings_table.get(id)
    expect(sighting.location).to eq "universe"
    expect(sighting.details).to eq "lost"
    expect(sighting.user_id).to eq "2"
    expect(sighting.cat_ad_id).to eq "3"
    expect(sighting.spotted_on).to eq "2022-01-01"
    expect(sighting.posted_on).to eq "2022-01-01 00:00:00"
  end

  it "adds sighting and updates it" do
    db = clean_and_get_database
    sightings_table = SightingsTable.new(db)
    sighting = SightingEntity.new(
      location: "universe",
      details: "lost", 
      user_id: 2, 
      cat_ad_id: 3,
      spotted_on: "01/01/2022", 
      posted_on: "01/01/2022 00:00:00"
    )
    id = sightings_table.add(sighting)

    sightings_table.update(
      index: id,
      location: "universe2",
      details: "lost2", 
      user_id: 2, 
      cat_ad_id: 4,
      spotted_on: "01/01/2022", 
      posted_on: "01/01/2022 00:00:00"
    )

    sightings = sightings_table.list(4)
    expect(sightings.length).to eq 1
    expect(sightings[0].location).to eq "universe2"
    expect(sightings[0].details).to eq "lost2"
    expect(sightings[0].user_id).to eq "2"
    expect(sightings[0].cat_ad_id).to eq "4"
    expect(sightings[0].spotted_on).to eq "2022-01-01"
    expect(sightings[0].posted_on).to eq "2022-01-01 00:00:00"
  end
end
