class Contacts::SyncAttributes
  attr_reader :contact

  def initialize(contact)
    @contact = contact
  end

  def perform

    set_contact_type
  end

  private



  def set_contact_type
    #  If the contact is already a lead or customer then do not change the contact type
    return unless @contact.contact_type == 'visitor'
    # If the contact has an email or phone number or social details( facebook_user_id, instagram_user_id, etc) then it is a lead
    # If contact is from external channel like facebook, instagram, whatsapp, etc then it is a lead
    return unless @contact.email.present? || @contact.phone_number.present? || social_details_present?

    @contact.contact_type = 'lead'
  end


end
