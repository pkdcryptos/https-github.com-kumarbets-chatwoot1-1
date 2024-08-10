module AssignmentHandler
  extend ActiveSupport::Concern
  include Events::Types

  included do
    after_commit :notify_assignment_change, :process_assignment_changes
  end

  private



  def notify_assignment_change
    {
      ASSIGNEE_CHANGED => -> { saved_change_to_assignee_id? },
    }.each do |event, condition|
      condition.call && dispatcher_dispatch(event, previous_changes)
    end
  end

  def process_assignment_changes
    process_assignment_activities
  end

  def process_assignment_activities
    user_name = Current.user.name if Current.user.present?
    if  saved_change_to_assignee_id?
      create_assignee_change_activity(user_name)
    end
  end
end
