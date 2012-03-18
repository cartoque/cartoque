# temp class for active_record versions of objects
class ARContact < ActiveRecord::Base
  self.table_name = "contacts"
  belongs_to :company, class_name: "ARCompany", foreign_key: "company_id"
  has_many :contact_infos, class_name: "ARContactInfo", foreign_key: "contact_id", as: "entity"
end

class ARCompany < ActiveRecord::Base
  self.table_name = "companies"
  has_one :contact, class_name: "ARContact", foreign_key: "company_id"
  has_many :contact_infos, class_name: "ARContactInfo", foreign_key: "contact_id", as: "entity"
  has_many :maintained_servers, class_name: 'ARServer', foreign_key: 'maintainer_id'
end

class ARServer < ActiveRecord::Base
  self.table_name = "servers"
end

class ARContactInfo < ActiveRecord::Base
  self.table_name = "contact_infos"
end

# migration!
class MigrateContactAndCompaniesToMongoid < ActiveRecord::Migration
  def up
    Contact.destroy_all
    Company.destroy_all
    add_column :servers, :maintainer_mongo_id, :string
    add_column :contacts_mailing_lists, :contact_mongo_id, :string

    map = {"Contact" => [], "Company" => []}

    #first migrate contacts
    cols = ARContact.column_names - %w(id)
    ARContact.all.each do |item|
      attrs = item.attributes.slice(*cols)
      mitem = Contact.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE contacts_mailing_lists SET contact_mongo_id='#{mitem.id}' WHERE contact_id = #{item.id}")
      map["Contact"][item.id] = mitem
    end

    #then migrate companies
    cols = ARCompany.column_names - %w(id)
    ARCompany.all.each do |item|
      attrs = item.attributes.slice(*cols)
      mitem = Company.create(attrs)
      ActiveRecord::Base.connection.execute("UPDATE servers SET maintainer_mongo_id='#{mitem.id}' WHERE id = #{item.id}")
      map["Company"][item.id] = mitem
    end

    #finally migrate all contact_infos
    cols = ARContactInfo.column_names - %w(id entity_type entity_id created_at updated_at)
    ARContactInfo.all.each do |item|
      attrs = item.attributes.slice(*cols)
      next unless item.entity_type.present? && item.entity_id.present?
      type = attrs.delete("info_type").gsub(/^mail$/, "email")
      begin
        klass = "#{type.capitalize}Info".constantize
      rescue NameError
        klass = nil
        $stderr.puts "Unable to infer klass for type=#{type} (attrs=#{attrs.inspect})"
      end
      if !klass.nil? && map[item.entity_type].present? && mitem = map[item.entity_type][item.entity_id]
        klass.create(attrs.merge(entity: mitem))
      end
    end

    #we don't migrate contact_relations since it's not used for the moment
  end

  def down
    remove_column :contacts_mailing_lists, :contact_mongo_id
    remove_column :servers, :maintainer_mongo_id
    #nothing else for now! maybe a bit of cleanup later?
  end
end
