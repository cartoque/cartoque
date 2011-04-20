class ConvertDatesFromStringToDates < ActiveRecord::Migration
  def self.up
    {:date_mes => :delivered_on, :fin_garantie => :maintained_until}.each do |old_field, new_field|
      Machine.all.each do |m|
        value = m.send(old_field)
        unless value.blank?
          value = "#{$1}/20#{$2}" if value.match %r{(.*\d\d)/(\d\d)$}
          begin
            m.send("#{new_field}=", Date.parse(value))
          rescue ArgumentError
          end
          m.save
        end
      end
    end
  end

  def self.down
  end
end