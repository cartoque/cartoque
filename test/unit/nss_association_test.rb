require 'test_helper'

class NssAssociationTest < ActiveSupport::TestCase
  test "NssAssociation methods are ok on Server and NssVolume" do
    server = Factory(:server)
    volume = NssVolume.create!(:name => "nss-volume-for-s1")
    assoc = NssAssociation.new(:nss_volume_id => volume.id, :server_id => server.id)
    assert assoc.save
    assert_equal [assoc.id], server.reload.nss_association_ids
    assert_equal [assoc.id], volume.reload.nss_association_ids
    assert_equal [volume.id], server.used_nss_volume_ids
    assert_equal [server.id], volume.client_ids
  end
end
