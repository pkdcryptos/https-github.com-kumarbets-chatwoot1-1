class Api::V1::Accounts::CallbacksController < Api::V1::Accounts::BaseController
  before_action :inbox, only: [:reauthorize_page]



  def log_additional_info
    Rails.logger.debug do
      "user_access_token: #{params[:user_access_token]} , page_access_token: #{params[:page_access_token]} ,
      page_id: #{params[:page_id]}, inbox_name: #{params[:inbox_name]}"
    end
  end



  # get params[:inbox_id], current_account. params[:omniauth_token]
  def reauthorize_page
 

    head :unprocessable_entity
  end

  private

  def inbox
    @inbox = Current.account.inboxes.find_by(id: params[:inbox_id])
  end






  def long_lived_token(omniauth_token)
    koala.exchange_access_token_info(omniauth_token)['access_token']
  rescue StandardError => e
    Rails.logger.error "Error in long_lived_token: #{e.message}"
  end




end
