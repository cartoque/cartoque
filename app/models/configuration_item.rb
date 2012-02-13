class ConfigurationItem < ActiveRecord::Base
  belongs_to :item, polymorphic: true
  has_many :contact_relations, dependent: :destroy
  has_many :contacts, through: :contact_relations

  validates_presence_of :item

  before_validation :update_identifier!

  scope :by_item_type, proc {|type| where(item_type: type) }
  default_scope order('item_type, identifier')

  def self.generate_ci_for(record)
    raise "Not a real CI object" unless record.respond_to?(:configuration_item)
    ci = ConfigurationItem.find_or_create_by_item_type_and_item_id(record.class.to_s, record.id)
    ci.save
  end

  def update_identifier!
    if self.item.present?
      self.identifier = "#{self.item_type.downcase}::#{self.item.to_s.try(:parameterize)}"
    end
  end

  def self.real_object_classes
    ConfigurationItemsObserver.instance.observed_classes.map(&:name)
  end

  def contact_relations_with_role(role)
    contact_relations.includes(:contact, :role)
                     .where(role_id: role.to_param)
  end

  def contacts_with_role(role)
    contact_relations_with_role(role).map(&:contact)
  end

  def contact_ids_with_role(role)
    contact_relations_with_role(role).map(&:contact_id)
  end

  #"contact_ids_with_role"=>{"2"=>["3", "6"], "3"=>["2"], "4"=>["4"]}
  def contact_ids_with_role=(hsh)
    hsh.stringify_keys!
    Role.pluck(:id).each do |role_id|
      contact_ids = hsh[role_id.to_s] || []
      #sanitize array
      contact_ids = contact_ids.reject(&:blank?).map(&:to_i)
      #remove old ones
      contact_relations_with_role(role_id).reject{|cr| cr.contact_id.in?(contact_ids)}.each(&:destroy)
      #add new ones
      (contact_ids - contact_relations_with_role(role_id).map(&:contact_id)).each do |contact_id|
        contact_relations << ContactRelation.create(contact_id: contact_id, role_id: role_id)
      end
    end
  end
end
