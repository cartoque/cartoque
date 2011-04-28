class Storage < ActiveRecord::Base
  belongs_to :machine

  validates_presence_of :machine
  validates_presence_of :constructor

  def self.supported_types
    ["IBM", "NetApp", "Equalogic"]
  end

  def file
    File.expand_path("data/storage/#{machine.name.downcase}.txt", Rails.root)
  end

  def device
    return @device if @device
    begin
      @device = case constructor
                when "IBM"
                  Storcs::Parsers::Ibm.new(machine.name, file).device
                when "NetApp"
                  Storcs::Parsers::DfNas.new(machine.name, file).device
                when "Equalogic"
                  Storcs::Parsers::Equalogic.new(machine.name, file).device
                end
    rescue Errno::ENOENT
      @device = "Pas de fichier .#{file.gsub(Rails.root.to_s,"")}"
    rescue
      @device = "Erreur: #{$!}"
    end
    @device
  end
end
