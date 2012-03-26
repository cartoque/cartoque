class Cronjob
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user, type: String
  field :frequency, type: String
  field :command, type: String
  field :definition_location, type: String
  field :server_name, type: String
  belongs_to :server

  before_save :cache_associations_fields

  validates_presence_of :server, :frequency, :command

  scope :by_server, proc { |server_id| where(server_id: server_id) }
  scope :by_command, proc { |term| where(command: Regexp.new(term, Regexp::IGNORECASE)) }
  scope :by_definition, proc { |place| where(definition_location: Regexp.new(place, Regexp::IGNORECASE)) }

  SPECIAL_FREQUENCIES = {
    "@reboot"   => "Run once, at startup.",
    "@yearly"   => "Run once a year, equivalent to 0 0 1 1 *",
    "@annually" => "Run once a year, equivalent to 0 0 1 1 *",
    "@monthly"  => "Run once a month, equivalent to 0 0 1 * *",
    "@weekly"   => "Run once a week, equivalent to 0 0 * * 0",
    "@daily"    => "Run once a day, equivalent to 0 0 * * *",
    "@midnight" => "Run once a day, equivalent to 0 0 * * *",
    "@hourly"   => "Run once an hour, equivalent to 0 * * * *"
  }

  def self.parse_line(line)
    #typical line: "0 6 * * * root /usr/bin/my_script.sh >/dev/null && blah
    cron = Cronjob.new
    elems = line.strip.split(/\s+/)
    #handle commented lines
    return cron if elems.first.blank? || elems.first.match(/^\s*[#a-z]/)
    #handle definition_locations in first column
    if elems.first && elems.first.match(%r{^(/|crontab)})
      cron.definition_location = elems.shift
    end
    #handle frequencies
    if elems.first && elems.first.in?(SPECIAL_FREQUENCIES)
      cron.frequency = elems.shift
    elsif elems.size >= 5
      cron.frequency = elems[0..4].join(" ")
      5.times{ elems.shift }
    end
    #handle other attributes
    cron.user = elems.shift
    cron.command = elems.join(" ")
    cron
  end

  private
  def cache_associations_fields
    self.server_name = self.server.try(:name)
  end
end
