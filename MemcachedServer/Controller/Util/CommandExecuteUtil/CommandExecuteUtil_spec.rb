require_relative "CommandExecuteUtil"
require_relative "../CommandTranslateUtil/CommandTranslateUtil"
require_relative "../Constants/ResponseConstants"
require_relative "../../../Model/Cache/Cache"
require_relative "../../../Model/Item/Item"

RSpec.describe CommandExecuteUtil do
  it "executes the SET command" do
    cache = Cache.new
    commandString = "set key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xx")

    expect(responseArray[0]).to eq(ResponseConstants::STORED)
    expect(cache.get("key").value).to eq("xx")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(2)
  end

  it "executes the ADD command" do
    cache = Cache.new
    commandString = "add key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xx")

    expect(responseArray[0]).to eq(ResponseConstants::STORED)
    expect(cache.get("key").value).to eq("xx")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(2)

    # when the key already exists
    commandString2 = "add key 0 200 3"
    mapCommand2 = CommandTranslateUtil.translateCommand(commandString2)
    responseArray2 = CommandExecuteUtil.execute(mapCommand2, cache, "ooo")

    expect(responseArray2[0]).to eq(ResponseConstants::NOT_STORED)
    expect(cache.get("key").value).to eq("xx")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(2)
  end

  it "executes the REPLACE command" do
    cache = Cache.new
    cache.set(key: "key", value: "xx", ttl: 3, whitespace: 2)
    commandString = "replace key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "oo")

    expect(responseArray[0]).to eq(ResponseConstants::STORED)
    expect(cache.get("key").value).to eq("oo")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(2)

    # when the key does not exists
    commandString2 = "replace key2 0 200 3"
    mapCommand2 = CommandTranslateUtil.translateCommand(commandString2)
    responseArray2 = CommandExecuteUtil.execute(mapCommand2, cache, "ooo")

    expect(responseArray2[0]).to eq(ResponseConstants::NOT_STORED)
    expect(cache.get("key2")).to eq(false)
  end

  it "executes the APPEND command" do
    cache = Cache.new
    cache.set(key: "key", value: "xx", ttl: 3, whitespace: 2)
    commandString = "append key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "oo")

    expect(responseArray[0]).to eq(ResponseConstants::STORED)
    expect(cache.get("key").value).to eq("xxoo")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(4)

    # when the key does not exists
    commandString2 = "append key2 0 200 3"
    mapCommand2 = CommandTranslateUtil.translateCommand(commandString2)
    responseArray2 = CommandExecuteUtil.execute(mapCommand2, cache, "ooo")

    expect(responseArray2[0]).to eq(ResponseConstants::NOT_STORED)
    expect(cache.get("key2")).to eq(false)
  end

  it "executes the PREPEND command" do
    cache = Cache.new
    cache.set(key: "key", value: "xx", ttl: 3, whitespace: 2)
    commandString = "prepend key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "oo")

    expect(responseArray[0]).to eq(ResponseConstants::STORED)
    expect(cache.get("key").value).to eq("ooxx")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(4)

    # when the key does not exists
    commandString2 = "prepend key2 0 200 3"
    mapCommand2 = CommandTranslateUtil.translateCommand(commandString2)
    responseArray2 = CommandExecuteUtil.execute(mapCommand2, cache, "ooo")

    expect(responseArray2[0]).to eq(ResponseConstants::NOT_STORED)
    expect(cache.get("key2")).to eq(false)
  end

  it "executes the CAS command" do
    cache = Cache.new
    cache.memory["key"] = Item.new(value: "xx", casToken: 1, ttl: 3, whitespace: 2, flags: 0)
    commandString = "cas key 0 3600 2 1"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "oo")

    expect(responseArray[0]).to eq(ResponseConstants::STORED)
    expect(cache.get("key").value).to eq("oo")
    expect(cache.get("key").ttl).to eq(3600)
    expect(cache.get("key").flags).to eq(0)
    expect(cache.get("key").whitespace).to eq(2)

    # when the key does not exists
    commandString2 = "cas key2 0 200 3 1"
    mapCommand2 = CommandTranslateUtil.translateCommand(commandString2)
    responseArray2 = CommandExecuteUtil.execute(mapCommand2, cache, "ooo")

    expect(responseArray2[0]).to eq(ResponseConstants::NOT_FOUND)
    expect(cache.get("key2")).to eq(false)

    #when the casToken does not match
    cache.memory["key3"] = Item.new(value: "xx", casToken: 1, ttl: 3, whitespace: 2, flags: 0)
    commandString3 = "cas key3 0 200 3 2"
    mapCommand3 = CommandTranslateUtil.translateCommand(commandString3)
    responseArray3 = CommandExecuteUtil.execute(mapCommand3, cache, "ooo")

    expect(responseArray3[0]).to eq(ResponseConstants::EXISTS)
    expect(cache.get("key3").value).to eq("xx")
    expect(cache.get("key3").ttl).to eq(3)
    expect(cache.get("key3").flags).to eq(0)
    expect(cache.get("key3").whitespace).to eq(2)
  end

  it "executes the GET command" do
    cache = Cache.new
    cache.set(key: "key", value: "xx", ttl: 3, whitespace: 2)
    cache.set(key: "key2", value: 200, ttl: 6, whitespace: 3)
    commandString = "get key key2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache)

    expect(responseArray[0]).to eq("VALUE key 0 2")
    expect(responseArray[1]).to eq("xx")
    expect(responseArray[2]).to eq("VALUE key2 0 3")
    expect(responseArray[3]).to eq("200")
    expect(responseArray[4]).to eq(ResponseConstants::END_)
  end

  it "executes the GETS command" do
    cache = Cache.new
    cache.memory["key"] = Item.new(value: "xx", casToken: 1, whitespace: 2, ttl: 20)
    cache.memory["key2"] = Item.new(value: 200, casToken: 2, whitespace: 3, ttl: 20)
    commandString = "gets key key2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache)

    expect(responseArray[0]).to eq("VALUE key 0 2 1")
    expect(responseArray[1]).to eq("xx")
    expect(responseArray[2]).to eq("VALUE key2 0 3 2")
    expect(responseArray[3]).to eq("200")
    expect(responseArray[4]).to eq(ResponseConstants::END_)
  end

  it "executes a 'bad data chunk' CLIENT_ERROR" do
    cache = Cache.new
    commandString = "add key 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xxx")    # value whitespace (3) exceeds the given whitespace (2)

    expect(responseArray[0]).to eq("#{ResponseConstants::CLIENT_ERROR} #{ResponseConstants::BAD_DATA_ERROR}")
  end

  it "executes an ERROR" do
    cache = Cache.new
    commandString = "set 0 3600 2"
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache)

    expect(responseArray[0]).to eq(ResponseConstants::ERROR)
  end

  it "executes a NOT_STORED" do
    cache = Cache.new
    commandString = "replace key 0 3600 2"  # replace must not get stored as the key does not exist yet
    mapCommand = CommandTranslateUtil.translateCommand(commandString)
    responseArray = CommandExecuteUtil.execute(mapCommand, cache, "xx")

    expect(responseArray[0]).to eq(ResponseConstants::NOT_STORED)
  end
end
