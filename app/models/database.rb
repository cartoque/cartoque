class Database < ActiveRecord::Base
  attr_accessible :name, :machine_ids
  has_many :machines
  validates_presence_of :name

  def postgres_report
    machines.inject([]) do |memo,machine|
      memo.concat(machine.postgres_report)
    end
  end
end
