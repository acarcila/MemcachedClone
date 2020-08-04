class CommandTranslateUtil
  def CommandTranslateUtil.splitString(command)
    command.split
  end

  def CommandTranslateUtil.getCommand(array)
    command = array.shift
    map = Hash.new
    if command =~ /(set|add|replace|append|prepend|cas|(g(e|a)t(s|)))\b/
      map["command"] = command
    else
      map["status"] = "ERROR"
    end

    map
  end

  def CommandTranslateUtil.getParams(array)
    map = Hash.new

    whitespace = array.pop
    ttl = array.pop
    flags = array.pop

    if whitespace =~ /\d+/
      map["whitespace"] = whitespace.to_i
    else
      map["status"] = "ERROR"
    end

    if ttl =~ /\d+/
      map["ttl"] = ttl.to_i
    else
      map["status"] = "ERROR"
    end

    if flags =~ /\d+/
      map["flags"] = flags.to_i
    else
      map["status"] = "ERROR"
    end

    map
  end

  def CommandTranslateUtil.getCasParams(array)
    map = Hash.new

    casToken = array.pop
    if casToken =~ /\d+/
      map["casToken"] = casToken.to_i
    else
      map["status"] = "ERROR"
    end
    map
  end

  def CommandTranslateUtil.getKeys(array)
    map = Hash.new

    if array.length == 1
      map["keys"] = array
    elsif array.length < 1
      map["status"] = "ERROR"
    else
      map["status"] = "CLIENT_ERROR"
      map["error"] = "bad command line format"
    end

    map
  end

  def CommandTranslateUtil.getGetsKeys(array)
    map = Hash.new

    unless array.length < 1
      map["keys"] = array
    else
      map["status"] = "ERROR"
    end
    map
  end

  def CommandTranslateUtil.ifNotGet(map, proc, procElse = nil)
    unless map["status"] == "ERROR"
      if map["command"] =~ /set|add|replace|append|prepend|cas\b/
        proc.call
      elsif procElse
        procElse.call
      end
    else
      return map
    end
  end

  def CommandTranslateUtil.translateCommand(command)
    array = splitString(command)

    map = getCommand(array)

    CommandTranslateUtil.ifNotGet(map, Proc.new do
      if map["command"] == "cas"
        map = map.merge(getCasParams(array))
      end
      map = map.merge(getParams(array))
    end)

    CommandTranslateUtil.ifNotGet(map, Proc.new do
      map = map.merge(getKeys(array))
    end, Proc.new do
      map = map.merge(getGetsKeys(array))
    end)

    map
  end
end
