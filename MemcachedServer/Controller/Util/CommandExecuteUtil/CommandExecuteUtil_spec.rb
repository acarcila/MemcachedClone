require_relative "CommandExecuteUtil"
require_relative "../CommandTranslateUtil/CommandTranslateUtil"
require_relative "../../../Model/Cache/Cache"

RSpec.describe CommandExecuteUtil do
  it "executes the SET command" do
    cache = Cache.new
    commandString = "set key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xo")

    expect(responseArray[0]).to eq("STORED")
    expect(cache.get("key").value).to eq("xo")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(2)
  end

  it "executes the ADD command" do
    cache = Cache.new
    commandString = "add key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xo")

    expect(responseArray[0]).to eq("STORED")
    expect(cache.get("key").value).to eq("xo")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(2)
  end

  it "executes the REPLACE command" do
    cache = Cache.new
    cache.set(key: "key", value: 10, ttl: 3, whitespace: 2)
    commandString = "replace key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xo")

    expect(responseArray[0]).to eq("STORED")
    expect(cache.get("key").value).to eq("xo")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(2)
  end

  it "executes the APPEND command" do
    cache = Cache.new
    cache.set(key: "key", value: 10, ttl: 3, whitespace: 2)
    commandString = "append key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xo")

    expect(responseArray[0]).to eq("STORED")
    expect(cache.get("key").value).to eq("10xo")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(4)
  end

  it "executes the PREPEND command" do
    cache = Cache.new
    cache.set(key: "key", value: 10, ttl: 3, whitespace: 2)
    commandString = "prepend key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xo")

    expect(responseArray[0]).to eq("STORED")
    expect(cache.get("key").value).to eq("xo10")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(4)
  end

  it "executes the GET command" do
    cache = Cache.new
    cache.set(key: "key", value: 10, ttl: 3, whitespace: 2)
    cache.set(key: "key2", value: 200, ttl: 6, whitespace: 3)
    commandString = "get key key2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache)

    expect(responseArray[0]).to eq("VALUE key 0 2")
    expect(responseArray[1]).to eq("10")
    expect(responseArray[2]).to eq("VALUE key2 0 3")
    expect(responseArray[3]).to eq("200")
    expect(responseArray[4]).to eq("END")
  end

  it "executes a 'bad data chunk' CLIENT_ERROR" do
    cache = Cache.new
    commandString = "add key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xox")    # value whitespace (3) exceeds the given whitespace (2)

    expect(responseArray[0]).to eq("CLIENT_ERROR bad data chunk")
  end

  it "executes an ERROR" do
    cache = Cache.new
    commandString = "set 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache)

    expect(responseArray[0]).to eq("ERROR")
  end

  it "executes a NOT_STORED" do
    cache = Cache.new
    commandString = "replace key 0 3600 2"  # replace must not get stored as the key does not exist yet
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xo")

    expect(responseArray[0]).to eq("NOT_STORED")
  end
end
