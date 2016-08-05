module URLUpdater
  def url_update!
    store_json = "#{@store.to_json}|"
    if @store.previous_hash != "" && @store.previous_hash != store_json
      $$.location.hash   = store_json
    end
    @store.previous_hash = store_json
  end

  def url_load_values!
    json_configs  = $$.location.hash
    json_configs  = json_configs[1..-1]

    # decode the url it it's CGI encoded
    json_configs = $$.decodeURI json_configs if json_configs[0] == "%"

    json_configs = json_configs[0..-2].to_n
    `json_configs = JSON.parse(json_configs)`
    configs  = Hash.new `json_configs`
    configs.each do |key, val|
      @store.set key, val
    end
  end
end
