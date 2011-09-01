#see: http://railstips.org/blog/archives/2011/08/31/stupid-simple-debugging/
LogBuddy.init(
  :logger   => Rails.logger,
  :disabled => Rails.env == "production"
)
