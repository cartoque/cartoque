class Contact < Contactable
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name,   type: String
  field :last_name,    type: String
  field :job_position, type: String
  belongs_to :company
  has_and_belongs_to_many :mailing_lists

  #TODO: has_many :configuration_items, through: :contact_relations

  validates_presence_of :last_name, :image_url

  #TEMPORARY
  #TODO: has_many :contact_relations, dependent: :destroy
  def contact_relations
    []
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def company_name
    company.try(:name)
  end

  def company_name=(name)
    if name.present?
      self.company = Company.where(name: name).first || Company.create(name: name, internal: self.internal)
    end
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

  def self.like(term)
    if term
      mask = Regexp.new(term, Regexp::IGNORECASE)
      any_of({ first_name: mask }, { last_name: mask }, { job_position: mask }, { company_name: mask })
    else
      scoped
    end
  end
end
