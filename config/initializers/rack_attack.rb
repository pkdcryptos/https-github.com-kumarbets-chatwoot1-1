class Rack::Attack
  ### Configure Cache ###

  # If you don't want to use Rails.cache (Rack::Attack's default), then
  # configure it here.
  #
  # Note: The store is only used for throttling (not blocklisting and
  # safelisting). It must implement .increment and .write like
  # ActiveSupport::Cache::Store

  # Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  # https://github.com/rack/rack-attack/issues/102
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(redis: $velma)

  class Request < ::Rack::Request
    # You many need to specify a method to fetch the correct remote IP address
    # if the web server is behind a load balancer.
    def remote_ip
      @remote_ip ||= (env['action_dispatch.remote_ip'] || ip).to_s
    end

    def allowed_ip?
      allowed_ips = ['127.0.0.1', '::1']
      allowed_ips.include?(remote_ip)
    end

    # Rails would allow requests to paths with extentions, so lets compare against the path with extention stripped
    # example /auth & /auth.json would both work
    def path_without_extentions
      path[/^[^.]+/]
    end
  end



  ## ----------------------------------------------- ##
end



Rack::Attack.enabled =  false
