require "socket"
require_relative "Controller/Util/CommandTranslateUtil/CommandTranslateUtil"
require_relative "Controller/Util/CommandExecuteUtil/CommandExecuteUtil"
require_relative "Controller/Util/CacheManagingUtil/CacheManagingUtil"
require_relative "Model/Cache/Cache"

exit if defined?(Ocra)
port = ARGV[0]

cache = Cache.new

server = TCPServer.new port

$stdout.sync = true

threads = []
tcpThread = Thread.new do
  puts ResponseConstants::SERVER_CONNECTED_TEMPLATE % port
  loop do
    Thread.start(server.accept) do |client|
      until client.eof?
        msg = (client.gets).strip
        mapCommand = CommandTranslateUtil.translateCommand(msg)
        unless mapCommand[CommandPartsConstants::COMMAND] =~ CommandConstants::GET_GETS_REGEX || mapCommand[CommandPartsConstants::STATUS] =~ ResponseConstants::ERROR_REGEX
          value = (client.gets).gsub(/\r\n/, "")
          until value.size >= mapCommand[CommandPartsConstants::WHITESPACE]
            value += "\r\n#{((client.gets).gsub(/\r\n/, ""))}"
          end
        end

        responseArray = CommandExecuteUtil.execute(mapCommand, cache, value)
        client.puts("#{responseArray.shift}\r\n") until responseArray.empty?
      end
    end
  end
end

cacheThread = CacheManagingUtil.startKeyManaging(cache)
threads = [tcpThread, cacheThread]

threads.each(&:join)

# def cleanString(string)
#   (string).gsub(/\r\n/, "")
# end
