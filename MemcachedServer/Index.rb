require "socket"
require_relative "Model/Item"
require_relative "Model/Cache"

cache = Cache.new
puts cache.set("prueba", 12)
puts cache.get("prueba")
puts cache.add("prueba2", 13, 3600)
puts cache.add("prueba2", 15, 3600)
puts cache.get("prueba2")
puts cache.replace("prueba2", 15)
puts cache.set("prueba2", 18)
puts cache.get("prueba2")
puts cache.to_s

server = TCPServer.new 2000

$stdout.sync = true

data = Hash.new

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
