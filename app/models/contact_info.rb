module ContactInfo
  def self.included(base)
    base.class_eval do
      field :value,  type: String
      embedded_in :entity, polymorphic: true
      validates_presence_of :entity, :value
    end
  end

  def to_s
    value
  end
end
