class Contact < ActiveRecord::Base
  validates_presence_of :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_position
    [job_position, company].reject(&:blank?).join(", ")
  end

  def short_email
    "#{email}".gsub(/(.+)@([^@]+)$/) do
      $1+"@"+$2.gsub(/.*(\.[^.]+\.[^.]+)/, '..\1')
    end
  end
end
