class ConfigLoader
  DEFAULT_OPTIONS = {
    config_path: nil,
    reconcile_only_new: true
  }.freeze

  def process(options = {})
    options = DEFAULT_OPTIONS.merge(options)
    # function of the "reconcile_only_new" flag
    # if true,
    #   it leaves the existing config and feature flags as it is and
    #   creates the missing configs and feature flags with their default values
    # if false,
    #   then it overwrites existing config and feature flags with default values
    #   also creates the missing configs and feature flags with their default values
    @reconcile_only_new = options[:reconcile_only_new]

    # setting the config path
    @config_path = options[:config_path].presence
    @config_path ||= Rails.root.join('config')

    # general installation configs
    reconcile_general_config

    # default account based feature configs
    reconcile_feature_config
  end


  private

  def account_features
    @account_features ||= YAML.safe_load(File.read("#{@config_path}/features.yml")).freeze
  end


  def save_general_config(existing, latest)
    if existing
      # save config only if reconcile flag is false and existing configs value does not match default value
      save_as_new_config(latest) if !@reconcile_only_new && compare_values(existing, latest)
    else
      save_as_new_config(latest)
    end
  end

  def compare_values(existing, latest)
    existing.value != latest[:value] ||
      (!latest[:locked].nil? && existing.locked != latest[:locked])
  end





  def compare_and_save_feature(config)
    features = if @reconcile_only_new
                 # leave the existing feature flag values as it is and add new feature flags with default values
                 (config.value + account_features).uniq { |h| h['name'] }
               else
                 # update the existing feature flag values with default values and add new feature flags with default values
                 (account_features + config.value).uniq { |h| h['name'] }
               end
    config.update({ name: 'ACCOUNT_LEVEL_FEATURE_DEFAULTS', value: features, locked: true })
  end
end
