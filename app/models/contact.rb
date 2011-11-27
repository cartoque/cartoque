class Contact < ActiveRecord::Base
  has_many :contact_infos, :dependent => :destroy
  belongs_to :company

  validates_presence_of :first_name, :last_name

  def company_name
    company.try(:name)
  end

  def company_name=(name)
    self.company = Company.find_or_create_by_name(name) if name.present?
  end

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
