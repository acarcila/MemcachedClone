require_relative "../Constants/CommandConstants"
require_relative "../Constants/CommandPartsConstants"
require_relative "../Constants/ResponseConstants"
require_relative "../StringUtil/StringUtil"
require_relative "../CommandTranslateUtil/CommandTranslateUtil"
require_relative "../CommandExecuteUtil/CommandExecuteUtil"
require_relative "../../../Model/Cache/Cache"

class TCPUtil
  def TCPUtil.checkPortAvailability(ipDirection, port)
    begin
      checkServer = TCPServer.new(ipDirection, port)
      checkServer.close
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      return false
    end

    return true
  end

  # creates a tcp Thread that
  def TCPUtil.createTCPThread(ipDirection, port, lambdaFunction)
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
            isDisconnectClient = lambdaFunction.call(client)

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
