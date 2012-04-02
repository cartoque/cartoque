FactoryGirl.define do
  factory :user do |m|
    m.uid 'admin'
    m.name 'Administrateur Datacenter'
    m.provider 'CAS'
    m.authentication_token '0c83677b014f4afb38e416539758c50b'
  end

  factory :bob, class: 'User' do |m|
    m.uid 'bob'
    m.name 'Bob'
    m.provider 'CAS'
  end
end
