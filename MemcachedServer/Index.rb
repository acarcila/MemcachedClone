require "socket"
require_relative "Controller/Util/Constants/CommandConstants"
require_relative "Controller/Util/Constants/CommandPartsConstants"
require_relative "Controller/Util/Constants/ResponseConstants"
require_relative "Controller/Util/CommandTranslateUtil/CommandTranslateUtil"
require_relative "Controller/Util/CommandExecuteUtil/CommandExecuteUtil"
require_relative "Controller/Util/CacheManagingUtil/CacheManagingUtil"
require_relative "Controller/Util/TCPUtil/TCPUtil"
require_relative "Model/Cache/Cache"

exit if defined?(Ocra)
port = ARGV[0]

until (port =~ CommandConstants::INTEGER_REGEX && TCPUtil.checkPortAvailability(port))
  puts ResponseConstants::SELECT_PORT
  port = STDIN.gets.strip
end

cache = Cache.new

$stdout.sync = true

threads = []
tcpThread = TCPUtil.createTCPThread(port, lambda { |client|
  msg = (client.gets).strip
  if msg == CommandConstants::QUIT
    client.close
    return true
  end
  mapCommand = CommandTranslateUtil.translateCommand(msg)
  unless mapCommand[CommandPartsConstants::COMMAND] =~ CommandConstants::GET_GETS_REGEX || mapCommand[CommandPartsConstants::STATUS] =~ ResponseConstants::ERROR_REGEX
    value = StringUtil.cleanString(client.gets)
    until value.size >= mapCommand[CommandPartsConstants::WHITESPACE]
      value += "\r\n#{StringUtil.cleanString(client.gets)}"
    end
  end

  responseArray = CommandExecuteUtil.execute(mapCommand, cache, value)
  client.puts("#{responseArray.shift}\r\n") until responseArray.empty?
  return false
})

cacheThread = CacheManagingUtil.createKeyManagingThread(cache)
threads = [tcpThread, cacheThread]

threads.each(&:join)
