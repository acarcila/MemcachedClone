require_relative "Cache"
require_relative "../Item/Item"
require_relative "../../Controller/Util/Constants/ResponseConstants"

RSpec.describe Item do
  it "GET: gets the item with the specified key" do
    cache = Cache.new()
    cache.memory["key"] = Item.new(value: "value", casToken: 1, whitespace: 5, ttl: 10)

    expect(cache.get("key").value).to eq("value")
    expect(cache.get("key").ttl).to eq(10)
    expect(cache.get("key").whitespace).to eq(5)
  end

  it "SET: adds an item with the specified key or replace the existent one" do
    cache = Cache.new()

    # test adding a new key
    cache.set(key: "key", value: "value", whitespace: 5, ttl: 10)

    expect(cache.memory["key"].value).to eq("value")
    expect(cache.memory["key"].ttl).to eq(10)
    expect(cache.memory["key"].whitespace).to eq(5)

    # test adding an existing key
    cache.memory["key2"] = Item.new(value: "value", casToken: 2, whitespace: 5, ttl: 20)

    expect(cache.set(key: "key2", value: "newValue", whitespace: 8, ttl: 10)).to eq(ResponseConstants::STORED)
    expect(cache.memory["key2"].value).to eq("newValue")
    expect(cache.memory["key2"].ttl).to eq(10)
    expect(cache.memory["key2"].whitespace).to eq(8)
  end

  it "ADD: adds an item with the specified key but fails if the key already exists" do
    cache = Cache.new()

    # test adding a new key
    cache.add(key: "key", value: "value", whitespace: 5, ttl: 10)

    expect(cache.memory["key"].value).to eq("value")
    expect(cache.memory["key"].ttl).to eq(10)
    expect(cache.memory["key"].whitespace).to eq(5)

    # test adding an existing key
    cache.memory["key2"] = Item.new(value: "value", casToken: 2, whitespace: 5, ttl: 20)

    expect(cache.add(key: "key2", value: "newValue", whitespace: 8, ttl: 10)).to eq(ResponseConstants::NOT_STORED)
    expect(cache.memory["key2"].value).to eq("value")
    expect(cache.memory["key2"].ttl).to eq(20)
    expect(cache.memory["key2"].whitespace).to eq(5)
  end

  it "REPLACE: replace an item with the specified key but fails if the key does not exists" do
    cache = Cache.new()

    # test replacing a new key
    expect(cache.replace(key: "key", value: "value", whitespace: 5, ttl: 10)).to eq(ResponseConstants::NOT_STORED)
    expect(cache.memory).to be_empty

    # test replacing an existing key
    cache.memory["key2"] = Item.new(value: "value", casToken: 2, whitespace: 5, ttl: 20)

    expect(cache.replace(key: "key2", value: "newValue", whitespace: 8, ttl: 10)).to eq(ResponseConstants::STORED)
    expect(cache.memory["key2"].value).to eq("newValue")
    expect(cache.memory["key2"].ttl).to eq(10)
    expect(cache.memory["key2"].whitespace).to eq(8)
  end

  it "APPEND: concats a string after the current value of the item" do
    cache = Cache.new()

    # test appending a new key
    expect(cache.append(key: "key", value: "value", whitespace: 5, ttl: 10)).to eq(ResponseConstants::NOT_STORED)
    expect(cache.memory).to be_empty

    # test appending an existing key
    cache.memory["key2"] = Item.new(value: "value", casToken: 2, whitespace: 5, ttl: 20)

    expect(cache.append(key: "key2", value: "append", whitespace: 6, ttl: 10)).to eq(ResponseConstants::STORED)
    expect(cache.memory["key2"].value).to eq("valueappend")
    expect(cache.memory["key2"].ttl).to eq(10)
    expect(cache.memory["key2"].whitespace).to eq(11)
  end

  it "PREPEND: concats a string before the current value of the item" do
    cache = Cache.new()

    # test prepending a new key
    expect(cache.prepend(key: "key", value: "value", whitespace: 5, ttl: 10)).to eq(ResponseConstants::NOT_STORED)
    expect(cache.memory).to be_empty

    # test prepending an existing key
    cache.memory["key2"] = Item.new(value: "value", casToken: 2, whitespace: 5, ttl: 20)

    expect(cache.prepend(key: "key2", value: "prepend", whitespace: 7, ttl: 10)).to eq(ResponseConstants::STORED)
    expect(cache.memory["key2"].value).to eq("prependvalue")
    expect(cache.memory["key2"].ttl).to eq(10)
    expect(cache.memory["key2"].whitespace).to eq(12)
  end

  it "CAS: replace an item with the specified key if the casToken match" do
    cache = Cache.new()

    # test replacing a new key
    expect(cache.cas(key: "key", value: "value", whitespace: 5, ttl: 10, casToken: 1)).to eq(ResponseConstants::NOT_FOUND)
    expect(cache.memory).to be_empty

    # test replacing an existing key
    cache.memory["key2"] = Item.new(value: "value", casToken: 2, whitespace: 5, ttl: 20)

    expect(cache.cas(key: "key2", value: "newValue", whitespace: 8, ttl: 10, casToken: 2)).to eq(ResponseConstants::STORED)
    expect(cache.memory["key2"].value).to eq("newValue")
    expect(cache.memory["key2"].ttl).to eq(10)
    expect(cache.memory["key2"].whitespace).to eq(8)

    # test when de casToken does not match
    cache.memory["key3"] = Item.new(value: "value", casToken: 5, whitespace: 5, ttl: 20)

    expect(cache.cas(key: "key3", value: "newValue", whitespace: 8, ttl: 10, casToken: 2)).to eq(ResponseConstants::EXISTS)
    expect(cache.memory["key3"].value).to eq("value")
    expect(cache.memory["key3"].ttl).to eq(20)
    expect(cache.memory["key3"].whitespace).to eq(5)
  end
end
