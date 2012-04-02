FactoryGirl.define do
  factory :storage do |s|
    s.server { FactoryGirl.create(:server) }
    s.constructor "IBM"
  end
end
