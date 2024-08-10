# retain_original_contact_name: false / true
# In case of setUser we want to update the name of the identified contact,
# which is the default behaviour
#
# But, In case of contact merge during prechat form contact update.
# We don't want to update the name of the identified original contact.

class ContactIdentifyAction
  pattr_initialize [:contact!, :params!, { retain_original_contact_name: false, discard_invalid_attrs: false }]

  def perform
    @attributes_to_update = [:identifier, :name, :email, :phone_number]

    ActiveRecord::Base.transaction do
      merge_if_existing_identified_contact
      merge_if_existing_phone_number_contact
    end
    @contact
  end

  private

  def account
    @account ||= @contact.account
  end

  def merge_if_existing_identified_contact
    return unless merge_contacts?(existing_identified_contact, :identifier)

    process_contact_merge(existing_identified_contact)
  end

  def merge_if_existing_email_contact
    return unless merge_contacts?(existing_email_contact, :email)

    process_contact_merge(existing_email_contact)
  end

  def merge_if_existing_phone_number_contact
    return unless merge_contacts?(existing_phone_number_contact, :phone_number)
    return unless mergable_phone_contact?

    process_contact_merge(existing_phone_number_contact)
  end

  def process_contact_merge(mergee_contact)
    @contact = merge_contact(mergee_contact, @contact)
    @attributes_to_update.delete(:name) if retain_original_contact_name
  end

  def existing_identified_contact
    return if params[:identifier].blank?

    @existing_identified_contact ||= account.contacts.find_by(identifier: params[:identifier])
  end

  def existing_email_contact
    return if params[:email].blank?

    @existing_email_contact ||= account.contacts.from_email(params[:email])
  end

  def existing_phone_number_contact
    return if params[:phone_number].blank?

    @existing_phone_number_contact ||= account.contacts.find_by(phone_number: params[:phone_number])
  end

  def merge_contacts?(existing_contact, key)
    return if existing_contact.blank?

    return true if params[:identifier].blank?

    # we want to prevent merging contacts with different identifiers
    if existing_contact.identifier.present? && existing_contact.identifier != params[:identifier]
      # we will remove attribute from update list
      @attributes_to_update.delete(key)
      return false
    end

    true
  end

  # case: contact 1: email: 1@test.com, phone: 123456789
  # params: email: 2@test.com, phone: 123456789
  # we don't want to overwrite 1@test.com since email parameter takes higer priority
  def mergable_phone_contact?
    return true if params[:email].blank?

    if existing_phone_number_contact.email.present? && existing_phone_number_contact.email != params[:email]
      @attributes_to_update.delete(:phone_number)
      return false
    end
    true
  end


  def merge_contact(base_contact, merge_contact)
    return base_contact if base_contact.id == merge_contact.id

    ContactMergeAction.new(
      account: account,
      base_contact: base_contact,
      mergee_contact: merge_contact
    ).perform
  end




end
