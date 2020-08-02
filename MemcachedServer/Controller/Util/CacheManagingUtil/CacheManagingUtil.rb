require_relative "../../../Model/Cache/Cache"
require_relative "../../../Model/Item/Item"

class CacheManagingUtil
  # creates a Thread that deletes the expired keys every second
  def CacheManagingUtil.startKeyManaging(cache)
    thread = Thread.new do
      while true
        cache.deleteExpiredKeys(Time.now)
        puts cache.to_s
        sleep 1
      end
    end
  end
end
