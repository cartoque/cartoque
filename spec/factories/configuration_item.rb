Factory.define :configuration_item do |ci|
  ci.item { Factory(:server) }
end
