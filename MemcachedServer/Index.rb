require "socket"
require_relative "Controller/Util/CommandTranslateUtil/CommandTranslateUtil"
require_relative "Controller/Util/CommandExecuteUtil/CommandExecuteUtil"
require_relative "Controller/Util/CacheManagingUtil/CacheManagingUtil"
require_relative "Model/Cache/Cache"

exit if defined?(Ocra)
port = ARGV[0]

cache = Cache.new
puts cache.set(key: "prueba", value: 12, ttl: 3, whitespace: 2)
puts cache.get("prueba")
puts cache.add(key: "prueba2", value: 124, ttl: 5, whitespace: 3)
puts cache.add(key: "prueba2", value: 15, ttl: 7, whitespace: 2)
puts cache.get("prueba2")
puts cache.replace(key: "prueba2", value: 1004, ttl: 4, whitespace: 4)

server = TCPServer.new port

$stdout.sync = true

threads = []
tcpThread = Thread.new do
  loop do
    Thread.start(server.accept) do |client|
      client.puts("conectado")
      until client.eof?
        msg = (client.gets).strip
        mapCommand = CommandTranslateUtil.translateCommand(msg)
        unless mapCommand[CommandPartsConstants::COMMAND] =~ CommandConstants::GET_GETS_REGEX || mapCommand[CommandPartsConstants::STATUS] =~ ResponseConstants::ERROR_REGEX
          value = (client.gets).strip
          until value.size >= mapCommand[CommandPartsConstants::WHITESPACE]
            value += "\r\n#{((client.gets).strip)}"
          end
        end

        responseArray = CommandExecuteUtil.execute(mapCommand, cache, value)
        client.puts("#{responseArray.shift}\r\n") until responseArray.empty?

        puts msg
        puts "#{value}"
        puts cache.to_s
        # client.close
      end
    end
  end
end

cacheThread = CacheManagingUtil.startKeyManaging(cache)
threads = [tcpThread, cacheThread]

threads.each(&:join)
