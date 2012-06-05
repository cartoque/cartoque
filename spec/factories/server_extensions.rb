FactoryGirl.define do
  factory :server_extension do
    name "storage"
    serial_number "54321"
  end

  factory :server_extension_without_serial, parent: :server_extension do
    name "ext"
    serial_number nil
  end
end
