class SuperAdmin::SettingsController < SuperAdmin::ApplicationController
  def show; end

  def refresh
   # rubocop:disable Rails/I18nLocaleTexts
    redirect_to super_admin_settings_path, notice: 'Instance status refreshed'
    # rubocop:enable Rails/I18nLocaleTexts
  end
end
