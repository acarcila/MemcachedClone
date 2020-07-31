require "socket"
require_relative "Model/Item/Item"
require_relative "Model/Cache/Cache"

cache = Cache.new
puts cache.set("prueba", 12)
puts cache.get("prueba")
puts cache.add("prueba2", 13, 10)
puts cache.add("prueba2", 15, 10)
puts cache.get("prueba2")
puts cache.replace("prueba2", 15)
puts cache.set("prueba2", 18)
puts cache.get("prueba2")
puts cache.to_s

server = TCPServer.new 3000

$stdout.sync = true

data = Hash.new

threads = []
tcpThread = Thread.new do
  loop do
    Thread.start(server.accept) do |client|
      client.puts("conectado")
      until client.eof?
        msg = client.gets
        data[msg] = msg
        client.write(data)
        puts data
        # client.close
      end
    end
  end
end

cacheThread = cache.startKeyManaging
threads = [tcpThread, cacheThread]

threads.each(&:join)
