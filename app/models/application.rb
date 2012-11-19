class Application
  include Mongoid::Document
  include Mongoid::Alize
  include Mongoid::Timestamps
  include Mongoid::Slug
  include ConfigurationItem
    
  #standard fields
  field :name, type: String
  field :description, type: String
  field :ci_identifier, type: String
  #associations
  has_many :application_instances, autosave: true, dependent: :destroy
  has_many :relationships, as: :item, dependent: :destroy
  #slug
  slug :name do |application|
    application.name
               .downcase
               .gsub(/[^a-z0-9_-]/,"-")
               .gsub(/--+/, "-")
               .gsub(/^-|-$/,"")
  end

  validates_presence_of :name
  validates_associated :application_instances

  accepts_nested_attributes_for :application_instances, allow_destroy: true,
                                reject_if: lambda{|a| a[:name].blank? && !a[:server_ids].detect(&:present?) }

  def relationships_map
    map = relationships.group_by do |relation|
      relation.role_id.to_s
    end
    map.default = []
    map
  end

  def relationships_map=(map)
    relationships = Role.all.map do |role|
      rel = Relationship.find_or_initialize_by(role_id: role.id, item_type: self.class, item_id: self.id)
      rel.contact_ids = Array(map[role.id.to_s].try(:split, ","))
      rel.save
    end
  end

  def contacts_with_role(role)
    #TODO: be sure we have only one relationship per role, then use Enumerable#detect()
    relationships_map[role.id.to_s].map(&:contacts).flatten
  end

  def to_s
    name
  end

  def sorted_application_instances
    ary = application_instances
    prod = ary.select{|ai| ai.name == "prod"}
    preprod = ary.select{|ai| ai.name == "preprod"}
    ecole = ary.select{|ai| ai.name == "ecole"}
    others = ary.select{|ai| !ai.name.in? %w(prod preprod ecole) }
    [prod, ecole, preprod, others].flatten.compact
  end

  def self.dokuwiki_dir
    File.expand_path("data/dokuwiki", Rails.root)
  end

  def dokuwiki_pages
    keywords = [name] + application_instances.map(&:application_urls).flatten.map(&:url)
    keywords.map!{|k| k.gsub(%r{^\s*\S+://}, "").gsub(%r{/.*}, "").downcase}
    available_docs = Dir.glob("#{Application.dokuwiki_dir}/*.txt").map do |f|
      File.readlines(f).map(&:chomp)
    end.flatten
    docs = []
    keywords.each do |kw|
      docs += available_docs.select do |docname|
        docname.include?(kw)
      end.map do |doc|
        doc.gsub(/\.txt$/,"").gsub("/", ":")
      end
    end
    docs.uniq
  end

  class << self
    def find(*args)
      where(ci_identifier: args.first).first || where(slug: args.first).first || super
    end

    def search(term)
      if term
        where(name: Regexp.mask(term))
      else
        all
      end
    end
  end
end
