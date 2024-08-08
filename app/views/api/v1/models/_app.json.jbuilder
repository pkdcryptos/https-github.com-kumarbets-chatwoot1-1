json.id resource.id
json.name resource.name
json.description resource.description
json.enabled resource.enabled?(@current_account)

if Current.account_user&.administrator?
  json.call(resource.params, *resource.params.keys)
  json.action resource.action
  json.button resource.action
end


