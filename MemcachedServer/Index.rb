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
ipDirection = ARGV[0]
port = ARGV[1]

until (port =~ CommandConstants::INTEGER_REGEX && TCPUtil.checkPortAvailability(ipDirection, port))
  puts ResponseConstants::SELECT_IP_DIRECTION
  ipDirection = STDIN.gets.strip
  puts ResponseConstants::SELECT_PORT
  port = STDIN.gets.strip
end

cache = Cache.new

$stdout.sync = true

threads = []
tcpThread = TCPUtil.createTCPThread(ipDirection, port, lambda { |client|
  clientInput = client.gets
  clientInput = "" unless clientInput
  msg = clientInput.strip
  if msg == CommandConstants::QUIT
    client.close
    return true
  end
  mapCommand = CommandTranslateUtil.translateCommand(msg)
  unless mapCommand[CommandPartsConstants::COMMAND] =~ CommandConstants::GET_GETS_REGEX || mapCommand[CommandPartsConstants::STATUS] =~ ResponseConstants::ERROR_REGEX
    clientInput = client.gets
    clientInput = "" unless clientInput
    value = StringUtil.cleanString(clientInput)
    until value.size >= mapCommand[CommandPartsConstants::WHITESPACE]
      clientInput = client.gets
      clientInput = "" unless clientInput
      value += "\r\n#{StringUtil.cleanString(clientInput)}"
    end
  end

  responseArray = CommandExecuteUtil.execute(mapCommand, cache, value)
  client.puts("#{responseArray.shift}\r\n") until responseArray.empty?
  return false
})

cacheThread = CacheManagingUtil.createKeyManagingThread(cache)
threads = [tcpThread, cacheThread]

threads.each(&:join)
