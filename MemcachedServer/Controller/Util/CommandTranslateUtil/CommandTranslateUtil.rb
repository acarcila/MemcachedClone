class CommandTranslateUtil
  def CommandTranslateUtil.splitString(command)
    command.split
  end

  def CommandTranslateUtil.getCommand(array)
    command = array.shift
    hash = Hash.new
    if command =~ /(set|add|replace|append|prepend|cas|(g(e|a)t(s|)))/
      hash["command"] = command
    else
      hash["output"] = "ERROR"
    end

    hash
  end

  def CommandTranslateUtil.getParams(array)
    hash = Hash.new

    whitespace = array.pop
    ttl = array.pop
    flags = array.pop

    if whitespace =~ /\d+/
      hash["whitespace"] = whitespace.to_i
    else
      hash["output"] = "ERROR"
    end

    if ttl =~ /\d+/
      hash["ttl"] = ttl.to_i
    else
      hash["output"] = "ERROR"
    end

    if flags =~ /\d+/
      hash["flags"] = flags.to_i
    else
      hash["output"] = "ERROR"
    end

    hash
  end

  def CommandTranslateUtil.getCasParams(array)
    hash = Hash.new

    casToken = array.pop
    hash["casToken"] = casToken
    hash
  end

  def CommandTranslateUtil.getKeys(array)
    hash = Hash.new

    if array.length == 1
      hash["keys"] = array
    elsif array.length < 1
      hash["output"] = "ERROR"
    else
      hash["output"] = "CLIENT_ERROR bad command line format"
    end

    hash
  end

  def CommandTranslateUtil.getGetsKeys(array)
    hash = Hash.new

    unless array.empty?
      hash["keys"] = array
    else
      hash["output"] = "ERROR"
    end

    hash
  end

  def CommandTranslateUtil.translateCommand(command)
    array = splitString(command)

    hash = getCommand(array)

    unless hash["output"] =~ /ERROR|CLIENT_ERROR bad command line format/
      if hash["command"] =~ /set|add|replace|append|prepend|cas/
        if hash["command"] == "cas"
          hash = hash.merge(getCasParams(array))
        end
        hash = hash.merge(getParams(array))
      end
    else
      return hash
    end

    unless hash["output"] =~ /ERROR|CLIENT_ERROR bad command line format/
      if hash["command"] =~ /set|add|replace|append|prepend|cas/
        hash = hash.merge(getKeys(array))
      else
        hash = hash.merge(getGetsKeys(array))
      end
    else
      return hash
    end

    hash
  end
end
