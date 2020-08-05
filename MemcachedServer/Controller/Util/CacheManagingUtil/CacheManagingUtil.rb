require_relative "../../../Model/Cache/Cache"
require_relative "../../../Model/Item/Item"

class CacheManagingUtil
  # creates a Thread that deletes the expired keys every second
  def CacheManagingUtil.createKeyManagingThread(cache)
    thread = Thread.new do
      while true
        cache.deleteExpiredKeys(currentTime: Time.now)
        sleep 1
      end
    end
  end
end
