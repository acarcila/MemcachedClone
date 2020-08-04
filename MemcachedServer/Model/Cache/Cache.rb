require_relative "../Item/Item"

class Cache
  @@casTokenCount = 0         #class variable
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
  def set(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    ttl ||= @memory[key].ttl if @memory[key]
    @memory[key] = Item.new(value: value, ttl: ttl, casToken: @@casTokenCount += 1, whitespace: whitespace, flags: flags)
    "STORED"
  end

  # adds an item with the specified key but fails if the key already exists
  def add(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    unless @memory[key]
      @memory[key] = Item.new(value: value, ttl: ttl, casToken: @@casTokenCount += 1, whitespace: whitespace, flags: flags)
      "STORED"
    else
      "NOT_STORED"
    end
  end

  # replace an item with the specified key but fails if the key does not exists
  def replace(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    ttl ||= @memory[key].ttl
    if @memory[key]
      @memory[key] = Item.new(value: value, ttl: ttl, casToken: @@casTokenCount += 1, whitespace: whitespace, flags: flags)
      "STORED"
    else
      "NOT_STORED"
    end
  end

  # concats a string after the current value of the item
  def append(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    if @memory[key]
      @memory[key].append(value: value, casToken: @@casTokenCount += 1, whitespace: whitespace, ttl: ttl, flags: flags)
      "STORED"
    else
      "NOT_STORED"
    end
  end

  # concats a string before the current value of the item
  def prepend(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0)
    if @memory[key]
      @memory[key].prepend(value: value, casToken: @@casTokenCount += 1, whitespace: whitespace, ttl: ttl, flags: flags)
      "STORED"
    else
      "NOT_STORED"
    end
  end

  # replace an item with the specified key but fails if the key does not exists
  def cas(key: nil, value: nil, ttl: nil, whitespace: 0, flags: 0, casToken: nil)
    ttl ||= @memory[key].ttl
    if @memory[key]
      if @memory[key].casToken == casToken
        @memory[key] = Item.new(value: value, ttl: ttl, casToken: @@casTokenCount += 1, whitespace: whitespace, flags: flags)
        return "STORED"
      end
      return "EXISTS"
    else
      return"NOT_FOUND"
    end
  end

  # delete the expired keys in the memory at a given time
  def deleteExpiredKeys(currentTime: Time.now)
    memory.delete_if { |key, item| currentTime > item.diesAt }
  end

  def to_s()
    @memory
  end
end
