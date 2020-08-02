require_relative "../../../Model/Cache/Cache"
require_relative "../../../Model/Item/Item"

class CacheManagingUtil
  # creates a Thread that deletes the expired keys every second
  def CacheManagingUtil.startKeyManaging(cache)
    thread = Thread.new do
      while true
        deleteExpiredKeys(cache, Time.now)
        puts cache.to_s
        sleep 1
      end
    end
  end

  private

  # delete the expired keys in the hash at the current time
  def CacheManagingUtil.deleteExpiredKeys(cache, currentTime = Time.now)
    cache.hash.delete_if { |key, item| currentTime > item.diesAt }
  end
end
