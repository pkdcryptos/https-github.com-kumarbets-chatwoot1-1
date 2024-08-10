class Api::V1::Accounts::ConversationsController < Api::V1::Accounts::BaseController
  include Events::Types
  include DateRangeHelper
  include HmacConcern

  before_action :conversation, except: [:index, :meta, :search, :create, :filter]


  def index
    result = conversation_finder.perform
    @conversations = result[:conversations]
    @conversations_count = result[:count]
  end

  def meta
    result = conversation_finder.perform
    @conversations_count = result[:count]
  end

  def search
    result = conversation_finder.perform
    @conversations = result[:conversations]
    @conversations_count = result[:count]
  end

  def attachments
    @attachments = @conversation.attachments
  end

  def show; end

  def create
    ActiveRecord::Base.transaction do
      @conversation = ConversationBuilder.new(params: params).perform
      Messages::MessageBuilder.new(Current.user, @conversation, params[:message]).perform if params[:message].present?
    end
  end

  def update
    @conversation.update!(permitted_update_params)
  end

  def filter
    result = ::Conversations::FilterService.new(params.permit!, current_user).perform
    @conversations = result[:conversations]
    @conversations_count = result[:count]

  end

  def mute
    @conversation.mute!
    head :ok
  end

  def unmute
    @conversation.unmute!
    head :ok
  end

  def transcript
    render json: { error: 'email param missing' }, status: :unprocessable_entity and return if params[:email].blank?

      head :ok
  end

  def toggle_status
    # FIXME: move this logic into a service object
    if  params[:status].present?
      set_conversation_status
      @status = @conversation.save!
    else
      @status = @conversation.toggle_status
    end
    assign_conversation if should_assign_conversation?
  end


  def should_assign_conversation?
    @conversation.status == 'open' && Current.user.is_a?(User) && Current.user&.agent?
  end

  def toggle_priority
    @conversation.toggle_priority(params[:priority])
    head :ok
  end

  def toggle_typing_status
    typing_status_manager = ::Conversations::TypingStatusManager.new(@conversation, current_user, params)
    typing_status_manager.toggle_typing_status
    head :ok
  end

  def update_last_seen
    update_last_seen_on_conversation(DateTime.now.utc, assignee?)
  end

  def unread
    last_incoming_message = @conversation.messages.incoming.last
    last_seen_at = last_incoming_message.created_at - 1.second if last_incoming_message.present?
    update_last_seen_on_conversation(last_seen_at, true)
  end



  private

  def permitted_update_params
    # TODO: Move the other conversation attributes to this method and remove specific endpoints for each attribute
    params.permit(:priority)
  end

  def update_last_seen_on_conversation(last_seen_at, update_assignee)
    # rubocop:disable Rails/SkipsModelValidations
    @conversation.update_column(:agent_last_seen_at, last_seen_at)
    @conversation.update_column(:assignee_last_seen_at, last_seen_at) if update_assignee.present?
    # rubocop:enable Rails/SkipsModelValidations
  end

  def set_conversation_status
    @conversation.status = params[:status]
    @conversation.snoozed_until = parse_date_time(params[:snoozed_until].to_s) if params[:snoozed_until]
  end

  def assign_conversation
    @conversation.assignee = current_user
    @conversation.save!
  end

  def conversation
    @conversation ||= Current.account.conversations.find_by!(display_id: params[:id])
    
  end

  

  def contact
    return if params[:contact_id].blank?

    @contact = Current.account.contacts.find(params[:contact_id])
  end

  

  def conversation_finder
    @conversation_finder ||= ConversationFinder.new(Current.user, params)
  end

  def assignee?
    @conversation.assignee_id? && Current.user == @conversation.assignee
  end
end

Api::V1::Accounts::ConversationsController.prepend_mod_with('Api::V1::Accounts::ConversationsController')
