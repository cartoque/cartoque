# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :database_instance do
      name "MyString"
      ipaddress "MyString"
      port 1
      database_version "MyString"
      database_id 1
    end
end