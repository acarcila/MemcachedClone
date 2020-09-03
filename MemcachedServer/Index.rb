require_relative "Controller/Util/CacheManagingUtil/CacheManagingUtil"
require_relative "Controller/Util/TCPUtil/TCPUtil"
require_relative "Model/Cache/Cache"

ipDirection, port = TCPUtil.getIPAndPort

cache = Cache.new

$stdout.sync = true

threads = []

tcpThread = TCPUtil.createTCPThread(ipDirection, port, cache)
cacheThread = CacheManagingUtil.createKeyManagingThread(cache, 3600)

threads = [tcpThread, cacheThread]

msg = ""
until (msg == CommandConstants::QUIT)
  msg = STDIN.gets.strip
end
exit(true) if msg == CommandConstants::QUIT

threads.each(&:join)
