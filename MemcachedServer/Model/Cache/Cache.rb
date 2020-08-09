require_relative "../Item/Item"
require_relative "../../Controller/Util/Constants/ResponseConstants"

class Cache
  @@casTokenCount = 0         #class variable
  attr_reader :memory         # getters

  def initialize()
    @memory = Hash.new
  end

  # Gets the item with the specified key
  def get(key)
    if @memory[key]
      @memory[key]
    else
      false
    end
  end

  # Adds an item with the specified key or replace the existent one
  def set(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    ttl ||= @memory[key].ttl if @memory[key]
    @memory[key] = Item.new(value: value, ttl: ttl, casToken: @@casTokenCount += 1, whitespace: whitespace, flags: flags)
    ResponseConstants::STORED
  end

  # Adds an item with the specified key but fails if the key already exists
  def add(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    unless @memory[key]
      @memory[key] = Item.new(value: value, ttl: ttl, casToken: @@casTokenCount += 1, whitespace: whitespace, flags: flags)
      ResponseConstants::STORED
    else
      ResponseConstants::NOT_STORED
    end
  end

  # Replace an item with the specified key but fails if the key does not exists
  def replace(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    ttl ||= @memory[key].ttl
    if @memory[key]
      @memory[key] = Item.new(value: value, ttl: ttl, casToken: @@casTokenCount += 1, whitespace: whitespace, flags: flags)
      ResponseConstants::STORED
    else
      ResponseConstants::NOT_STORED
    end
  end

  # Concats a string after the current value of the item
  def append(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    if @memory[key]
      @memory[key].append(value: value, casToken: @@casTokenCount += 1, whitespace: whitespace, ttl: ttl, flags: flags)
      ResponseConstants::STORED
    else
      ResponseConstants::NOT_STORED
    end
  end

  # Concats a string before the current value of the item
  def prepend(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    if @memory[key]
      @memory[key].prepend(value: value, casToken: @@casTokenCount += 1, whitespace: whitespace, ttl: ttl, flags: flags)
      ResponseConstants::STORED
    else
      ResponseConstants::NOT_STORED
    end
  end

  # Replace an item with the specified key but fails if the key does not exists
  def cas(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0, casToken: nil)
    ttl ||= @memory[key].ttl
    if @memory[key]
      if @memory[key].casToken == casToken
        @memory[key] = Item.new(value: value, ttl: ttl, casToken: @@casTokenCount += 1, whitespace: whitespace, flags: flags)
        return ResponseConstants::STORED
      end
      return ResponseConstants::EXISTS
    else
      return ResponseConstants::NOT_FOUND
    end
  end

  # Delete the expired keys in the memory at a given time
  def deleteExpiredKeys(currentTime: Time.now)
    memory.delete_if { |key, item| currentTime > item.diesAt }
  end

  def to_s()
    @memory
  end
end
