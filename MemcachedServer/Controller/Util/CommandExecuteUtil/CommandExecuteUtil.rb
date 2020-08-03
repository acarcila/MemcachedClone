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
        if mapCommand["whitespace"] != value.size
          responseArray << "CLIENT_ERROR bad command line format"
          return responseArray
        end
        # executes the command by name
        commandResponse = cache.send(mapCommand["command"], key: mapCommand["keys"][0], value: value, ttl: mapCommand["ttl"], whitespace: mapCommand["whitespace"], flags: mapCommand["flags"])

        responseArray << (commandResponse ? "STORED" : "NOT_STORED")

        return responseArray
      end
      mapCommand["keys"].each do |key|
        puts "key"
        puts key
        commandResponse = cache.get(key)
        responseArray += itemToResponse(key, commandResponse)
      end
      responseArray << "END"

      return responseArray
    end

    responseArray << mapCommand["status"]
    return responseArray
  end
end
