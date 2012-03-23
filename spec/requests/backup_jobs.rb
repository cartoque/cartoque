require 'spec_helper'

describe "BackupJobs" do
  let(:user) { FactoryGirl.create(:user) }
  before { login_as user }
  let!(:server) { MongoServer.create!(name: "srv-01") }
  let!(:job) { BackupJob.create!(hierarchy: "/", server_id: server.id) }

  describe "GET /backup_jobs" do
    it "gets all jobs" do
      visit backup_jobs_path
      page.status_code.should be 200
      page.should have_content "srv-01"
      page.should have_content "Manage exceptions"
    end
  end
end
