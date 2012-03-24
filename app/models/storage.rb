class Storage
  include Mongoid::Document
  include Mongoid::Timestamps

  field :constructor, type: String
  field :details, type: String
  belongs_to :server, class_name: 'MongoServer'

  validates_presence_of :server
  validates_presence_of :constructor

  scope :by_constructor, proc { |constructor| where(constructor: constructor) }

  def self.supported_types
    %w(IBM NetApp Equalogic)
  end

  def to_s
    server.name
  end

  def file
    File.expand_path("data/storage/#{server.name.downcase}.txt", Rails.root)
  end

  def device
    return @device if @device
    begin
      @device = case constructor
                when "IBM"
                  Storcs::Parsers::Ibm.new(server.name, file).device
                when "NetApp"
                  Storcs::Parsers::DfNas.new(server.name, file).device
                when "Equalogic"
                  Storcs::Parsers::Equalogic.new(server.name, file).device
                end
    rescue Errno::ENOENT
      @device = "Not file found .#{file.gsub(Rails.root.to_s,"")}"
    rescue
      @device = "Error: #{$!}"
    end
    @device
  end
end
