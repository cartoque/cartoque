class DenormalizeApplicationName < Mongoid::Migration
  def self.up
    Application.all.each(&:save)
  end

  def self.down
  end
end
