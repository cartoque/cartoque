FactoryGirl.define do
  factory :database do |s|
    s.name "database-01"
    s.type "postgres"
    s.server_ids { [ FactoryGirl.create(:server).id ] }
  end

  factory :oracle, parent: :database do |s|
    s.name "database-02"
    s.type "oracle"
    s.server_ids { [ FactoryGirl.create(:virtual).id ] }
  end
end
