class Contact < ActiveRecord::Base
  include Contactable

  belongs_to :company

  validates_presence_of :last_name, :image_url

  def company_name
    company.try(:name)
  end

  def company_name=(name)
    self.company = Company.find_or_create_by_name(name) if name.present?
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def short_name
    initials = first_name.gsub(/(?:^|[ -.])(.)[^ -.]*/){ $1.upcase }
    "#{initials} #{last_name.capitalize}"
  end

  def self.available_images
    %w(ceo.png
       reseller_account.png 
       user_chief_female.png 
       user.png 
       user_female.png
       user_ninja.png 
       user_clown.png
       user_astronaut.png
       user_batman.png)
  end

  def self.available_images_hash
    hsh = {}
    available = self.available_images
    available.each_with_index do |img, idx|
      hsh[img] = available[idx+1] || available[0]
    end
    hsh
  end

  def self.search(search)
    if search
      s = "%#{search}%"
      includes("company").where("first_name LIKE ? OR last_name LIKE ? OR job_position LIKE ? OR companies.name LIKE ?", s, s, s, s)
    else
      scoped
    end
  end
end
