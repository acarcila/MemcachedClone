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

  def CommandExecuteUtil.execute(mapCommand, cache, value = nil)
    responseArray = Array.new
    commandResponse = nil
    unless mapCommand["status"]
      if mapCommand["command"] =~ /set|add|replace|append|prepend|cas/
        # executes the command by name
        commandResponse = cache.send(mapCommand["command"], key: mapCommand["keys"][0], value: value, ttl: mapCommand["ttl"], whitespace: mapCommand["whitespace"], flags: mapCommand["flags"])

        if commandResponse
          responseArray << "STORED"
        else
          responseArray << "NOT_STORED"
        end
      else
        mapCommand["keys"].each do |key|
          puts "key"
          puts key
          commandResponse = cache.get(key)
          responseArray += itemToResponse(key, commandResponse)
        end
        responseArray << "END"
      end
    else
      responseArray << mapCommand["status"]
    end

    return responseArray
  end
end
