# This Builder will create a contact inbox with specified attributes. If the contact inbox already exists, it will be returned.
# For Specific Channels like whatsapp, email etc . it smartly generated appropriate the source id when none is provided.

class ContactInboxBuilder
  pattr_initialize [:contact, :inbox, :source_id, { hmac_verified: false }]

  def perform
    @source_id ||= generate_source_id
    create_contact_inbox if source_id.present?
  end

  private

  def generate_source_id
    case @inbox.channel_type
    when  'Channel::WebWidget'
      SecureRandom.uuid
    else
      raise "Unsupported operation for this channel: #{@inbox.channel_type}"
    end
  end

  def email_source_id
    raise ActionController::ParameterMissing, 'contact email' unless @contact.email

    @contact.email
  end

  def phone_source_id
    raise ActionController::ParameterMissing, 'contact phone number' unless @contact.phone_number

    @contact.phone_number
  end

  def wa_source_id
    raise ActionController::ParameterMissing, 'contact phone number' unless @contact.phone_number

    # whatsapp doesn't want the + in e164 format
    @contact.phone_number.delete('+').to_s
  end



  def create_contact_inbox
    ::ContactInbox.create_with(hmac_verified: hmac_verified || false).find_or_create_by!(
      contact_id: @contact.id,
      inbox_id: @inbox.id,
      source_id: @source_id
    )
  end
end
