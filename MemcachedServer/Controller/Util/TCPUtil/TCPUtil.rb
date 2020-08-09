require "socket"
require_relative "../Constants/CommandConstants"
require_relative "../Constants/CommandPartsConstants"
require_relative "../Constants/ResponseConstants"
require_relative "../StringUtil/StringUtil"
require_relative "../CommandTranslateUtil/CommandTranslateUtil"
require_relative "../CommandExecuteUtil/CommandExecuteUtil"
require_relative "../../../Model/Cache/Cache"

class TCPUtil
  # Returns an available ipDirection and port selected in the command line
  def TCPUtil.getIPAndPort()
    ipDirection = ARGV[0]
    port = ARGV[1]

    until (port =~ CommandConstants::INTEGER_REGEX && TCPUtil.checkPortAvailability(ipDirection, port))
      puts ResponseConstants::SELECT_IP_DIRECTION
      ipDirection = STDIN.gets.strip
      puts ResponseConstants::SELECT_PORT
      port = STDIN.gets.strip
    end

    return ipDirection, port
  end

  # Checks if the given port of the given ipDirection is available
  def TCPUtil.checkPortAvailability(ipDirection, port)
    begin
      checkServer = TCPServer.new(ipDirection, port)
      checkServer.close
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::EACCES, SocketError
      return false
    end

    return true
  end

  # Receives and processes the commands given by the client
  def TCPUtil.processClientFile(client, cache)
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
  end

  # creates a tcp Thread that listen to multiple clients
  def TCPUtil.createTCPThread(ipDirection, port, cache)
    server = TCPServer.new(ipDirection, port)
    puts ResponseConstants::SERVER_CONNECTED_TEMPLATE % [ipDirection, port]
    thread = Thread.new do
      loop do
        Thread.start(server.accept) do |client|
          clientData = client.peeraddr
          clientPort = clientData[1]
          clientIP = clientData[3]
          puts ResponseConstants::CLIENT_CONNECTED_TEMPLATE % [clientIP, clientPort]

          isDisconnectClient = false
          until isDisconnectClient
            isDisconnectClient = processClientFile(client, cache)

            begin
              isDisconnectClient |= client.eof? unless isDisconnectClient
            rescue Errno::ECONNABORTED
              isDisconnectClient = true
            end
          end
          puts ResponseConstants::CLIENT_DISCONNECTED_TEMPLATE % [clientIP, clientPort]
        end
      end
    end
  end
end
