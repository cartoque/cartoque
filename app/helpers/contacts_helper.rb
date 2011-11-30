module ContactsHelper
  def full_position(contact, linkify = false)
    res = []
    res << contact.job_position if contact.job_position.present?
    if contact.company.present?
      if linkify
        res << link_to(contact.company, contact.company)
      else
        res << contact.company
      end
    end
    res.join(", ").html_safe
  end
end
