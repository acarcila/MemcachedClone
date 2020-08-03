require_relative "CommandTranslateUtil"

RSpec.describe CommandTranslateUtil do
  it "translates the SET command" do
    commandString = "set key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("set")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates the Add command" do
    commandString = "add key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("add")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates the Replace command" do
    commandString = "replace key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("replace")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates the Append command" do
    commandString = "append key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("append")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates the Prepend command" do
    commandString = "prepend key 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("prepend")
    expect(command["keys"][0]).to eq("key")
    expect(command["flags"]).to eq(0)
    expect(command["ttl"]).to eq(3600)
    expect(command["whitespace"]).to eq(2)
  end

  it "translates the Get command" do
    commandString = "get key"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("get")
    expect(command["keys"][0]).to eq("key")

    # multiple key
    commandString = "get key1 key2 key3"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("get")
    expect(command["keys"]).to eq(["key1", "key2", "key3"])
  end

  it "translates the Gets command" do
    commandString = "gets key"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("gets")
    expect(command["keys"][0]).to eq("key")

    # multiple key
    commandString = "gets key1 key2 key3"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["command"]).to eq("gets")
    expect(command["keys"]).to eq(["key1", "key2", "key3"])
  end

  it "updates status" do
    commandString = "set 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["status"]).to eq("ERROR")

    commandString = "set key key2 0 3600 2"
    command = CommandTranslateUtil.translateCommand(commandString)

    expect(command["status"]).to eq("CLIENT_ERROR")
  end
end
