require_relative "../../../Model/Cache/Cache"
require_relative "../Constants/CommandPartsConstants"
require_relative "../Constants/CommandConstants"
require_relative "../Constants/ResponseConstants"

class CommandExecuteUtil
  def CommandExecuteUtil.checkStatus(commandResponse, mapCommand)
  end

  def CommandExecuteUtil.itemToResponse(key, item)
    response = []
    if item
      response << ResponseConstants::ITEM_TEMPLATE % [key, item.flags, item.whitespace]
      response << ResponseConstants::VALUE_TEMPLATE % item.value
    end

    response
  end

  def CommandExecuteUtil.itemToGetsResponse(key, item)
    response = []
    if item
      response << ResponseConstants::ITEM_CAS_TEMPLATE % [key, item.flags, item.whitespace, item.casToken]
      response << ResponseConstants::VALUE_TEMPLATE % item.value
    end

    response
  end

  def CommandExecuteUtil.errorToResponse(status, error = nil)
    response = []
    response << (ResponseConstants::ERROR_TEMPLATE % [status, error]).strip

    response
  end

  def CommandExecuteUtil.execute(mapCommand, cache, value = nil)
    responseArray = Array.new
    commandResponse = nil
    unless mapCommand[CommandPartsConstants::STATUS]
      if mapCommand[CommandPartsConstants::COMMAND] =~ CommandConstants::NOT_GET_REGEX
        if mapCommand[CommandPartsConstants::WHITESPACE] != value.size
          responseArray << "#{ResponseConstants::CLIENT_ERROR} #{ResponseConstants::BAD_DATA_ERROR}"
          return responseArray
        end
        # executes the command by name
        unless mapCommand[CommandPartsConstants::COMMAND] == CommandConstants::CAS
          commandResponse = cache.send(
            mapCommand[CommandPartsConstants::COMMAND],
            key: mapCommand[CommandPartsConstants::KEYS][0],
            value: value,
            ttl: mapCommand[CommandPartsConstants::TTL],
            whitespace: mapCommand[CommandPartsConstants::WHITESPACE],
            flags: mapCommand[CommandPartsConstants::FLAGS],
          )
        else
          commandResponse = cache.send(
            mapCommand[CommandPartsConstants::COMMAND],
            key: mapCommand[CommandPartsConstants::KEYS][0],
            value: value,
            ttl: mapCommand[CommandPartsConstants::TTL],
            whitespace: mapCommand[CommandPartsConstants::WHITESPACE],
            flags: mapCommand[CommandPartsConstants::FLAGS],
            casToken: mapCommand[CommandPartsConstants::CAS_TOKEN],
          )
        end

        responseArray << commandResponse

        return responseArray
      elsif mapCommand[CommandPartsConstants::COMMAND] == CommandConstants::GET
        mapCommand[CommandPartsConstants::KEYS].each do |key|
          commandResponse = cache.get(key)
          responseArray += itemToResponse(key, commandResponse)
        end
      else
        mapCommand[CommandPartsConstants::KEYS].each do |key|
          commandResponse = cache.get(key)
          responseArray += itemToGetsResponse(key, commandResponse)
        end
      end
      responseArray << ResponseConstants::END_

      return responseArray
    end

    responseArray += errorToResponse(mapCommand[CommandPartsConstants::STATUS], *mapCommand[CommandPartsConstants::ERROR])
    return responseArray
  end
end
