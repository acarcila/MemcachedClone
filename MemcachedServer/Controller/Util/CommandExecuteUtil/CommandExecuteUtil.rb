require_relative "../../../Model/Cache/Cache"

class CommandExecuteUtil
  def CommandExecuteUtil.checkStatus(commandResponse, mapCommand)
  end

  def CommandExecuteUtil.itemToResponse(key, item)
    response = []
    if item
      response << "VALUE #{key} #{item.flags} #{item.whitespace}"
      response << "#{item.value}"
    end

    response
  end

  def CommandExecuteUtil.itemToGetsResponse(key, item)
    response = []
    if item
      response << "VALUE #{key} #{item.flags} #{item.whitespace} #{item.casToken}"
      response << "#{item.value}"
    end

    response
  end

  def CommandExecuteUtil.errorToResponse(status, error = nil)
    response = []
    response << "#{status} #{error}".strip

    response
  end

  def CommandExecuteUtil.execute(mapCommand, cache, value = nil)
    responseArray = Array.new
    commandResponse = nil
    unless mapCommand["status"]
      if mapCommand["command"] =~ /set|add|replace|append|prepend|cas\b/
        if mapCommand["whitespace"] != value.size
          responseArray << "CLIENT_ERROR bad data chunk"
          return responseArray
        end
        # executes the command by name
        unless mapCommand["command"] == "cas"
          commandResponse = cache.send(
            mapCommand["command"],
            key: mapCommand["keys"][0],
            value: value,
            ttl: mapCommand["ttl"],
            whitespace: mapCommand["whitespace"],
            flags: mapCommand["flags"],
          )
        else
          commandResponse = cache.send(
            mapCommand["command"],
            key: mapCommand["keys"][0],
            value: value,
            ttl: mapCommand["ttl"],
            whitespace: mapCommand["whitespace"],
            flags: mapCommand["flags"],
            casToken: mapCommand["casToken"],
          )
        end

        responseArray << commandResponse

        return responseArray
      elsif mapCommand["command"] =~ /g(e|a)t\b/
        mapCommand["keys"].each do |key|
          commandResponse = cache.get(key)
          responseArray += itemToResponse(key, commandResponse)
        end
      else
        mapCommand["keys"].each do |key|
          commandResponse = cache.get(key)
          responseArray += itemToGetsResponse(key, commandResponse)
        end
      end
      responseArray << "END"

      return responseArray
    end

    responseArray += errorToResponse(mapCommand["status"], *mapCommand["error"])
    return responseArray
  end
end
