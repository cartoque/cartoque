require 'spec_helper'

describe NssAssociation do
  it "should generate appropriate methods on Server and NssVolume" do
    server = Factory(:server)
    volume = NssVolume.create!(:name => "nss-volume-for-s1")
    assoc = NssAssociation.new(:nss_volume_id => volume.id, :server_id => server.id)
    assoc.save.should be_true
    server.reload.nss_association_ids.should eq [assoc.id]
    volume.reload.nss_association_ids.should eq [assoc.id]
    server.used_nss_volume_ids.should eq [volume.id]
    volume.client_ids.should eq [server.id]
  end
end
