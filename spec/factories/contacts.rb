FactoryGirl.define do
  factory :contact do |m|
    m.first_name 'John'
    m.last_name  'Doe'
    m.job_position 'CEO'
    m.company { FactoryGirl.create(:company) }
  end
end
