class CleanApplicationStructure < ActiveRecord::Migration
  def self.up
    Application.columns.map(&:name).each do |col|
      rename_column :applications, col, col.gsub("appli_","")
    end
  end

  def self.down
    Application.columns.map(&:name).each do |col|
      rename_column :applications, col, col.gsub(/^/,"appli_")
    end
  end
end
