require_relative "../Item/Item"

class Cache
  attr_reader :hash         # getters

  def initialize()
    @hash = Hash.new
  end

  # gets the item with the specified key
  def get(key)
    if @hash[key]
      @hash[key]
    else
      false
    end
  end

  # adds an item with the specified key or replace the existent one
  def set(key, value, ttl = nil)
    ttl ||= @hash[key].ttl if @hash[key]
    @hash[key] = Item.new(value, *ttl)
  end

  # adds an item with the specified key but fails if the key already exists
  def add(key, value, *ttl)
    unless @hash[key]
      @hash[key] = Item.new(value, *ttl)
    else
      false
    end
  end

  # replace an item with the specified key but fails if the key does not exists
  def replace(key, value, ttl = nil)
    ttl ||= @hash[key].ttl
    if @hash[key]
      @hash[key] = Item.new(value, *ttl)
    else
      false
    end
  end

  # concats a string after the current value of the item
  def append(key, value)
    if @hash[key]
      @hash[key].append(value)
    else
      false
    end
  end

  # concats a string before the current value of the item
  def prepend(key, value)
    if @hash[key]
      @hash[key].prepend(value)
    else
      false
    end
  end

  def to_s()
    @hash
  end
end
