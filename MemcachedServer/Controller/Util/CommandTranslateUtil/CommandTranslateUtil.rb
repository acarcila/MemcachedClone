require_relative "../Constants/CommandConstants"
require_relative "../Constants/CommandPartsConstants"

class CommandTranslateUtil
  def CommandTranslateUtil.splitString(command)
    command.split
  end

  def CommandTranslateUtil.getCommand(array)
    command = array.shift
    map = Hash.new
    if command =~ CommandConstants::VALID_COMMAND_REGEX
      map[CommandPartsConstants::COMMAND] = command
    else
      map[CommandPartsConstants::STATUS] = ResponseConstants::ERROR
    end

    map
  end

  def CommandTranslateUtil.getParams(array)
    map = Hash.new

    whitespace = array.pop
    ttl = array.pop
    flags = array.pop

    if whitespace =~ CommandConstants::INTEGER_REGEX
      map[CommandPartsConstants::WHITESPACE] = whitespace.to_i
    else
      map[CommandPartsConstants::STATUS] = ResponseConstants::ERROR
    end

    if ttl =~ CommandConstants::INTEGER_REGEX
      map[CommandPartsConstants::TTL] = ttl.to_i
    else
      map[CommandPartsConstants::STATUS] = ResponseConstants::ERROR
    end

    if flags =~ CommandConstants::INTEGER_REGEX
      map[CommandPartsConstants::FLAGS] = flags.to_i
    else
      map[CommandPartsConstants::STATUS] = ResponseConstants::ERROR
    end

    map
  end

  def CommandTranslateUtil.getCasParams(array)
    map = Hash.new

    casToken = array.pop
    if casToken =~ CommandConstants::INTEGER_REGEX
      map[CommandPartsConstants::CASTOKEN] = casToken.to_i
    else
      map[CommandPartsConstants::STATUS] = ResponseConstants::ERROR
    end
    map
  end

  def CommandTranslateUtil.getKeys(array)
    map = Hash.new

    if array.length == 1
      map[CommandPartsConstants::KEYS] = array
    elsif array.length < 1
      map[CommandPartsConstants::STATUS] = ResponseConstants::ERROR
    else
      map[CommandPartsConstants::STATUS] = ResponseConstants::CLIENT_ERROR
      map[CommandPartsConstants::ERROR] = ResponseConstants::LINE_FORMAT_ERROR
    end

    map
  end

  def CommandTranslateUtil.getGetsKeys(array)
    map = Hash.new

    unless array.length < 1
      map[CommandPartsConstants::KEYS] = array
    else
      map[CommandPartsConstants::STATUS] = ResponseConstants::ERROR
    end
    map
  end

  def CommandTranslateUtil.ifNotGet(map, lambda, lambdaElse = nil)
    unless map[CommandPartsConstants::STATUS] =~ ResponseConstants::ERROR_REGEX
      if map[CommandPartsConstants::COMMAND] =~ CommandConstants::NOT_GET_REGEX
        lambda.call
      elsif lambdaElse
        lambdaElse.call
      end
    else
      return map
    end
  end

  def CommandTranslateUtil.translateCommand(command)
    array = splitString(command)

    map = getCommand(array)

    CommandTranslateUtil.ifNotGet(map, lambda {
      if map[CommandPartsConstants::COMMAND] == CommandConstants::CAS
        map = map.merge(getCasParams(array))
      end
      map = map.merge(getParams(array))
    })

    CommandTranslateUtil.ifNotGet(map, lambda {
      map = map.merge(getKeys(array))
    }, lambda {
      map = map.merge(getGetsKeys(array))
    })

    map
  end
end
