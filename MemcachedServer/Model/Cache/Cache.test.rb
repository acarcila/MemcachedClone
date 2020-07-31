require "rspec/autorun"
require_relative "Cache"
require_relative "../Item/Item"

describe Item do
  it "GET: gets the item with the specified key" do
    cache = Cache.new()
    cache.hash["key"] = Item.new("value", 10)

    expect(cache.get("key").value).to eq("value")
    expect(cache.get("key").ttl).to eq(10)
  end

  it "SET: adds an item with the specified key or replace the existent one" do
    cache = Cache.new()

    # test adding a new key
    cache.set("key", "value", 10)

    expect(cache.hash["key"].value).to eq("value")
    expect(cache.hash["key"].ttl).to eq(10)

    # test adding an existing key
    cache.set("key", "newValue")

    expect(cache.hash["key"].value).to eq("newValue")
    expect(cache.hash["key"].ttl).to eq(10)
  end

  it "ADD: adds an item with the specified key but fails if the key already exists" do
    cache = Cache.new()

    # test adding a new key
    cache.add("key", "value", 10)

    expect(cache.hash["key"].value).to eq("value")
    expect(cache.hash["key"].ttl).to eq(10)

    # test adding an existing key
    cache.hash["key2"] = Item.new("value", 10)

    expect(cache.add("key2", "newValue", 20)).to eq(false)
    expect(cache.hash["key2"].value).not_to eq("newValue")
    expect(cache.hash["key2"].ttl).not_to eq(20)
  end

  it "REPLACE: replace an item with the specified key but fails if the key does not exists" do
    cache = Cache.new()

    # test replacing a new key
    expect(cache.replace("key", "value", 10)).to eq(false)
    expect(cache.hash).to be_empty

    # test replacing an existing key
    cache.hash["key2"] = Item.new("value", 10)

    expect(cache.replace("key2", "newValue", 20)).not_to eq(false)
    expect(cache.hash["key2"].value).to eq("newValue")
    expect(cache.hash["key2"].ttl).to eq(20)
  end

  it "APPEND: concats a string after the current value of the item" do
    cache = Cache.new()

    # test appending a new key
    expect(cache.append("key", "value")).to eq(false)
    expect(cache.hash).to be_empty

    # test appending an existing key
    cache.hash["key2"] = Item.new("value", 10)

    expect(cache.append("key2", "append")).not_to eq(false)
    expect(cache.hash["key2"].value).to eq("valueappend")
  end

  it "PREPEND: concats a string before the current value of the item" do
    cache = Cache.new()

    # test prepending a new key
    expect(cache.prepend("key", "value")).to eq(false)
    expect(cache.hash).to be_empty

    # test prepending an existing key
    cache.hash["key2"] = Item.new("value", 10)

    expect(cache.prepend("key2", "prepend")).not_to eq(false)
    expect(cache.hash["key2"].value).to eq("prependvalue")
  end
end
