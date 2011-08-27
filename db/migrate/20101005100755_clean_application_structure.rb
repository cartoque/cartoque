class CleanApplicationStructure < ActiveRecord::Migration
  def self.up
    self.columns.each do |col|
      rename_column :applications, col, col.gsub("appli_","")
    end
  end

  def self.down
    self.columns.each do |col|
      rename_column :applications, col.gsub("appli_",""), col
    end
  end

  protected
  def columns
    %w(nom criticite info iaw pe moa amoa moa_note contact pnd ams cerbere fiche).map{|col| "appli_#{col}"}
  end
end
