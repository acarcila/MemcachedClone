require "socket"
require_relative "Controller/Util/Constants/CommandConstants"
require_relative "Controller/Util/Constants/CommandPartsConstants"
require_relative "Controller/Util/Constants/ResponseConstants"
require_relative "Controller/Util/CommandTranslateUtil/CommandTranslateUtil"
require_relative "Controller/Util/CommandExecuteUtil/CommandExecuteUtil"
require_relative "Controller/Util/CacheManagingUtil/CacheManagingUtil"
require_relative "Controller/Util/TCPUtil/TCPUtil"
require_relative "Model/Cache/Cache"

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

tcpThread = TCPUtil.createTCPThread(ipDirection, port, cache)
cacheThread = CacheManagingUtil.createKeyManagingThread(cache)

threads = [tcpThread, cacheThread]

threads.each(&:join)
