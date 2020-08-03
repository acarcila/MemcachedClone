require_relative "../../../Model/Cache/Cache"

class CommandExecuteUtil
  def CommandExecuteUtil.checkStatus(commandResponse, mapCommand)
  end

  def CommandExecuteUtil.itemToResponse(key, item)
    response = []
    if item
      response << "VALUE #{key} #{item.flags} #{item.whitespace}"
      response << "#{item.value}"
    else
      response << "ERROR"
    end
  end

  def CommandExecuteUtil.execute(mapCommand, cache, value = nil)
    responseArray = Array.new
    commandResponse = nil
    unless mapCommand["output"]
      if mapCommand["command"] =~ /set|add|replace|append|prepend|cas/
        case mapCommand["command"]
        when "set"
          commandResponse = cache.set(key: mapCommand["keys"][0], value: value, ttl: mapCommand["ttl"], whitespace: mapCommand["whitespace"], flags: mapCommand["flags"])
        when "add"
          commandResponse = cache.add(key: mapCommand["keys"][0], value: value, ttl: mapCommand["ttl"], whitespace: mapCommand["whitespace"], flags: mapCommand["flags"])
        when "replace"
          commandResponse = cache.replace(key: mapCommand["keys"][0], value: value, ttl: mapCommand["ttl"], whitespace: mapCommand["whitespace"], flags: mapCommand["flags"])
        when "append"
          commandResponse = cache.append(key: mapCommand["keys"][0], value: value, ttl: mapCommand["ttl"], whitespace: mapCommand["whitespace"], flags: mapCommand["flags"])
        when "prepend"
          commandResponse = cache.prepend(key: mapCommand["keys"][0], value: value, ttl: mapCommand["ttl"], whitespace: mapCommand["whitespace"], flags: mapCommand["flags"])
        else
          responseArray << "ERROR"
        end

        if commandResponse
          responseArray << "STORED"
        else
          responseArray << "ERROR"
        end
      else
        mapCommand["keys"].each do |key|
          commandResponse = cache.get(key)
          responseArray += itemToResponse(key, commandResponse)
        end
      end
    else
      responseArray << mapCommand["output"]
    end

    return responseArray
  end
end
