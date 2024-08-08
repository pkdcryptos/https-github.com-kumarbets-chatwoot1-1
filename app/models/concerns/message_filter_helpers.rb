module MessageFilterHelpers
  extend ActiveSupport::Concern


  def webhook_sendable?
    incoming? || outgoing? || template?
  end


  def notifiable?
    incoming? || outgoing?
  end

  def conversation_transcriptable?
    incoming? || outgoing?
  end

  def email_reply_summarizable?
    incoming? || outgoing? 
  end


end
