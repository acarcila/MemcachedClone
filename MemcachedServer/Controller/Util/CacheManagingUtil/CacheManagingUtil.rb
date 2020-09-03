require_relative "../../../Model/Cache/Cache"

class CacheManagingUtil
  # creates a Thread that deletes the expired keys every second
  def CacheManagingUtil.createKeyManagingThread(cache, timeToCheck)
    thread = Thread.new do
      while true
        cache.deleteExpiredKeys(currentTime: Time.now)
        sleep timeToCheck
      end
    end
  end
end
