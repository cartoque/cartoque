class Application
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
    
  #standard fields
  field :name, type: String
  field :description, type: String
  field :ci_identifier, type: String
  #associations
  has_many :application_instances, autosave: true, dependent: :destroy
  #slug
  slug :name do |doc|
    doc.name.downcase.gsub(/[^a-z0-9_-]/,"-")
            .gsub(/--+/, "-")
            .gsub(/^-|-$/,"")
  end

  validates_presence_of :name

  accepts_nested_attributes_for :application_instances, reject_if: lambda{|a| a[:name].blank? },
                                                        allow_destroy: true

  #TODO:
###  delegate :contacts, :contact_ids, :contact_ids=, :contact_relations,
###           :contacts_with_role, :contact_ids_with_role, :contact_ids_with_role=,
###           to: :configuration_item
  
  #THIS IS TEMPORARY
  def contacts_with_role(role=nil); []; end
  def contact_ids_with_role(role=nil); []; end

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
      find_by_slug(*args) || super
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
