class Storage < ActiveRecord::Base
  acts_as_configuration_item

  belongs_to :server

  validates_presence_of :server
  validates_presence_of :constructor

  scope :by_constructor, proc {|constructor| { conditions: { constructor: constructor } } }

  def self.supported_types
    ["IBM", "NetApp", "Equalogic"]
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
      @device = "Pas de fichier .#{file.gsub(Rails.root.to_s,"")}"
    rescue
      @device = "Erreur: #{$!}"
    end
    @device
  end
end
