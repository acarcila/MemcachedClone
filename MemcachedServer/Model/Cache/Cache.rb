require_relative "../Item/Item"

class Cache
  attr_reader :memory         # getters

  def initialize()
    @memory = Hash.new
  end

  # gets the item with the specified key
  def get(key)
    if @memory[key]
      @memory[key]
    else
      false
    end
  end

  # adds an item with the specified key or replace the existent one
  def set(key, value, ttl = nil)
    ttl ||= @memory[key].ttl if @memory[key]
    @memory[key] = Item.new(value, *ttl)
  end

  # adds an item with the specified key but fails if the key already exists
  def add(key, value, *ttl)
    unless @memory[key]
      @memory[key] = Item.new(value, *ttl)
    else
      false
    end
  end

  # replace an item with the specified key but fails if the key does not exists
  def replace(key, value, ttl = nil)
    ttl ||= @memory[key].ttl
    if @memory[key]
      @memory[key] = Item.new(value, *ttl)
    else
      false
    end
  end

  # concats a string after the current value of the item
  def append(key, value)
    if @memory[key]
      @memory[key].append(value)
    else
      false
    end
  end

  # concats a string before the current value of the item
  def prepend(key, value)
    if @memory[key]
      @memory[key].prepend(value)
    else
      false
    end
  end

  # delete the expired keys in the memory at a given time
  def deleteExpiredKeys(currentTime = Time.now)
    memory.delete_if { |key, item| currentTime > item.diesAt }
  end

  def to_s()
    @memory
  end
end
